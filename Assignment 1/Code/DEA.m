function [] = DEA(model, orientation)
    % DEA   Run specified DEA model and write output to Excel sheet
    % Parameters:
    %       model = character array representing the type of model.
    %               choose between ['CCR', 'BCC']
    %
    %       orientation = character array representing the orientation of
    %                     the chosen model.
    %                     choose between ['io', 'oo']
    %
    % Adapted from code by Phillip available <a href="matlab:web('https://uk.mathworks.com/matlabcentral/fileexchange/19158-data-envelopment-analysis')">here</a>
    

    %% Model selection;
    options = optimset('Display','off');   %suppress linprog output
    warning('off', 'all');    %suppress all linprog & xlswrite warnings
    
    epsilon=.00000001;              % epsilon (approximately non-archimedian number for the BCC & CCR models)    ;   ;

    isDual = strcmp(model,'CCR-Dual');
    
    %% Load data from excel sheet
    % X as vector of inputs
    % Y as vector of outputs
    [DMU, X, Y] = loadExcel('../Data/DEA_Input_Data_file_2017.xls', [2,3], [4,5]);


    % extracts the number of DMUs, inputs and outputs;
    [n,m] = size(X);
    [n,s] = size(Y);

    %% Computes the results from the selected model;
    %  The results from the selected model are in matrix Z;

    switch model;

        % BCC model;
        case ('BCC')
        switch orientation;
            % Input oriented;
            case ('io')
                % Z as container for results
                Z = zeros(n,n+m+s+1);

                % Objective function of the BCC model: min(0*lambda - epsilon*(s+ + s-) + theta);
                f = [zeros(1,n) -epsilon*ones(1,s+m) 1];

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput = zeros(m,1);                 % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    Aeq = [Y', -eye(s,s), zeros(s,m+1);
                          -X', zeros(m,s), -eye(m,m) X(j,:)';
                          ones(1,n), zeros(1,s), zeros(1,m+1)];
                    % beq as linear inequality matrix
                    beq = [Y(j,:)';zeros(m,1);1];
                    % solve linear optimization problem
                    z = linprog(f,[],[],Aeq,beq,lb,[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

            % Output oriented;
            case ('oo')
                % Z as container for results
                Z = zeros(n,n+m+s+1);

                % Objective function of the BCC_oo model: max(0*lambda + epsilon*(s+ + s-) + theta);
                f = -[zeros(1,n), epsilon*ones(1,s+m), 1];

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput = zeros(m,1);                 % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    Aeq = [-Y', eye(s,s), zeros(s,m), Y(j,:)'; 
                            X', zeros(m,s), eye(m,m), zeros(m,1); 
                            ones(1,n), zeros(1,s+m+1)];
                    % beq as linear inequality matrix
                    beq = [zeros(s,1);X(j,:)';1];
                    % solve linear optimization problem
                    z = linprog(f,[],[],Aeq,beq,lb,[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

        end
        % CCR model;
        case ('CCR')
        switch orientation;
            % Input oriented;
            case ('io')
                % Z as container for results
                Z = zeros(n,n+m+s+1);

                % Objective function of the CCR model: min(0*lambda - epsilon*(s+ + s-) + theta);
                f = [zeros(1,n) -epsilon*ones(1,s) -epsilon*ones(1,m) 1];

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput  = zeros(m,1);                % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    Aeq = [Y', -eye(s,s), zeros(s,m+1);
                          -X', zeros(m,s), -eye(m,m), X(j,:)'];
                    % beq as linear inequality matrix
                    beq = [Y(j,:)';zeros(m,1)];
                    % solve linear optimization problem
                    z = linprog(f,[],[],Aeq,beq,lb,[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

            % Output oriented;
            case ('oo')
                % Z as container for results
                Z = zeros(n,n+m+s+1);

                % Objective function of the CCR_oo model: max(0*lambda + epsilon*(s+ + s-) + theta);
                f = -[zeros(1,n), epsilon*ones(1,s+m), 1];

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput  = zeros(m,1);                % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    Aeq = [-Y', eye(s,s), zeros(s,m), Y(j,:)'; ...
                            X', zeros(m,s), eye(m,m), zeros(m,1)];
                    % beq as linear inequality matrix
                    beq = [zeros(s,1);X(j,:)'];
                    % solve linear optimization problem
                    z = linprog(f,[],[],Aeq,beq,lb,[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

        end
        
        case ('CCR-Dual')
        switch orientation;
            % Input oriented;
            case ('io')
                % Z as container for results
                Z = zeros(n,m+s);

                % Objective function of the CCR model: min(0*lambda - epsilon*(s+ + s-) + theta);
                % becomes beq
                b = [zeros(1,n) -epsilon*ones(1,s) -epsilon*ones(1,m)]';

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput  = zeros(m,1);                % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    A = [Y', -eye(s,s), zeros(s,m);
                          -X', zeros(m,s), -eye(m,m)]';
                    Aeq = [zeros(1,s), X(j,:)];
                    beq = [1];
                    % beq as linear inequality matrix
                    %becomes f
                    f = [Y(j,:)'; zeros(m,1)]';
                    % solve linear optimization problem
                    z = linprog(-f,A,b,Aeq,beq,[],[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

            % Output oriented;
            case ('oo')
                % Z as container for results
                Z = zeros(n,m+s);

                % Objective function of the CCR_oo model: max(0*lambda + epsilon*(s+ + s-) + theta);
                b = [zeros(1,n), epsilon*ones(1,s+m)]';

                lblambda = zeros(n,1);                % Lower bounds for (n) lambdas;
                lboutput = zeros(s,1);                % Lower bounds for (s) outputs;
                lbinput  = zeros(m,1);                % Lower bounds for (m) inputs ;
                % lb has same size as f to show for each f(i), f(i) >= lb(i)
                lb = [lblambda; lboutput; lbinput];   % Lower bounds for lambdas, outputs (s+) and inputs (s-);
                % loop over each DMU
                for j=1:n
                    % Aeq as linear equality matrix
                    A = [-Y', eye(s,s), zeros(s,m); ...
                            X', zeros(m,s), eye(m,m)]';
                    Aeq = [Y(j,:), zeros(1,m)];
                    beq = [1];
                    % beq as linear inequality matrix
                    f = [zeros(s,1);X(j,:)']';
                    % solve linear optimization problem
                    z = linprog(f,-A,-b,Aeq,beq,[],[],[],options);
                    % store results in corresponding row of Z
                    Z(j,:) = z;
                end
                

        end
        
    end

    %% Generates the output file  "DEAresults.table";

    %% Excel constants
    
    
    fileName = 'DEA_Output_Data_File';
    sheet1Name = [upper(model), '-', upper(orientation), 'Results'];
    sheet2Name = [upper(model), '-', upper(orientation), ' Peer Groups'];

    %% Label Vector
    
    if(isDual)
        labels = [cell(1,1),cell(1,m),cell(1,s)]; 
    else
        labels = [cell(1,1), cell(1,n), cell(1,m), cell(1,s), cell(1,1)];
    end

    % First cell for DMU names
    labels(1) = {'DMU'};

    if(isDual)
        %labels for weights
        for i=1:m+s
            labels(1+i) = {['w', int2str(i)]};
        end
    else
       % Labels for intesity vector
        for i=1:n
            labels(i+1) = {[char(955), int2str(i)]};
        end

        % Labels for X slacks
        for i=1:m
            labels(n+i+1) = {['X slack ', int2str(i)]};
        end

        % Labels for Y slacks
        for i=1:s
            labels(n+m+i+1) = {['Y slack ', int2str(i)]};
        end

        % Last cell for DEA scores
        labels(n+m+i+2) = {'DEA Score'}; 
    end
    


    %% Generates Output Excel file
    
    xlswrite(fileName, labels(1,:), sheet1Name );
    xlswrite(fileName, [DMU, round(Z,4)], sheet1Name, 'A2')

    %% DEA scores analysis
    if(~isDual)
        xlswrite(fileName, {'DEA Scores Analysis'}, sheet1Name, 'BF3:BF3');
        xlswrite(fileName, {'Average'}, sheet1Name, 'BF4:BF4');
        xlswrite(fileName, {'=AVERAGE(BD2:BD51)'}, sheet1Name, 'BG4:BG4');
        xlswrite(fileName, {'Standard Dev'}, sheet1Name, 'BF5:BF5');
        xlswrite(fileName, {'=STDEV.P(BD2:BD51)'}, sheet1Name, 'BG5:BG5');
        xlswrite(fileName, {'Min'}, sheet1Name, 'BF6:BF6');
        xlswrite(fileName, {'=MIN(BD2:BD51)'}, sheet1Name, 'BG6:BG6');
        xlswrite(fileName, {'Max'}, sheet1Name, 'BF7:BF7');
        xlswrite(fileName, {'=MAX(BD2:BD51)'}, sheet1Name, 'BG7:BG7');
    end

    %% Peer group vector
    
    if(~isDual)
        peers = cell(n,2);

        % we loop through our results to find non-zero values in all lambdas
        % for each DMU and store them in a cell array
        for a=1:n
            for b=1:n
                if Z(a,b) > 0.01
                    peers{a,1} = [peers{a,1}, Z(a,b)];
                    peers{a,2} = [peers{a,2}, b];
                end
            end
        end

        % prepare Excel sheet for writing peers
        xlswrite(fileName, {'DMU', 'Peers'}, sheet2Name);
        xlswrite(fileName, DMU, sheet2Name, 'A2');
        temp = peers(:,2);

        %% Write peer group vector

        for a=1:n
            xlswrite(fileName, temp{a}, sheet2Name, ['B', int2str(a+1)]);
        end
        clear temp;
    end

 
end