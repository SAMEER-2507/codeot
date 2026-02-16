format short
clear all
clc
%bring objective function and constraints(equal to form) in standard form
%using slack and surplus variables
%Max Z=2x1 + 3x2 + 4x3 + 7x4
%s.t. 2x1 + 3x2 - x3 +4x4 = 8
%x1 - 2x2 + 6x3 - 7x4 = -3
%xi >= 0
C=[2 3 4 7];%cost|write in order x1,x2,...,s1,s2,...
A=[2 3 -1 4; 1 -2 6 -7];%write in order x1,x2,...,s1,s2,...
b=[8 ; -3];
m=size(A,1);%no. of constraints i.e no. of rows in A
n=size(A,2);%no. of variables i.e no. of columns in A
nv=nchoosek(n,m);%nCm
t=nchoosek(1:n,m);%all unique combination possibilities as basic variables
sol=[];
if n>=m
    for i=1:nv
    y=zeros(n,1);%initially all variables are zero
    x=A(:,t(i,:))\b;%extracting required coefficients of variables from A & doing inverse with b
        if all(x>=0 & x~=inf & x~=-inf)%if negative or inf do not include
            y(t(i,:))=x;%update values of basic variables in y
            sol=[sol y];%append y in sol
        end
    end
else
    error('constraints are greater than variables')
end
Z=C*sol;%Z values corresponding to each BFS
[Zmax,Zind]=max(Z);%max Z value with its index|write min(Z) if we have to minimize Z
BFS=sol(:,Zind);%values of variables when Z is max
optval=[BFS' Zmax];%make BFS row vector and append Zmax
OPTIMAL_BFS=array2table(optval);
OPTIMAL_BFS.Properties.VariableNames(1:size(OPTIMAL_BFS,2))={'x_1','x_2','x_3','x_4','Value_of_Z'};%assign variable names
