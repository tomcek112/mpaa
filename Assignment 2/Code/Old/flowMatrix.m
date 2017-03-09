function [ A ] = flowMatrix( m )
    A = zeros(m,m^2);
    offset = 0;
    rowL = 0;
    negs = m;
    for a = 1:m
        for b = 2:m-rowL
            A(a,b+offset+rowL) = 1;
            A(a,negs+1) = -1;
            negs = negs + m;
        end
        offset = offset + m;
        rowL = rowL + 1;
        negs = m+offset+rowL;
    end
end

