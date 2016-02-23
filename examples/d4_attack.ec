require import Byte.

module M = {
  proc main(a,b: byte) : byte = {
    var a0,a1,a2,a3,a4: byte;
    var b0,b1,b2,b3,b4: byte;
    var r0,r1,r2,r3,r4: byte;
    var c0,c1,c2,c3,c4: byte;
    var tmp: byte;
    
    (* Presharing x *)
    a0 = $distr;
    a1 = $distr;
    a2 = $distr;
    a3 = $distr;
    a4 =  a ^ a0^a1^a2^a3;
    b0 = $distr;
    b1 = $distr;
    b2 = $distr;
    b3 = $distr;
    b4 = b ^ b0^b1^b2^b3;
     
    r0 = $distr;
    r1 = $distr;
    r2 = $distr;
    r3 = $distr;
    r4 = $distr;

    (* Mult *)
    c0 = a0*b0;
    c0 = c0^r0;
    tmp = a0*b1;
    c0 = c0^tmp;
    tmp = a1*b0;
    c0 = c0^tmp;
    c0 = c0^r1;
    tmp = a0*b2;
    c0 = c0^tmp;
    tmp = a2*b0;
    c0 = c0^tmp;
    
    c1 = a1*b1;
    c1 = c1^r1;
    tmp = a1*b2;
    c1 = c1^tmp;
    tmp = a2*b1;
    c1 = c1^tmp;
    c1 = c1^r2;
    tmp = a1*b3;
    c1 = c1^tmp;
    tmp = a3*b1;
    c1 = c1^tmp;
    
    c2 = a2*b2;
    c2 = c2^r2;  
    tmp = a2*b3;
    c2 = c2^tmp;
    tmp = a3*b2;
    c2 = c2^tmp;
    c2 = c2^r3;  
    tmp = a2*b4;
    c2 = c2^tmp;
    tmp = a4*b2;
    c2 = c2^tmp;
    
    c3 = a3*b3;
    c3 = c3^r3;
    tmp = a3*b4;
    c3 = c3^tmp;
    tmp = a4*b3;
    c3 = c3^tmp;
    c3 = c3^r4;
    tmp = a3*b0;
    c3 = c3^tmp;
    tmp = a0*b3;
    c3 = c3^tmp;
    
    c4 = a4*b4;
    c4 = c4^r0;
    tmp = a4*b0;
    c4 = c4^tmp;
    tmp = a0*b4;
    c4 = c4^tmp;
    c4 = c4^r4;
    tmp = a4*b1;
    c4 = c4^tmp;
    tmp = a1*b4;
    c4 = c4^tmp;
    
    return (c0^c1^c2^c3^c4);
  }
}.

hoare correct _a _b: M.main: a = _a /\ b = _b ==> res = _a * _b.
proof. by proc; auto; progress; algebra. qed. 

masking 4 M.main (^).
