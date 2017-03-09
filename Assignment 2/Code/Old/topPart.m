function [ A ] = topPart( m )
    %Initialize matrix of zeros
    A = zeros(m,m^2);
    %Line Counter tool to regard offsets
    lineCounter = 0;
    for a = 1:m
        for b = 1:m
            %Fill ones into appropriate spaces
            A(a,lineCounter + b) = 1;
        end
        %increment line counter by offset m
        lineCounter = lineCounter + m;
    end

end

