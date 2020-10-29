function A = Simplexealo(A)

	% Encontramos el primer pivote y empezamos a medir tiempo
	tic
	[i, j, epi] = encuentra_pivote(A);
	 
	while  i, j, epi ~= 0;
		A =  pivotea(A, i,j)
		[i,j, epi] = encuentra_pivote(A);     
	end
	toc

	[m, n] = size(A);
	% Checando condiciones de terminación de simplex
	if isempty(i) == 1
		disp('no tiene soluci�n');
	end    

	if epi == 0
	    disp('es una soluci�n degenerada');
	end  
    
	% Mostrando solucion final
	% Recuperamos matriz de variables originales y checamos cuales son básicas
	vars = A(:, 1:n-m)
	b = A(1:m-1, n); 

	% Usamos find para enontrar entradas > 0. Si hay más de n-m no puede ser identidad completa y checamos 1 por 1
	[I, J, Vals] = find(vars) % Encuentra todas las entradas > 0 de vars
	[unos, basura] = size(I);

	if unos == n-m % Se dio que ambas fueron básicas i.e solo m-n 1's
		display("Ambas variables de decision son basicas")
		sol = b(I)
	elseif unos >= n-m
		display("Una o mas variables no son basicas")
	end
end
