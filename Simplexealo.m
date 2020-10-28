function A = Simplexealo(A)

[i,j] = encuentra_pivote(A);
 
    while  i, j ~= 0;
        disp('primero while');
        A =  pivotea(A, i,j)
        [i,j] = encuentra_pivote(A);     
    end

tf = isempty(i);
        if tf == 1
            disp('no tiene solución');
        end    
epi = encuentra_pivote(A);
    if epi == 0
            disp('es una solución degenerada');
    end  
    
end
