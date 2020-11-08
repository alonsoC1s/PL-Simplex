function [A, t, steps, Is, Js, Intermedias] = Simplexealo(A)

	% Metadatos de pivoteo
	Is = []; Js = []; Intermedias = [];

	% Encontramos el primer pivote y empezamos a medir tiempo
	tStart = tic;
	[i, j, epi] = encuentra_pivote(A);
	 
	steps = 0;
	while  i, j ~= 0 ;
		A =  pivotea(A, i,j)
		[i,j, epi] = encuentra_pivote(A)

		% Guardando metadatos
		steps = steps + 1;
		Is = [Is; i]; Js = [Js; j];
		Intermedias(:, :, steps) = A;

		% Encuentra_pivote detectó que no hay solución
		if isnan(epi)
			disp("epi es nan. No hay sol.")
			break
		end
	end
	t = toc(tStart);

	[m, n] = size(A);
	% Checando condiciones de terminación de simplex
	if epi == 0
		disp('Epi = 0')
	    disp('Hay una infinidad de soluciones');
	end  

	if isnan(epi)
		disp('No hay pivote posible')
		disp('El problema no está acotado');
	else
    
	% Mostrando solucion final
	% Recuperamos matriz de variables de decisión y checamos cuales son básicas
	vars = A(:, 1:n-m);
	b = A(1:m-1, n); 

	% Usamos find para enontrar entradas > 0. Si hay más de n-m no puede ser identidad completa y checamos 1 por 1
	[I, J, Vals] = find(vars); % Encuentra todas las entradas > 0 de vars
	[unos, basura] = size(I);

	if unos == n-m % Se dio que ambas fueron básicas i.e solo m-n 1's
		display("Todas las variables de decision son basicas")
		sol = b(I)
	elseif unos >= n-m
		display("Una o mas variables no son basicas")
		
		% Checamos cuales si coinciden con una identidad
	end
end
