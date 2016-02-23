
require import Byte.

module M = {
  proc main(a,b: byte) : byte = {
    var a0,a1,a2,a3: byte;
    var b0,b1,b2,b3: byte;
    var r03,r2,r13,r23:byte;
    var c0,c1,c2,c3: byte;
    var tmp:byte;
    (* Presharing x *)
    a0 = $distr;
    a1 = $distr;
    a2 = $distr;
    a3 =  a ^ a0^a1^a2;
    b0 = $distr;
    b1 = $distr;
    b2 = $distr;
    b3 = b ^ b0^b1^b2;
     
    r03 = $distr;
    r13 = $distr;
    r2 = $distr;
    r23 = $distr;


    tmp = a0 * b0;
    c0 = tmp;
    c0 = c0 ^ r03;
    tmp = a0 * b3;
    c0 = c0 ^ tmp;
    tmp = a3 * b0;
    c0 = c0 ^ tmp;
    c0 = c0 ^ r2;
    tmp = a0 * b2;
    c0 = c0 ^ tmp;
    tmp = a2 * b0;
    c0 = c0 ^ tmp;

    tmp = a1 * b1;
    c1 = tmp;
    c1 = c1 ^ r2;
    tmp = a1 * b3;
    c1 = c1 ^ tmp;
    tmp = a3 * b1;
    c1 = c1 ^ tmp;
    c1 = c1 ^ r13;
    tmp = a1 * b2;
    c1 = c1 ^ tmp;
    tmp = a2 * b1;
    c1 = c1 ^ tmp;

    tmp = a2 * b2;
    c2 = tmp;
    c2 = c2 ^ r23;
    tmp = a2 * b3;
    c2 = c2 ^ tmp;
    tmp = a3 * b2;
    c2 = c2 ^ tmp;

    tmp = a3 * b3;
    c3 = tmp;
    c3 = c3 ^ r23;
    c3 = c3 ^ r13;
    c3 = c3 ^ r03;
    tmp = a0 * b1;
    c3 = c3 ^ tmp;
    tmp = a1 * b0;
    c3 = c3 ^ tmp;
    return (c0^c1^c2^c3);
  }
}.

hoare correct _a _b: M.main: a = _a /\ b = _b ==> res = _a * _b.
proof. by proc; auto; progress; algebra. qed.

masking 3 M.main (^).
