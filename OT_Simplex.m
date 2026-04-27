format short
clear all
clc

Variables = {'x_1', 'x_2', 'x_3', 's_1', 's_2', 's_3', 'Sol'};

Cost = [-1 3 -2 0 0 0 0];
Info = [3 -1 2; -2 4 0; -4 3 8];
b = [7; 12; 10];
s = eye(size(Info, 1));
A = [Info s b];

BV = [];
for j = 1:size(s, 2)
    for i = 1:size(A, 2)
        if A(:, i) == s(:, j)
            BV = [BV i];
        end
    end
end
B = A(:, BV);
A = inv(B) * A;
ZjCj = Cost(BV) * A - Cost;

ZCj = [ZjCj; A];
SimpTable = array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj, 2)) = Variables
RUN=true;
while RUN
ZC = ZjCj(:, 1:end-1);

if any(ZC < 0);
    fprintf(' The Current BFS is NOT Optimal \n ');
    [Entval, pvt_col] = min(ZC);
    fprintf('Entering Column = %d \n', pvt_col);
    sol = A(:, end);
    Column = A(:, pvt_col);
    for i = 1:size(A, 1)
    if Column(i) > 0
        ratio(i) = sol(i) ./ Column(i);
    else
        ratio(i) = inf;
    end
    end
    [minR, pvt_row] = min(ratio);
    fprintf('Leaving Row = %d \n', pvt_row);
    BV(pvt_row)=pvt_col;
    B = A(:, BV);
    A = inv(B) * A;
    ZjCj = Cost(BV) * A - Cost;
    ZCj = [ZjCj; A];
    TABLE = array2table(ZCj);
    TABLE.Properties.VariableNames(1:size(ZCj,2)) = Variables
else
    RUN=false;
    fprintf(' CURRENT BFS IS OPTIMAL \n');
end
end
FINAL_BFS = zeros(1, size(A, 2));
FINAL_BFS(BV) = A(:, end);                        
FINAL_BFS(end) = sum(FINAL_BFS .* Cost);        

OptimalBFS = array2table(FINAL_BFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS, 2)) = Variables