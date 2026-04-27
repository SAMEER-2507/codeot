format short
clear all
clc

Cost = [2 7 4; 3 3 1; 5 5 4; 1 6 2]; 
A = [5 8 7 14];
B = [7 9 18]; 

if sum(A) == sum(B)
    fprintf('The problem is Balanced \n');
else
    fprintf('The problem is Unbalanced \n');
    if sum(A) < sum(B) 
        Cost(end+1, :) = zeros(1, length(B));
        A(end+1) = sum(B) - sum(A);
    else 
        Cost(:, end+1) = zeros(length(A), 1);
        B(end+1) = sum(A) - sum(B);
    end
end

ICost = Cost; 
X = zeros(size(Cost)); 
[m, n] = size(Cost);
BFS=m+n-1;

for i=1:size(Cost,1)
    for j=1:size(Cost,2)
        hh=min(Cost(:));
        [rowind, colind]= find(hh==Cost);
        x11 = min(A(rowind),B(colind));
        [val,ind]= max(x11);
        ii=rowind(ind);
        jj=colind(ind);
        y11=min(A(ii),B(jj));
        X(ii,jj)=y11;
        A(ii)=A(ii)-y11;
        B(jj)=B(jj)-y11;
        Cost(ii,jj)=Inf;
    end
end

InitialBFS = array2table(X);
fprintf('The Initial BFS is: \n');
disp(InitialBFS);

TotalAllocations = nnz(X);

if TotalAllocations == BFS
    fprintf('The solution is Non-Degenerate \n');
else
    fprintf('The solution is Degenerate \n');
end

TotalCost = sum(sum(X .* ICost));
fprintf('The Initial Transportation Cost is: %d \n', TotalCost);