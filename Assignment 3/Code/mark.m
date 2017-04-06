function [ ] = mark( )
    
    

    returns = loadExcel('../Data/Stocks_Returns_Input_Data_File_2017.xls');
    
    %% Calc bounds
    
    % Upper bound
    [~, uB] = bounds(returns, 0);
    
    % Lower bound
    [lBvec, ~] = bounds(returns, 1);
    
    averages = mean(returns');
    
    % Lower bound fVal is a variance value. We are interested in the return
    % so we multiply the stock composition by it's their returns to obtain
    % the portfolio return
    lB = sum(lBvec.*averages');
        
    
    
    %% Calc steps
    
    cumStep = linspace(lB, uB, 30);
    
    % Step size is any cumStep(n)-cumStep(n-1)
    stepSize = cumStep(4)-cumStep(3);
    
    
    %% Solve remaining 30 problems
    
    [n, o] = size(returns);
    
    
    
    vars = var(returns');
    
    covars = cov(returns');
    
    % Hessian matrix as covariances
    H = (covars);
    Aeq = [averages; ones(1,n)];
    lb = zeros(1,n);
    
    % Initialize containers for portfolio variances and portfolio stock
    % compositions
    pVars = zeros(1,30); 
    Z = zeros(100,30);
    
    % Solve problems
    for i=1:30
        % Set appropriate rmin
        beq=[cumStep(i); 1];
        [z, fVal] = quadprog(H,[],[],[],Aeq,beq,lb);
        
        % Quadprog returns fVal as (actual function value)/2
        % Thus we multiply by 2 to get the actual variance
        pVars(1,i) = (fVal)*2;
        
        % Store portfolio stock composition
        Z(:,i) = z;
    end
    
    
    %% Draw Graph
    
    figure
    axis([0, 0.08, -0.01, 0.08])
    hold on
    scatter(pVars,cumStep,45,'r')
    plot(pVars,cumStep,'-r')
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
        stockLabels(i,1) = {['Stock ', int2str(i)]};
    end
    
    xlswrite(fileName, labels(1,:), sheetName, 'B1');
    pause(2)
    xlswrite(fileName, stockLabels(:,1), sheetName, 'A2');  
    pause(2)
    xlswrite(fileName, round(Z,4), sheetName, 'B2');
    pause(2)

    
    %% Calculate correlation matrix
    
    corr = corrcoef(returns');
    
    
    xlswrite(fileName, corr, 'Correlations', 'B2');
    xlswrite(fileName, stockLabels(:,1)', 'Correlations', 'B1');
    xlswrite(fileName, stockLabels(:,1), 'Correlations', 'A2');
    
    
    
end

