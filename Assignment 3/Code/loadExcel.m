function [ rawData ] = loadExcel(path)

    % reads excel data file and returns column vectors
    
    % INPUTS:
    %   path = path to excel file
    %
    % OUTPUTS:
    %   dmu = name of dmus
    %   in = column vector of specified inputs
    %   out = column vector of specified outputs
    
    rawData = xlsread(path);
    %stockNames = rawData(:,1);
    %returns = rawData(:,2:end);
    
    
end