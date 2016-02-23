load("lib_desc.py")

def get_probes(desc):
    """ 
    Return all the possible probes of a given description.
    More precisely, it returns a tuple with:
    - d
    - probes_r: matrix with randoms (col = probe, row = random)
    - probes_sh: list of matrices indicating the i, j obtained
                 probes_sh[probe][i, j] = 1 iff 
                 the probe-th probe of probes_r contains a_i b_j
                 M_{i',j'} < N_{i', j'} 
    - probes_expl: list of explanations 
                 (human-readable strings corresponding to each probe)
    """

    class V(object):
        def __init__(self, desc):
            self.desc = desc
            self.d = len(desc) - 1

            self.r_names = get_r_names(desc)
            self.r_nb = len(self.r_names)

            self.K = GF(2)
            self.probes_r = []
            # list of vector of randoms in probes
            #    (will be transformed to a matrix later)
            self.probes_sh = []
            self.probes_expl = []

            for (r_name, i) in self.r_names.iteritems():
                probe_r = vector(self.K, self.r_nb)
                probe_sh = matrix(self.K, self.d+1)
                probe_r[i] = 1
                self.probes_r.append(probe_r)
                self.probes_sh.append(probe_sh)
                self.probes_expl.append("r" + r_name)
    
            for (nshare, share) in enumerate(self.desc):
                self.nshare = nshare
                self.end_expl = "- in c{:x}".format(self.nshare)
                self.visit(
                    share,
                    vector(self.K, self.r_nb),
                    matrix(self.K, self.d+1),
                    ""
                )

        @visitor.on('node')
        def visit(self, node, probe_r, probe_sh, probe_expl):
            pass

        @visitor.when(object)
        def visit(self, node, probe_r, probe_sh, probe_expl):
            raise NotImplementedError("{}".format(repr(node)))

        @visitor.when(DescXorNode)
        def visit(self, node, probe_r, probe_sh, probe_expl):
            np_r = vector(self.K, self.r_nb)
            np_sh = matrix(self.K, self.d+1)
            np_expl = ""
            for (nchild, child) in enumerate(node.children):
                (np_r, np_sh, np_expl) = self.visit(child, np_r, np_sh, np_expl)

                if np_r.is_zero():
                    # deterministic terms (i.e., with no random inside)
                    if sum(col.hamming_weight() for col in np_sh) >= 2:
                        print "Trivial attack because of {}"\
                            .format(np_expl + self.end_expl)
                else:
                    # we do not add terms with no random inside
                    # (called deterministic in the paper)
                    # such term contain at most 1 indice a/b
                    # (otherwise, there is a trivial attack - case above)

                    self.probes_r.append(copy(np_r))
                    self.probes_sh.append(copy(np_sh))
                    self.probes_expl.append(np_expl + self.end_expl)

            return (probe_r + np_r, probe_sh + np_sh, probe_expl + np_expl)

        @visitor.when(DescValCoordNode)
        def visit(self, node, probe_r, probe_sh, probe_expl):
            # node is either a "a"-node (node.t == "a"): aij = sij sji
            # or just a "s"-node (node.t == "s")
            i = node.i
            j = node.j
            if probe_sh[i, j] == 1 or \
               (node.t == "a" and probe_sh[j, i] == 1):
                print(
                    "ERROR: a{:x}{:x} twice in the same share c{}"\
                    .format(i, j, self.nshare)
                )
            probe_sh[i, j] = 1
            
            if node.t == "a" and i != j:
                # for a "a"-node, we can probe between sij and sji
                self.probes_r.append(copy(probe_r))
                self.probes_sh.append(copy(probe_sh))
                self.probes_expl.append(
                    probe_expl + \
                    "s{:x}{:x} ".format(node.i, node.j) + \
                    self.end_expl
                )

                probe_sh[j, i] = 1
                
            probe_expl += "{}{:x}{:x} ".format(node.t, node.i, node.j)
            return (probe_r, probe_sh, probe_expl)
            

        @visitor.when(DescValrNode)
        def visit(self, node, probe_r, probe_sh, probe_expl):
            probe_r[self.r_names[node.name]] += 1
            probe_expl += "r{} ".format(node.name)
            return (probe_r, probe_sh, probe_expl)

        def get_probes(self):
            return (
                self.d,
                matrix(self.probes_r).transpose(),
                self.probes_sh,
                self.probes_expl
            )
    
    return V(desc).get_probes()
