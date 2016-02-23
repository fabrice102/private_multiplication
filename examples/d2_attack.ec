require import Byte.

module M = {
  proc main(a,b: byte) : byte = {
    var a0,a1,a2;
    var b0,b1,b2;
    var r0, r1;
    var c0,c1,c2;
    var tmp:byte;
    (* Presharing x *)
    a0 = $distr;
    a1 = $distr;
    a2 =  a ^ a0^a1;
    b0 = $distr;
    b1 = $distr;
    b2 = b ^ b0^b1;
     
    r0 = $distr;
    r1 = $distr;

    c0 = a0 * b0;
    c0 = c0 ^ r0;
    tmp = a0 * b2;
    c0 = c0 ^ tmp;
    tmp = a2 * b0;
    c0 = c0 ^ tmp;

    c1 = a1 * b1;
    c1 = c1 ^ r1;
    tmp = a0 * b1;
    c1 = c1 ^ tmp;
    tmp = a1 * b0;
    c1 = c1 ^ tmp;

    c2 = a2 * b2;
    c2 = c2 ^ r1;
    c2 = c2 ^ r0;
    tmp = a1 * b2;
    c2 = c2 ^ tmp;
    tmp = a2 * b1;
    c2 = c2 ^ tmp;
  
    return (c0^c1^c2);
  }
}.

hoare correct _a _b: M.main: a = _a /\ b = _b ==> res = _a * _b.
proof. by proc; auto; progress; algebra. qed.

masking 2 M.main (^).
