function [A, sol, z, t, steps, Is, Js, Intermedias] = Simplexealo(A, bigM, n_vars)

	% Metadatos de pivoteo
	Is = []; Js = []; Intermedias = [];

	% Encontramos el primer pivote y empezamos a medir tiempo
	tStart = tic;
	[i, j, epi] = encuentra_pivote(A);
	 
	steps = 0;
	while  i, j ~= 0 ;
		A =  pivotea(A, i,j);
		[i,j, epi] = encuentra_pivote(A);

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
	if isempty(epi)
		disp('Epi = 0')
	    disp('Hay una infinidad de soluciones');
	end  

	if isnan(epi)
		disp('No hay pivote posible')
		disp('El problema no está acotado');
		sol = [];
	else

	% Checando si el problema es infactible
	if bigM
		% Checamos si hau algún y en la base aún
		M = A(:, n-m+1:n-1)
		% Checamos si hay chance siquiera de tener una columna canonica
		% Estrategia: Si la columna suma != 1 no hay forma de que sea canonica. Si suma 1 checamos con más cuidado
		idx_unos = find((sum(M) == 1));

		if not(isempty(idx_unos))
			% Checamos las columnas que sumaron 1
			for uno = idx_unos
				col = M(:, uno);
				cuantos_unos = length(find(col));
				if cuantos_unos == 1
					disp("Se usó gran M y no se pudo sacar alguna y de la base. La región factible es vacía.")
				end
			end
		end
	end
    
	% Mostrando solucion final
	% Recuperamos matriz de variables de decisión y checamos cuales son básicas
	vars = A(:, 1:n_vars); 
	b = A(1:m-1, n); 

	% Recuperando las soluciones con la estrategia de arriba para checar columnas canónicas
	idx_unos = find((sum(vars) == 1));
	sol = zeros(1, n_vars);
	if isempty(idx_unos)
		disp("Ninguna var. de decisión básica. Sol:0")
	else
		% Notacion: uno_j indice de columna y x_j. uno_i, indice de renglón y se usa para buscar en b
		for uno_j = idx_unos
			col = vars(:, uno_j);
			idx_unos_en_col = find(col);
			cuantos_unos = length(idx_unos_en_col);
			if cuantos_unos == 1
				fprintf("La variable x_%d es básica\n", uno_j)
				sol(uno_j) = b(idx_unos_en_col);
			end
		end
	end
end

% valor de la fn. objetivo
z = -A(end, end)