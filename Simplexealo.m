function A = Simplexealo(A)

[i,j] = encuentra_pivote(A);
    while  i, j ~= 0 
        A =  pivotea(A, i,j);
        [i,j] = encuentra_pivote(A);
        
    end
    
end
