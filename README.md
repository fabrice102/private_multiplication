# Automatic Tool for Finding Attacks to Compression Algorithms for Multiplication

**Authors**: Sonia Belaïd, Fabrice Benhamouda, Alain Passelègue, Emmanuel Prouff, Adrian Thillard, and Damien Vergnaud

A presentation of this tool is given in the paper *Randomness Complexity of Private Circuits for Multiplication*, Eurocrypt 2016.

## Getting started

### Requirements

Sage version 6.8 (http://www.sagemath.org - not tested with any other version).

### Use it

We suppose that this folder is `~/projects/isw/tools`.

Run

    SAGE_PATH=~/projects/isw/tools sage

Example notebook:

    # Load the tools
    load_attach_path("~/projects/isw/tools")
    load("tools.sage")

    load("test_security.spyx")

    # Text description of the scheme (see below)
    txt_desc = """s00 B02 A01
        a11 B12 r01
        a22 r2"""

    # Check correctness + generate internal representations
    desc = get_desc(txt_desc)
    print "Correct" if test_correctness(desc) else "ERROR"
    probes_desc = (d, probes_r, probes_sh, probes_expl) = get_probes(desc)

    # Actual security test (%time can be used to time the test)
    %time
    test_security1(*probes_desc)

## Test description of algorithms

The text description is explained in the `lib_desc.py` file.

There are at least 3 ways of generating them:

- explicitely as a string:

        txt_desc = """s00 B02 A01
            a11 B12 r01
            a22 r2"""

- using helper functions `get_txt_desc_...` in `lib_desc.py`

        txt_desc = get_txt_desc_2(4)

- from a file:

        with open("full/path/to/examples/d2_26-08_attack.txt") as f:
            txt_desc = f.read()

## Contents

- `README.md`: documentation (this file)
- `lib_desc.py`, `tools.sage`, `test_security.spyx`: actual tool
- `visitor.py`: required third-party library for the visitor patterm
- `examples/`: examples for this tool (`*.txt`) and their EasyCrypt counterparts (`*.ec`) (for the tool from Gilles Barthe, Sonia Belaïd, François Dupressoir, Pierre-Alain Fouque, Benjamin Grégoire, Pierre-Yves Strub. Verified Proofs of Higher-Order Masking. Eurocrypt 2015) - see `examples/README.md`

## Troobleshooting

If you get the error message `ImportError: No module named visitor`, this usually means you did not set correctly the environment variable `SAGE_PATH` to this folder.

## Misc

- The extension `.spyx` is used to force Sage to compile the file. This makes execution faster but loading much longer. For tests purposes, you can create symlinks with extension `.sage` and load these symlinks instead of the original `.spyx` files.
- Profiling the test

        import cProfile, pstats
        cProfile.runctx("test_security1(d, probes_r, probes_sh, probes_expl)", globals(), locals(), DATA + "Profile.prof")
        s = pstats.Stats(DATA + "Profile.prof")
        s.strip_dirs().sort_stats("time").print_stats()


