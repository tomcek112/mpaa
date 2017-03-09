function [ constraint ] = constraintMatrix2( m )
    A = topPart(m);
    B = botPart(m);
    flowConstraintMatrix = cat(2,zeros(m,m^2),flowMatrix(m));
    %vertically concatenate top and bot matrices
    %then concatenate flow constraints at bottom right
    constraint = vertcat(cat(2,vertcat(A,B),zeros(2*m,m^2)),flowConstraintMatrix);
end

