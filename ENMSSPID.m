close all

clc;
q=1;


% am11=0.9355;am12=0.9355;am21=0.9672;am22=0.9512;
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

  
  y1PID=zeros(L,1);
 y2PID=zeros(L,1);
 u1PID=zeros(L,1);
 u2PID=zeros(L,1);
 yy1PID=zeros(L,1);
 yy2PID=zeros(L,1);
 uu1PID=zeros(L,1);
 uu2PID=zeros(L,1);
 du1PID=zeros(L,1);
 du2PID=zeros(L,1);
 r1PID=zeros(Np,1);
 r2PID=zeros(Np,1);
 ee1PID=zeros(L,1);
 ee2PID=zeros(L,1);
 beta1=0.6;
 beta2=0.6;
 gama=[0 0;0 0];
 c1=1;c2=1;
%c1=0;c2=0;
 v1=zeros(L,1);
 for i=1:L   
     v1(i)=0;
 end
 UU=zeros(2,1);
 ZPID=zeros(12,1);
 RPID=zeros(2*Np,1);
 EPID=zeros(6,2);
 WPID=zeros(6,1);
 ePID=zeros(L,2);
 kpPID=zeros(L,2);
 kiPID=zeros(L,2);
 kdPID=zeros(L,2);


 for k=10:L
     y1PID(k)=(Am11+Am12)*y1PID(k-1)-(Am11*Am12)*y1PID(k-2)+Az11*u1PID(k-3)-(Az11*Am12)*u1PID(k-4)+Az12*u2PID(k-2)-(Am11*Az12)*u2PID(k-3);
     y2PID(k)=(Am21+Am22)*y2PID(k-1)-(Am21*Am22)*y2PID(k-2)+Az21*u1PID(k-3)-(Az21*Am22)*u1PID(k-4)+Az22*u2PID(k-2)-(Am21*Az22)*u2PID(k-3);
     yy1PID(q)=y1PID(k);
     yy2PID(q)=y2PID(k);
     ePID(k,1)=c1-y1PID(k);
     ee1PID(q)=abs(ePID(k,1));
     ePID(k,2)=c2-y2PID(k);
     ee2PID(q)=abs(ePID(k,2));
     for i=1:1
        EPID(i,1)=ePID(k-i+1,1);
     end
    for i=4:6
        EPID(i,2)=ePID(k-i+4,2);
    end
     for i=1:Np
         r1PID(i)=beta1^i*y1PID(k)+(1-beta1^i)*c1;
         r2PID(i)=beta2^i*y2PID(k)+(1-beta2^i)*c2;
     end
     RPID=[r1PID(1)-(y1PID(k));(r2PID(1)-y2PID(k))];
     for i=2:Np
         RPID=[RPID;(r1PID(i)-r1PID(i-1));(r2PID(i)-r2PID(i-1))];
     end
  
    ZPID=[(y1PID(k)-y1PID(k-1));(y2PID(k)-y2PID(k-1));(y1PID(k-1)-y1PID(k-2));(y2PID(k-1)-y2PID(k-2));(u1PID(k-1)-u1PID(k-2));(u2PID(k-1)-u2PID(k-2));(u1PID(k-2)-u1PID(k-3));(u2PID(k-2)-u2PID(k-3));(u1PID(k-3)-u1PID(k-4));(u2PID(k-3)-u2PID(k-4));y1PID(k)-r1PID(1);y2PID(k)-r2PID(1)];
if abs(ePID(k,1))<0.000001&&abs(ePID(k,2))<0.000001
     kpPID(k,1)=kpPID(k-1,1);kiPID(k,1)=kiPID(k-1,1);kdPID(k,1)=kdPID(k-1,1);
    kpPID(k,2)=kpPID(k-1,2);kiPID(k,2)=kiPID(k-1,2);kdPID(k,2)=kdPID(k-1,2);
else 
    WPID=EPID*(-inv((fai'*Q*fai+gama)*EPID'*EPID)*fai'*Q*(F*ZPID+S*RPID));
      kdPID(k,1)=WPID(3);
    kpPID(k,1)=-WPID(2)-2*kdPID(k,1);
    kiPID(k,1)=WPID(1)-kpPID(k,1)-kdPID(k,1);
     kdPID(k,2)=WPID(6);
    kpPID(k,2)=-WPID(5)-2*kdPID(k,2);
    kiPID(k,2)=WPID(4)-kpPID(k,2)-kdPID(k,2);
end
 
  du1PID(k)=kpPID(k,1)*(ePID(k,1)-ePID(k-1,1))+kiPID(k,1)*ePID(k,1)+kdPID(k,1)*(ePID(k,1)-2*ePID(k-1,1)+ePID(k-2,1)); 
  du2PID(k)=kpPID(k,2)*(ePID(k,2)-ePID(k-1,2))+kiPID(k,2)*ePID(k,2)+kdPID(k,2)*(ePID(k,2)-2*ePID(k-1,2)+ePID(k-2,2));
  
  
 
        UU=-inv(fai'*Q*fai+gama)*fai'*Q*(F*ZPID+S*RPID);

 %     du1(k)=UU(1);
  %    du2(k)=UU(2);
    u1PID(k)=u1PID(k-1)+du1PID(k);
    u2PID(k)=u2PID(k-1)+du2PID(k);
      if u2PID(k)>4
        u2PID(k)=4;
    elseif u2PID(k)<-4
        u2PID(k)=-4;
    end
    uu1PID(q)=u1PID(k);
    uu2PID(q)=u2PID(k);
    q=q+1;
 end

 plot(yy2PID,'r')
 hold on
%  plot(uu2,'b')
%  hold on
% legend('ENMSSPFC-PID','ENMSSPFC-PIPD')
%  xlabel('k')
%  ylabel('u2(k)')
stdy=std(yy2PID(1:200));
 xlim([0 200])
 ylim([0 1.2])
 

  meanEPID=0;
    for k=1:L
           meanEPID=meanEPID+ee2PID(k);
        end
        meanEPID=meanEPID/L;