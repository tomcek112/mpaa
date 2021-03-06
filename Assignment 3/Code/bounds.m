function [ z, ret ] = bounds( returns, lambda )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    % n for amount of stocks o for amount of returns
    [n, o] = size(returns);
    
    averages = mean(returns');
    
    vars = var(returns');
    
    covars = cov(returns');
        
    H = lambda*(covars); 
    
    f = -(1-lambda)*(averages);
    
    %% Calculate Upper and Lower bounds 
    
    Aeq = ones(1,n);
    
    beq = 1;
    
    lb = zeros(1,n);
    
    [z, ret] = quadprog(H,f',[],[], Aeq, beq, lb);
    
    ret = -ret;
       
    
    

end

