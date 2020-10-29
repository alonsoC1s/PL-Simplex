function A = Simplexealo(A)

[i,j] = encuentra_pivote(A);
 
    while  i, j ~= 0;
        A =  pivotea(A, i,j)
        [i,j] = encuentra_pivote(A);     
    end

tf = isempty(i);
        if tf == 1
            disp('no tiene soluci�n');
        end    
epi = encuentra_pivote(A);
    if epi == 0
            disp('es una soluci�n degenerada');
    end  
    
end
