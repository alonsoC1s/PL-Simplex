function A = Simplexealo(A)

	[i,j, epi] = encuentra_pivote(A);
	 
	while  i, j, epi ~= 0;
		A =  pivotea(A, i,j)
		[i,j] = encuentra_pivote(A);     
	end

	if isempty(i) == 1
		disp('no tiene soluci�n');
	end    

	if epi == 0
	    disp('es una soluci�n degenerada');
	end  
    
end
