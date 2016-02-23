require import Byte.

module M = {
  proc main(a,b: byte) : byte = {
    var a0,a1,a2,a3,a4,a5,a6;
    var b0,b1,b2,b3,b4,b5,b6;
    var r06,r04,r02,r16,r14,r12,r26,r24,r36,r34,r46,r56,r5,r3,r1: byte;
    var c0,c1,c2,c3,c4,c5,c6;
    var tmp: byte;
    
    (* Presharing x *)
    a0 = $distr;
    a1 = $distr;
    a2 = $distr;
    a3 = $distr;
    a4 = $distr;
    a5 = $distr;
    a6 =  a ^ a0^a1^a2^a3^a4^a5;
    b0 = $distr;
    b1 = $distr;
    b2 = $distr;
    b3 = $distr;
    b4 = $distr;
    b5 = $distr;
    b6 = b ^ b0^b1^b2^b3^b4^b5;
     
    r06 = $distr;
    r04 = $distr;
    r02 = $distr;
    r16 = $distr;
    r14 = $distr;
    r12 = $distr;
    r26 = $distr;
    r24 = $distr;
    r36 = $distr;
    r34 = $distr;
    r46 = $distr;
    r56 = $distr;
    r5 = $distr;
    r3 = $distr;
    r1 = $distr;
    
    (* Mult *)
    c0 = a0*b0;
    c0 = c0^r06;
    tmp = a0*b6;
    c0 = c0^tmp;
    tmp = a6*b0;
    c0 = c0^tmp;
    c0 = c0^r5;
    tmp = a0*b5;
    c0 = c0^tmp;
    tmp = a5*b0;
    c0 = c0^tmp;
    c0 = c0^r04;
    tmp = a0*b4;
    c0 = c0^tmp;
    tmp = a4*b0;
    c0 = c0^tmp;
    c0 = c0^r3;
    tmp = a0*b3;
    c0 = c0^tmp;
    tmp = a3*b0;
    c0 = c0^tmp;
    c0 = c0^r02;
    tmp = a0*b2;
    c0 = c0^tmp;
    tmp = a2*b0;
    c0 = c0^tmp;
    c0 = c0^r1;
    tmp = a0*b1;
    c0 = c0^tmp;
    tmp = a1*b0;
    c0 = c0^tmp;
    
    c1 = a1*b1;
    c1 = c1^r16;
    tmp = a1*b6;
    c1 = c1^tmp;
    tmp = a6*b1;
    c1 = c1^tmp;
    c1 = c1^r5;
    tmp = a1*b5;
    c1 = c1^tmp;
    tmp = a5*b1;
    c1 = c1^tmp;
    c1 = c1^r14;
    tmp = a1*b4;
    c1 = c1^tmp;
    tmp = a4*b1;
    c1 = c1^tmp;
    c1 = c1^r3;
    tmp = a1*b3;
    c1 = c1^tmp;
    tmp = a3*b1;
    c1 = c1^tmp;
    c1 = c1^r12;
    tmp = a1*b2;
    c1 = c1^tmp;
    tmp = a2*b1;
    c1 = c1^tmp;
    c1 = c1^r1;
    
    c2 = a2*b2;
    c2 = c2^r26;
    tmp = a2*b6;
    c2 = c2^tmp;
    tmp = a6*b2;
    c2 = c2^tmp;
    c2 = c2^r5;
    tmp = a2*b5;
    c2 = c2^tmp;
    tmp = a5*b2;
    c2 = c2^tmp;
    c2 = c2^r24;
    tmp = a2*b4;
    c2 = c2^tmp;
    tmp = a4*b2;
    c2 = c2^tmp;
    c2 = c2^r3;
    tmp = a2*b3;
    c2 = c2^tmp;
    tmp = a3*b2;
    c2 = c2^tmp;
    c2 = c2^r12;
    c2 = c2^r02;
    
    c3 = a3*b3;
    c3 = c3^r36;
    tmp = a3*b6;
    c3 = c3^tmp;
    tmp = a6*b3;
    c3 = c3^tmp;
    c3 = c3^r34;
    tmp = a3*b5;
    c3 = c3^tmp;
    tmp = a5*b3;
    c3 = c3^tmp;
    c3 = c3^r5;
    tmp = a3*b4;
    c3 = c3^tmp;
    tmp = a4*b3;
    c3 = c3^tmp;
    c3 = c3^r3;
    
    c4 = a4*b4;
    c4 = c4^r46;
    tmp = a4*b6;
    c4 = c4^tmp;
    tmp = a6*b4;
    c4 = c4^tmp;
    c4 = c4^r5;
    tmp = a4*b5;
    c4 = c4^tmp;
    tmp = a5*b4;
    c4 = c4^tmp;
    c4 = c4^r34;
    c4 = c4^r24;
    c4 = c4^r14;
    c4 = c4^r04;

    c5 = a5*b5;
    c5 = c5^r56;
    tmp = a5*b6;
    c5 = c5^tmp;
    tmp = a6*b5;
    c5 = c5^tmp;
    c5 = c5^r5;
    
    c6 = a6*b6;
    c6 = c6^r56;
    c6 = c6^r46;
    c6 = c6^r36;
    c6 = c6^r26;
    c6 = c6^r16;
    c6 = c6^r06;
    
    return (c0^c1^c2^c3^c4^c5^c6);
  }
}.

hoare correct _a _b: M.main: a = _a /\ b = _b ==> res = _a * _b.
proof. by proc; auto; progress; algebra. qed.

masking 6 M.main (^).
