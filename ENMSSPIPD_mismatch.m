clear all
close all;
clc;
q=1;

% 
  am11=0.9355;am12=0.9355;am21=0.9672;am22=0.9512;
  az11=0.06449;az12=0.05288;az21=0.02557;az22=0.04877;

%case 1
% am11=1.0134;am12=0.8275;am21=0.9492;am22=1.0016;
 %az11=0.07232;az12=0.04971;az21=0.02716;az22=0.04901;

Am11=1.0134;Am12=0.8275;Am21=0.9492;Am22=1.0016;
Az11=0.07232;Az12=0.04971;Az21=0.02716;Az22=0.04901;

%case 2
% am11=0.8324;am12=0.8117;am21=0.9713;am22=1.0295;
% az11=0.05556;az12=0.05521;az21=0.02383;az22=0.05254;

%case 3
% am11=1.0517;am12=0.9522;am21=0.9387;am22=0.9473;
% az11=0.07169;az12=0.04618;az21=0.02823;az22=0.04599;

% am11=0.9355+0.05*0.9355*2*(rand(1)-0.5);am12=0.9355+0.05*0.9355*2*(rand(1)-0.5);am21=0.9672+0.05*0.9672*2*(rand(1)-0.5);am22=0.9512+0.05*0.9512*2*(rand(1)-0.5);
% az11=0.06449+0.05*0.06449*2*(rand(1)-0.5);az12=0.0/5288+0.05*0.05288*2*(rand(1)-0.5);az21=0.02557+0.05*0.02557*2*(rand(1)-0.5);az22=0.04877+0.05*0.04877*2*(rand(1)-0.5);
%模型参数

%z(k)=[dy1(k);dy2(k);dy1(k-1);dy2(k-1);du1(k-1);du2(k-1);du1(k-2);du2(k-2);du1(k-3);du2(k-3);e1(k);e2(k)];
A=[am11+am12  0    -(am11*am12) 0      0     az12     az11 -(am11*az12) -(az11*am12)  0     0      0;
   0      am21+am22     0 -(am21*am22) 0     az22     az21 -(am21*az22) -(az21*am22)  0     0      0;
   1          0         0       0      0       0       0        0        0            0     0      0;
   0          1         0       0      0       0       0        0        0            0     0      0;
   0          0         0       0      0       0       0        0        0            0     0      0;
   0          0         0       0      0       0       0        0        0            0     0      0;
   0          0         0       0      1       0       0        0        0            0     0      0;
   0          0         0       0      0       1       0        0        0            0     0      0;
   0          0         0       0      0       0       1        0        0            0     0      0;
   0          0         0       0      0       0       0        1        0            0     0      0;
am11+am12     0     -(am11*am12) 0      0     az12     az11 -(am11*az12) -(az11*am12) 0     1      0;
   0      am21+am22     0 -(am21*am22) 0     az22     az21 -(am21*az22) -(az21*am22)  0     0      1];     
   
B=[0 0; 0 0; 0 0; 0 0; 1 0; 0 1; 0 0; 0 0; 0 0; 0 0; 0 0;0 0];
C=[0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; -1 0; 0 -1];
Np=6;
L=220;


 F=(A^Np);
 fai=A^(Np-1)*B;

 S=[A^(Np-1)*C];
 for k=2:Np
    S=[S A^(Np-k)*C];
 end
  Q=zeros(12,12);
 jiay11=2;jiay21=2;jiay12=1;jiay22=1;jiau11=0;jiau21=0;jiau12=0;jiau22=0;jiau13=0;jiau23=0;jiae1=1;jiae2=1;

 for i=1:Np
 Q(1,1)=jiay11;
 Q(2,2)=jiay21;
 Q(3,3)=jiay12;
 Q(4,4)=jiay22;
 Q(5,5)=jiau11;
 Q(6,6)=jiau21; 
 Q(7,7)=jiau12; 
 Q(8,8)=jiau22;
 Q(9,9)=jiau13;
 Q(10,10)=jiau23;
 Q(11,11)=jiae1; 
 Q(12,12)=jiae2; 
 end
 y1=zeros(L,1);
 y2=zeros(L,1);
 u1=zeros(L,1);
 u2=zeros(L,1);
 yy1=zeros(L,1);
 yy2=zeros(L,1);
 uu1=zeros(L,1);
 uu2=zeros(L,1);
 du1=zeros(L,1);
 du2=zeros(L,1);
 r1=zeros(Np,1);
 r2=zeros(Np,1);
 ee1=zeros(L,1);
 ee2=zeros(L,1);
 beta1=0.9;
 beta2=0.9;
 gama=[0.1 0;0 0.1];
 c1=1;c2=1;
%c1=0;c2=0;
 v1=zeros(L,1);
 for i=1:L
     v1(i)=0;
 end
 UU=zeros(2,1);
 Z=zeros(12,1);
 R=zeros(2*Np,1);
 E=zeros(8,2);
 W=zeros(8,1);
 e=zeros(L,2);
 kp=zeros(L,2);
 ki=zeros(L,2);
 kd=zeros(L,2);


 for k=10:L
     y1(k)=(Am11+Am12)*y1(k-1)-(Am11*Am12)*y1(k-2)+Az11*u1(k-3)-(Az11*Am12)*u1(k-4)+Az12*u2(k-2)-(Am11*Az12)*u2(k-3);
     y2(k)=(Am21+Am22)*y2(k-1)-(Am21*Am22)*y2(k-2)+Az21*u1(k-3)-(Az21*Am22)*u1(k-4)+Az22*u2(k-2)-(Am21*Az22)*u2(k-3);
     yy1(q)=y1(k);
     yy2(q)=y2(k);
     e(k,1)=c1-y1(k);
     ee1(q)=abs(e(k,1));
     e(k,2)=c2-y2(k);
     ee2(q)=abs(e(k,2));
     
     for i=1:2
        E(i,1)=e(k-i+1,1);
        E(i+4,2)=e(k-i+1,2);
     end
     
     for i=3:4
         E(i,1)=y1(k-i+3)-y1(k-i+2);
         E(i+4,2)=y2(k-i+3)-y2(k-i+2);
     end
     
     for i=1:Np
         r1(i)=beta1^i*y1(k)+(1-beta1^i)*c1;
         r2(i)=beta2^i*y2(k)+(1-beta2^i)*c2;
     end
     R=[r1(1)-(y1(k));(r2(1)-y2(k))];
     for i=2:Np
         R=[R;(r1(i)-r1(i-1));(r2(i)-r2(i-1))];
     end
  
    Z=[(y1(k)-y1(k-1));(y2(k)-y2(k-1));(y1(k-1)-y1(k-2));(y2(k-1)-y2(k-2));(u1(k-1)-u1(k-2));(u2(k-1)-u2(k-2));(u1(k-2)-u1(k-3));(u2(k-2)-u2(k-3));(u1(k-3)-u1(k-4));(u2(k-3)-u2(k-4));y1(k)-r1(1);y2(k)-r2(1)];
if abs(e(k,1))<0.000001&&abs(e(k,2))<0.000001
     kp(k,1)=kp(k-1,1);ki(k,1)=ki(k-1,1);kd(k,1)=kd(k-1,1);
    kp(k,2)=kp(k-1,2);ki(k,2)=ki(k-1,2);kd(k,2)=kd(k-1,2);
else 
    W=E*(-inv((fai'*Q*fai+gama)*E'*E)*fai'*Q*(F*Z+S*R));
      kd(k,1)=W(3);
    kp(k,1)=-W(2)-2*kd(k,1);
    ki(k,1)=W(1)-kp(k,1)-kd(k,1);
     kd(k,2)=W(6);
    kp(k,2)=-W(5)-2*kd(k,2);
    ki(k,2)=W(4)-kp(k,2)-kd(k,2);
end
 
  %du1(k)=kp(k,1)*(e(k,1)-e(k-1,1))+ki(k,1)*e(k,1)+kd(k,1)*(e(k,1)-2*e(k-1,1)+e(k-2,1)); 
  %du2(k)=kp(k,2)*(e(k,2)-e(k-1,2))+ki(k,2)*e(k,2)+kd(k,2)*(e(k,2)-2*e(k-1,2)+e(k-2,2));
  
  
 
        UU=-inv(fai'*Q*fai+gama)*fai'*Q*(F*Z+S*R);

      du1(k)=UU(1);
      du2(k)=UU(2);
    u1(k)=u1(k-1)+du1(k);
    u2(k)=u2(k-1)+du2(k);
      if u2(k)>4
        u2(k)=4;
    elseif u2(k)<-4
        u2(k)=-4;
    end
    uu1(q)=u1(k);
    uu2(q)=u2(k);
    q=q+1;
 end

 plot(yy2,'k')
 hold on

stdy=std(yy2(1:200));
 xlim([0 200])
 ylim([0 1.2])
 

  meanE=0;
    for k=1:L
           meanE=meanE+ee1(k);
        end
        meanE=meanE/L;