function [ constraint ] = constraintMatrix1( m )
    %vertically concatenate bot and top part
    A = topPart(m);
    B= botPart(m);
    constraint = vertcat(A,B);

end

