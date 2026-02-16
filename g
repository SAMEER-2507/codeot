format short
clear all
clc
%Max Z=3x1 + 5x2
%s.t. x1 + 2x2 <= 2000
%x1 + x2 <= 1500
%x2 <= 600
%x1,x2 >= 0
function out=constraint(X)
    x1=X(:,1);
    x2=X(:,2);
    cons1=x1+2.*x2-2000;
    h1=find(cons1>0);%points which do not satisfy
    X(h1,:)=[];%delete them

    x1=X(:,1);
    x2=X(:,2);
    cons2=x1+x2-1500;
    h2=find(cons2>0);
    X(h2,:)=[];

    x1=X(:,1);
    x2=X(:,2);
    cons3=x2-600;
    h3=find(cons3>0);
    X(h3,:)=[];
out=X;
end
C=[3,5];
A=[1 2;1 1;0 1];
b=[2000; 1500; 600];
y1=0:1:max(b);%start from 0 with increment 1 till largest value possible from constraints|possible values of x1|not always max(b)|can be greater than or equal to max(b)/coeff. of x1 in that constraint
x21=(b(1)-A(1,1).*y1)./A(1,2);%b1-(a11*x1)/a12|values of x2 from each constraints on putting y1
x22=(b(2)-A(2,1).*y1)./A(2,2);%division is inverse
x23=(b(3)-A(3,1).*y1)./A(3,2);
x21=max(0,x21);%non-negativity constraint
x22=max(0,x22);
x23=max(0,x23);
plot(y1,x21,'r',y1,x22,'k',y1,x23,'b')
xlabel('value of x1');
ylabel('value of x2');
title('x1 vs x2');
legend('x1 + 2x2 = 2000','x1 + x2 = 1500','x2 = 600')
grid on
cx1=find(y1==0);%points on x-axis(x1) where lines cut it
c1=find(x21==0);%point on y-axis(x2) where line1 cut it
Line1=[y1(:,[c1 cx1]);x21(:,[c1,cx1])]';%making line from the two points
c2=find(x22==0);
Line2=[y1(:,[c2 cx1]);x22(:,[c2,cx1])]';
c3=find(x23==0);
Line3=[y1(:,[c3 cx1]);x23(:,[c3,cx1])]';
corpt=unique([Line1;Line2;Line3],'rows');%unique corner points of line where they intersect axis
HG=[0;0];%(0,0)is a corner point
for i=1:size(A,1)%intersection of each line
    hg1=A(i,:);
    b1=b(i,:);
    for j=i+1:size(A,1)%with every other possible line
        hg2=A(j,:);
        b2=b(j,:);
        Aa=[hg1;hg2];
        Bb=[b1;b2];
        Xx=Aa\Bb;%matrix inverse multiplication
        HG=[HG Xx];%append
    end
end
pt=HG';%make it column vector
allpt=[pt;corpt];%combine corner points and intersection points
points=unique(allpt,'rows');%unique points only
PT=constraint(points);%keep points which satisfy constraints
PT=unique(PT,'rows');
for i=1:size(PT,1)
    Fx(i,:)=sum(PT(i,:).*C);%calculate Z on all final points
end
Vert_Fns=[PT Fx];%append Z values with points
[fxval,indfx]=max(Fx);
optval=Vert_Fns(indfx,:);
OPTIMAL_BFS=array2table(optval)
