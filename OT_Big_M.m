format short
clear all
clc

Variables = {'x_1', 'x_2', 'x_3', 's_3', 'A_1', 'A_2', 'Sol'};
M = 1000;
Cost = [0 0 0 0 -M -M 0];
A = [3 2 -3 0 1 0 2; 4 -3 3 0 0 1 4; 2 -3 4 1 0 0 7]; 
s = eye(size(A,1)); 

BV = []; 
for j = 1:size(s,2)
    for i = 1:size(A,2)
        if all(A(:,i) == s(:,j))
            BV = [BV i];
        end
    end
end

B = A(:,BV);
A = inv(B)*A;
ZjCj = Cost(BV)*A - Cost;
ZCj = [ZjCj; A];
SimpTable = array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2)) = Variables

RUN = true;
while RUN
    
    ZC = ZjCj(:, 1:end-1);
    
    if any(ZC < 0)
        fprintf('The Current BFS is NOT OPTIMAL \n');
        
        [Entval, pvt_col] = min(ZC);
        fprintf('Entering Column = %d \n', pvt_col);
        
        sol = A(:, end);
        Column = A(:, pvt_col);
        
        if all(Column <= 0)
            fprintf('Solution is UNBOUNDED \n');
           
        else
            
            ratio = [];
            for i = 1:size(Column, 1)
                if Column(i) > 0
                    ratio(i) = sol(i) ./ Column(i);
                else
                    ratio(i) = inf;
                end
            end
            [minR, pvt_row] = min(ratio);
            fprintf('Leaving Row = %d \n', pvt_row);
            
            BV(pvt_row) = pvt_col;
            B = A(:,BV);
            A = inv(B)*A;
            ZjCj = Cost(BV)*A - Cost;
            ZCj = [ZjCj; A];
            TABLE = array2table(ZCj);
            TABLE.Properties.VariableNames(1:size(ZCj,2)) = Variables
        end
    else
        RUN = false;
        fprintf('--- CURRENT BFS IS OPTIMAL --- \n');
    end
end

Final_BFS = zeros(1, size(A, 2));
Final_BFS(BV) = A(:, end);
Final_BFS(end) = sum(Final_BFS .* Cost); 
OptimalBFS = array2table(Final_BFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS, 2)) = Variables;
fprintf('OptimalBFS =\n');
disp(OptimalBFS);