#!/usr/bin/env python2

"""
Library to support our description language compression algorithms for
d-private multiplication

Example of text description (txt_desc)

s00 (B02 A01)
a11 B12 r01
a22 r2

where:
rxy -> a random
sij -> a_i b_j  (i, j hexadecimal digits) (= \alpha_{i,j} in the paper)
aij -> a_i b_j + a_j b_i, when i != j, otherwise a_i b_i
Aij -> rij + aij
Bij -> rj + aij

The order d = number of lines - 1.

This description can be converted to a list description desc using get_desc.
In desc, there are only rxy, aij, and sij terms.

WARNING: each a_i b_j should appear exactly once.

This library also contains helper functions
get_txt_desc_...
to generate classical text description
"""

import sys
import os
import re
from abc import ABCMeta

from pyparsing import Word, alphanums, infixNotation, opAssoc

scriptdir = os.path.dirname(
    os.path.realpath(__file__ if '__file__' in globals() else sys.argv[0]))
sys.path.append(scriptdir)
import visitor

class DescBaseNode(object):
    """
    Abstract base class for nodes of the AST representing the
    expression of each output share c_i
    """
    __metaclass__ = ABCMeta

    @classmethod
    def get_parse_action(cls):
        raise NotImplementedError()

class DescXorNode(DescBaseNode): 
    def __init__(self, children):
        self.children = children

    def __repr__(self):
        return "xor({})".format(repr(self.children))

    @classmethod
    def get_parse_action(cls):
        def fn(s, loc, toks):
            del s, loc
            return cls(list(toks[0]))
        return fn

class DescValNode(DescBaseNode):
    @classmethod
    def get_parse_action(cls):
        def fn(s, loc, toks):
            if toks[0][0] == "r":
                return DescValrNode.parse(s, loc, toks[0])
            else:
                return DescValCoordNode.parse(s, loc, toks[0])
        return fn

class DescValrNode(DescValNode):
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return "r({})".format(repr(self.name))

    @classmethod
    def parse(cls, s, loc, toks):
        del s
        if len(toks) < 2 or toks[0] != "r":
            raise SyntaxError("Syntax error on location {}:" \
                              "invalid r value '{}'".format(loc, toks))
        return cls(toks[1:])

class DescValCoordNode(DescValNode):
    """ Represent a value of the form tij where 
    - t = a, s, ... (see t_list)
    - i, j are hexadecimal digits"""
    __metaclass__ = ABCMeta

    t_list = ["a", "s"]

    def __init__(self, t, i, j):
        self.t = t
        self.i = i
        self.j = j

    def __repr__(self):
        return "{}({},{})".format(self.t, self.i, self.j)

    @classmethod
    def parse(cls, s, loc, toks):
        del s
        hexnums = "0123456789abcdef"
        if len(toks) != 3 or \
           toks[0] not in cls.t_list or \
           toks[1] not in hexnums or toks[2] not in hexnums:
            raise SyntaxError("Syntax error on {}: invalid a/s value '{}'" \
                              .format(loc, toks))
        return cls(toks[0], int(toks[1], 16), int(toks[2], 16))

term_bnf = None
def get_term_bnf():
    global term_bnf
    if not term_bnf:
        val = Word(alphanums).setParseAction(DescValNode.get_parse_action())
        term_bnf = infixNotation(
            val,
            [
                (None, 2, opAssoc.LEFT, DescXorNode.get_parse_action())
            ]
        )
    return term_bnf

def get_desc(txt_desc):
    """
    Convert a text description into a DescBaseNode list description
    (see module's description)
    """
    
    desc = [get_desc_line(line) for line in txt_desc.strip().split("\n")]
    return desc

def get_desc_line(line):
    """ Return a DescBaseNode description from a line of a text description """
    line = re.sub(r"A([0-9a-z])([0-9a-z])", r"r\1\2 a\1\2", line)
    line = re.sub(r"B([0-9a-z])([0-9a-z])", r"r\2 a\1\2", line)
    return get_term_bnf().parseString(line, parseAll=True)[0]

def get_r_names(desc):
    """
    Return a dictionnary of the random values used: keys are the
    original name, values are an integer index
    """
    class V(object):
        def __init__(self, desc):
            self.r_names = {}
            self.desc = desc
            for share in self.desc:
                self.visit(share)

        @visitor.on('node')
        def visit(self, node):
            pass

        @visitor.when(object)
        def visit(self, node):
            raise NotImplementedError("{}".format(repr(node)))

        @visitor.when(DescXorNode)
        def visit(self, node):
            for child in node.children:
                self.visit(child)

        @visitor.when(DescValCoordNode)
        def visit(self, node):
            pass

        @visitor.when(DescValrNode)
        def visit(self, node):
            if node.name not in self.r_names:
                self.r_names[node.name] = len(self.r_names)

    return V(desc).r_names

def test_correctness(desc):
    """
    Return True if the description desc is correct, i.e., if we get
    d+1 shares of the product if we sum all shares; and return False
    otherwise and print an error message explaining the problem.
    """

    class V(object):
        def __init__(self, desc):
            self.desc = desc
            self.d = len(desc) - 1
            self.set_ab = set()
            self.set_r = set()
            for share in self.desc:
                self.visit(share)

        @visitor.on('node')
        def visit(self, node):
            pass

        @visitor.when(object)
        def visit(self, node):
            raise NotImplementedError("{}".format(repr(node)))

        @visitor.when(DescXorNode)
        def visit(self, node):
            for child in node.children:
                self.visit(child)

        @visitor.when(DescValCoordNode)
        def visit(self, node):
            if node.i not in range(self.d+1) \
               or node.j not in range(self.d+1):
                raise ValueError("Invalid term '{}'".format(repr(node)))
            if (node.i, node.j) in self.set_ab:
                print("CORRECTNESS ERROR: 2 times '{}'" \
                      .format(repr(node)))
                return False
            self.set_ab.add((node.i, node.j))
            if node.t == "a" and node.i != node.j:
                if (node.j, node.i) in self.set_ab:
                    print("CORRECTNESS ERROR: 2 times '{}'"\
                          .format(repr(node)))
                    return False
                self.set_ab.add((node.j, node.i))

        @visitor.when(DescValrNode)
        def visit(self, node):
            if node.name in self.set_r:
                self.set_r.remove(node.name)
            else:
                self.set_r.add(node.name)

        def is_correct(self):
            if len(self.set_r) != 0:
                print(
                    "CORRECTNESS ERROR: random values do not disappear '{}'" \
                    .format(self.set_r)
                )
                return False
            if len(self.set_ab) != (self.d+1) * (self.d+1):
                print(
                    "CORRECTNESS ERROR: some values aij are missing: {}"\
                    .format(
                        repr(
                            set([
                                (i, j)
                                for i in range(self.d+1)
                                for j in range(self.d+1)
                            ])
                            -
                            self.set_ab
                        )
                    )
                )
                return False
            return True

    return V(desc).is_correct()



def get_txt_desc_1(d):
    """
    Generate the description of the new construction before the
    randomness re-use
    """
    txt_desc = ""
    for i in range(d+1):
        txt_desc += "a{:x}{:x} ".format(i, i)
        for j in range(i+1, d+1):
            txt_desc += "A{:x}{:x} ".format(i, j)
        for j in range(i):
            txt_desc += "r{:x}{:x} ".format(j, i)
        txt_desc += "\n"
    return txt_desc

def get_txt_desc_2(d):
    """
    Generate the description of the new construction with randomness
    re-use
    """
    txt_desc = ""
    for i in range(d+1):
        txt_desc += "a{:x}{:x} ".format(i, i)
        for j in range(d, i, -1):
            txt_desc += "{}{:x}{:x} "\
                        .format("A" if (d-j)%2 == 0 else "B", i, j)
        if (d-i)%2 == 1 and i > 0:
            if d%2 == 0:
                txt_desc += "r{:x} ".format(i)
        else:    
            for j in range(i-1, -1, -1):
                txt_desc += "r{:x}{:x} ".format(j, i)
        txt_desc += "\n"
    return txt_desc


