function A = readTableu(filename)

	T = readtable(filename)
	[m, n] = size(T);

	% Se assume una tabla con una forma como 
	% 1, 2, 3, "<=", 1 
	% 3, 4, 9, ">=", 2
	% 8, 9, 2, ">=", 1
	% 1, 3, 4, , 0
	% Donde la última columna es vector b y la última fila es vector de costos

	A_p = T{1:m-1, 1:n-2}; % Recupera solo matriz de restricciones

	rests = T{:,n-1}; % Recupera strings como "<=" para construir matriz de holguras y excesos
	rests_n = [];
	% Convertimos strings a los coeficientes de la variable de holgura o exceso
	for r = 1:m;
		restriccion = rests(r);
		if restriccion == "<="
			rests_n = [rests_n; 1];
		elseif restriccion == ">="
			rests_n = [rests_n; -1];
		elseif restriccion == "="
			rests_n = [rests_n; 0];
		end
	end

	bes = T{1:m-1, n}; % Recupera vector b ignorando el ultimo elemento porque es cero
	costos = T{m,1:n-2};% Recupera costos de función obj.
  
	% Estamos maximizando, entonces invierte costos
	if T{m, n} == 1
	  costos = -costos
	end

	% Checamos si todos los b_i son positivos, y sin no es asi modficamos
	% la restricción para que se cumpla
	bs_infractores = bes < 0;
	infraccion = any(bs_infractores);

	% Modificamos restricciones para arreglarlo
	if infraccion
		for idx_infractor = find(bs_infractores)
			A_p(idx_infractor, :) = -A_p(idx_infractor, :);
			bes(idx_infractor) = -bes(idx_infractor);
			rests_n(idx_infractor) = -rests_n(idx_infractor);
		end
	end
	
	% Convirtiendo desigualdades a una matriz de "aches". (H)olguras y (e)xcesos
	Hs = diag(rests_n)
	% Verificamos si el origen es parte de la región factible
	len_bes = length(bes); len_rests = length(rests_n);
	if rests_n == zeros(1, len_rests)
		% Hacemos Hs cuadrada para poder usar linsolve
		paddedH = zeros(len_bes, len_bes);
		paddedH(1:size(Hs,1), 1:size(Hs,2)) = Hs; 
		% Verificamos si está el origen para ver si usar big M
		bigM = any((paddedH \ bes) < 0); % Checa si existe solución positiva al sistema Hs * x = bes
	else
		% Por sugerencia del Prof. metemos gran M sin checar si está o no el orígen.
		bigM = true;
	end

	% Recortamos las columnas de 0's que pudieron haber quedado en Hs
	Hs = Hs(:, any(Hs));

	% Si es necesario usar bigM la acompletamos en este paso. Si no, regresar matriz estándar
	if bigM
		% Creando matriz de M's
		small_m = 100 * max(A_p, [], 'all'); % max de todo A no por columnas
		M = diag(ones(1,m-1));

		% Dejando la identidad de una vez restando a costos relativos small_m
		costos = costos - small_m * sum(A_p);
		% Concatenando y retornando
		% Hs = [Hs; zeros(1, length(Hs))]; % rellenando Hs para que coincida la forma
		A = [A_p, Hs, M, bes; costos, zeros(1, size(Hs,2)), zeros(1,m)];
	else
		% Concatenando y retornando
		A_p, Hs, bes, costos
		A = [A_p, Hs, bes; costos, zeros(1,size(Hs, 2))];
    end
    
end
