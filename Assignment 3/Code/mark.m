function [  ] = mark(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    returns = loadExcel('../Data/Stocks_Returns_Input_Data_File_2017.xls');
    
    %% Calc bounds
    
    % Upper bound
    [~, uB] = bounds(returns, 0);
    
    % Lower bound
    [lBvec, ~] = bounds(returns, 1);
    
    averages = mean(returns');
    
    lB = sum(lBvec.*averages');
        
    
    
    %% Calc steps
    
    cumStep = linspace(lB, uB, 30);
    
    % Step size is any cumStep(n)-cumStep(n-1)
    stepSize = cumStep(4)-cumStep(3);
    
    
    %% Solve remaining 30 problems
    
    [n, o] = size(returns);
    
    
    
    vars = var(returns');
    
    covars = cov(returns');
    
    H = (covars);
    Aeq = [averages; ones(1,n)];
    lb = zeros(1,n);
    
    fVals = zeros(1,30);
    pVars = zeros(1,30); 
    
    Z = zeros(100,30);
    
    for i=1:30
        beq=[cumStep(i); 1];
        [z, fVal] = quadprog(H,[],[],[],Aeq,beq,lb);
        %fVals(1,i) = sum(z.*averages');
        %fVals(1,i) = fVal;
        fVals(1,i) = cumStep(i);
        %pVars(1,i) = sum(z.*sqrt(vars'));
        pVars(1,i) = (fVal)*2;
        Z(:,i) = z;
    end
    
    
    figure
    axis([0, 0.08, -0.01, 0.08])
    hold on
    scatter(pVars,fVals,45,'r')
    plot(pVars,fVals,'-r')
    s = scatter(vars,averages, 12, 'b', 'filled')
    xlabel('Portfolio variance')
    ylabel('Portfolio return')
    title('Efficient Frontier')
        

    %% Write into Excel file
    fileName = '../Output/Portfolios';
    sheetName = 'Portfolios';
    labels = cell(1,30);
    stockLabels = cell(100,1);
    
    for i = 1:30
        labels(1,i) = {['Portfolio ', int2str(i)]};
    end
    
    for i = 1:100
        stockLabels(i,1) = {['Stock ', int2str(1)]};
    end
    
    xlswrite(fileName, labels, sheetName, 'A2');
    xlswrite(fileName, stockLabels, sheetName, 'B1');  
    xlswrite(fileName, round(Z,4), sheetName, 'B2');

end

