require import Byte.

module M = {
  proc main(a,b: byte) : byte = {
    var a0,a1,a2,a3,a4,a5: byte;
    var b0,b1,b2,b3,b4,b5: byte;
    var r05,r03,r01,r15,r13,r25,r23,r35,r45,r4,r2: byte;
    var c0,c1,c2,c3,c4,c5: byte;
    var tmp: byte;
    
    (* Presharing x *)
    a0 = $distr;
    a1 = $distr;
    a2 = $distr;
    a3 = $distr;
    a4 = $distr;
    a5 =  a ^ a0^a1^a2^a3^a4;
    b0 = $distr;
    b1 = $distr;
    b2 = $distr;
    b3 = $distr;
    b4 = $distr;
    b5 = b ^ b0^b1^b2^b3^b4;
     
    r05 = $distr;
    r03 = $distr;
    r01 = $distr;
    r15 = $distr;
    r13 = $distr;
    r25 = $distr;
    r23 = $distr;
    r35 = $distr;
    r45 = $distr;
    r4 = $distr;
    r2 = $distr;
    
    
    (* Mult *)
    c0 = a0*b0;
    c0 = c0^r05;
    tmp = a0*b5;
    c0 = c0^tmp;
    tmp = a5*b0;
    c0 = c0^tmp;
    c0 = c0^r4;
    tmp = a0*b4;
    c0 = c0^tmp;
    tmp = a4*b0;
    c0 = c0^tmp;
    c0 = c0^r03;
    tmp = a0*b3;
    c0 = c0^tmp;
    tmp = a3*b0;
    c0 = c0^tmp;
    c0 = c0^r2;
    tmp = a0*b2;
    c0 = c0^tmp;
    tmp = a2*b0;
    c0 = c0^tmp;
    c0 = c0^r01;
    tmp = a0*b1;
    c0 = c0^tmp;
    tmp = a1*b0;
    c0 = c0^tmp;
    
    c1 = a1*b1;
    c1 = c1^r15;
    tmp = a1*b5;
    c1 = c1^tmp;
    tmp = a5*b1;
    c1 = c1^tmp;
    c1 = c1^r4;
    tmp = a1*b4;
    c1 = c1^tmp;
    tmp = a4*b1;
    c1 = c1^tmp;
    c1 = c1^r13;
    tmp = a1*b3;
    c1 = c1^tmp;
    tmp = a3*b1;
    c1 = c1^tmp;
    c1 = c1^r2;
    tmp = a1*b2;
    c1 = c1^tmp;
    tmp = a2*b1;
    c1 = c1^tmp;
    c1 = c1^r01;
    
    c2 = a2*b2;
    c2 = c2^r25;  
    tmp = a2*b5;
    c2 = c2^tmp;
    tmp = a5*b2;
    c2 = c2^tmp;
    c2 = c2^r23;  
    tmp = a2*b4;
    c2 = c2^tmp;
    tmp = a4*b2;
    c2 = c2^tmp;
    c2 = c2^r4;  
    tmp = a2*b3;
    c2 = c2^tmp;
    tmp = a3*b2;
    c2 = c2^tmp;
    
    c3 = a3*b3;
    c3 = c3^r35;
    tmp = a3*b5;
    c3 = c3^tmp;
    tmp = a5*b3;
    c3 = c3^tmp;
    c3 = c3^r4;
    tmp = a3*b4;
    c3 = c3^tmp;
    tmp = a4*b3;
    c3 = c3^tmp;
    c3 = c3^r23;
    c3 = c3^r13;
    c3 = c3^r03;
    
    c4 = a4*b4;
    c4 = c4^r45;
    tmp = a4*b5;
    c4 = c4^tmp;
    tmp = a5*b4;
    c4 = c4^tmp;

    c5 = a5*b5;
    c5 = c5^r45;
    c5 = c5^r35;
    c5 = c5^r25;
    c5 = c5^r15;
    c5 = c5^r05;
    
    return (c0^c1^c2^c3^c4^c5);
  }
}.

hoare correct _a _b: M.main: a = _a /\ b = _b ==> res = _a * _b.
proof. by proc; auto; progress; algebra. qed.

masking 5 M.main (^).
