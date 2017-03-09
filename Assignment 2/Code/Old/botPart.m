function [ A ] = botPart( m )  
    %horizontally concatenates m identity matrices 
    A = [];
    for a = 1:m
        A = cat(2,A,eye(m));
    end

end

