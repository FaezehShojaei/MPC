close all
clc;
qn=1;

% 
%  am11=0.9355;am12=0.9355;am21=0.9672;am22=0.9512;
%  az11=0.06449;az12=0.05288;az21=0.02557;az22=0.04877;

%case 1
am11=1.0134;am12=0.8275;am21=0.9492;am22=1.0016;
az11=0.07232;az12=0.04971;az21=0.02716;az22=0.04901;

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
 y1n=zeros(L,1);
 y2n=zeros(L,1);
 u1n=zeros(L,1);
 u2n=zeros(L,1);
 yy1n=zeros(L,1);
 yy2n=zeros(L,1);
 uu1n=zeros(L,1);
 uu2n=zeros(L,1);
 du1n=zeros(L,1);
 du2n=zeros(L,1);
 r1n=zeros(Np,1);
 r2n=zeros(Np,1);
 ee1n=zeros(L,1);
 ee2n=zeros(L,1);
 beta1n=0.6;
 beta2n=0.6;
 gaman=[0 0;0 0];
 c1n=1;c2n=1;
%c1=0;c2=0;
 v1=zeros(L,1);
 for i=1:L
     v1(i)=1;
     v2(i)=0;
 end
 UUn=zeros(2,1);
 Zn=zeros(12,1);
 Rn=zeros(2*Np,1);
 En=zeros(8,2);
 Wn=zeros(8,1);
 en=zeros(L,2);
 kpn=zeros(L,2);
 kin=zeros(L,2);
 kdn=zeros(L,2);


 for k=10:L
     y1n(k)=(Am11+Am12)*y1n(k-1)-(Am11*Am12)*y1n(k-2)+Az11*u1n(k-3)-(Az11*Am12)*u1n(k-4)+Az12*u2n(k-2)-(Am11*Az12)*u2n(k-3);
     y2n(k)=(Am21+Am22)*y2n(k-1)-(Am21*Am22)*y2n(k-2)+Az21*u1n(k-3)-(Az21*Am22)*u1n(k-4)+Az22*u2n(k-2)-(Am21*Az22)*u2n(k-3);
     yy1n(qn)=y1n(k);
     yy2n(qn)=y2n(k);
     en(k,1)=c1n-y1n(k);
     ee1n(qn)=abs(en(k,1));
     en(k,2)=c2n-y2n(k);
     ee2n(qn)=abs(en(k,2));
     
     for i=1:2
        En(i,1)=en(k-i+1,1);
        En(i+4,2)=en(k-i+1,2);
     end
     
     for i=3:4
         En(i,1)=y1n(k-i+3)-y1n(k-i+2);
         En(i+4,2)=y2n(k-i+3)-y2n(k-i+2);
     end
     
     for i=1:Np
         r1n(i)=beta1n^i*y1n(k)+(1-beta1n^i)*c1n;
         r2n(i)=beta2n^i*y2n(k)+(1-beta2n^i)*c2n;
     end
     Rn=[r1n(1)-(y1n(k));(r2n(1)-y2n(k))];
     for i=2:Np
         Rn=[Rn;(r1n(i)-r1n(i-1));(r2n(i)-r2n(i-1))];
     end
  
    Zn=[(y1n(k)-y1n(k-1));(y2n(k)-y2n(k-1));(y1n(k-1)-y1n(k-2));(y2n(k-1)-y2n(k-2));(u1n(k-1)-u1n(k-2));(u2n(k-1)-u2n(k-2));(u1n(k-2)-u1n(k-3));(u2n(k-2)-u2n(k-3));(u1n(k-3)-u1n(k-4));(u2n(k-3)-u2n(k-4));0;0];
if abs(en(k,1))<0.000001&&abs(en(k,2))<0.000001
     kpn(k,1)=kpn(k-1,1);kin(k,1)=kin(k-1,1);kdn(k,1)=kdn(k-1,1);
    kpn(k,2)=kpn(k-1,2);kin(k,2)=kin(k-1,2);kdn(k,2)=kdn(k-1,2);
else 
    Wn=En*(-inv((fai'*Q*fai+gaman)*En'*En)*fai'*Q*(F*Zn+S*Rn));
      kdn(k,1)=Wn(3);
    kpn(k,1)=-Wn(2)-2*kdn(k,1);
    kin(k,1)=Wn(1)-kpn(k,1)-kdn(k,1);
     kdn(k,2)=Wn(6);
    kpn(k,2)=-Wn(5)-2*kdn(k,2);
    kin(k,2)=Wn(4)-kpn(k,2)-kdn(k,2);
end
 
  %du1(k)=kp(k,1)*(e(k,1)-e(k-1,1))+ki(k,1)*e(k,1)+kd(k,1)*(e(k,1)-2*e(k-1,1)+e(k-2,1)); 
  %du2(k)=kp(k,2)*(e(k,2)-e(k-1,2))+ki(k,2)*e(k,2)+kd(k,2)*(e(k,2)-2*e(k-1,2)+e(k-2,2));
  
  
 
        UUn=-inv(fai'*Q*fai+gaman)*fai'*Q*(F*Zn+S*Rn);

      du1n(k)=UUn(1);
      du2n(k)=UUn(2);
    u1n(k)=u1n(k-1)+du1n(k);
    u2n(k)=u2n(k-1)+du2n(k);
      if u2n(k)>4
        u2n(k)=4;
    elseif u2n(k)<-4
        u2n(k)=-4;
    end
    uu1n(qn)=u1n(k);
    uu2n(qn)=u2n(k);
    qn=qn+1;
 end
 plot(ee2,'b')
 hold on 
 plot(ee2n,'r')
 hold on
%   plot(v1,'y')
%   hold on
 legend('ENMSSPFC-PIPD','NMSSPFC-PIPD')
  xlabel('k')
  ylabel('e_2(k)')
 

stdy=std(yy2n(1:200));
 xlim([0 200])
 ylim([-2 2])
 

 

  meanEn=0;
    for k=1:L
           meanEn=meanEn+ee1n(k);
        end
        meanEn=meanEn/L;