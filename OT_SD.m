clc;
clear all;
format short;

syms x1 x2;
f = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2; 
fx=inline(f);
fobj=@(x) fx(x(:,1),x(:,2));
grad = gradient(f); 
g=inline(grad);
gradx=@(x) g(x(:,1),x(:,2));
H = hessian(f); 
hx=inline(H);

x0 = [1 1]; 
tol = 1e-3; 
maxiter = 4; 
iter = 0;
X=[];

while norm(gradx(x0)) > tol && iter < maxiter
    X = [X;x0];             
    S = -gradx(x0);         
    H = hx(x0);            
    lam = S'*S./(S'*H*S);   
    Xnew = x0+lam.*S';      
    x0 = Xnew;              
    iter = iter+1;          
end

fprintf('\n--- FINAL SOLUTION ---\n');
fprintf('Optimal Point: x1 = %.4f, x2 = %.4f\n', x0(1), x0(2));
fprintf('Minimum Function Value: %.4f\n', fobj(x0));
fprintf('Total Iterations: %d\n', iter);