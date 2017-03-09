function [ dmu, in, out ] = loadExcel( path, incol, outcol)

    % reads excel data file and returns column vectors
    
    % INPUTS:
    %   path = path to excel file
    %   incol = row vector of column numbers with inputs
    %   outcol = row vector of column numbers with outputs
    %
    % OUTPUTS:
    %   dmu = name of dmus
    %   in = column vector of specified inputs
    %   out = column vector of specified outputs
    
    rawData = xlsread(path);
    dmu = rawData(:,1);
    in = [rawData(:,incol(1)), rawData(:,incol(2))];
    out = [rawData(:,outcol(1)), rawData(:,outcol(2))];
    
end

