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

	bes = T{1:m-1, n}; % Recupera vector b ignorando el ultimo elemento porque es cero
	costos = T{m,1:n-2};% Recupera costos de función obj.

	% Leyendo restricciones para crear matriz
	Hs = eye(m-1); % Nombro Hs ("aches") pensando en "h"olguras y "e"xcesos
	bigM = false;
	for r = 1:m;
		restriccion = rests(r);
		if restriccion == ">="
			Hs(:,r) = -Hs(:,r);
			bigM = true;
		elseif restriccion == "="
			Hs(:,r) = 0 * Hs(:,r);
			bigM = true;
		end	
	end

	% Si es necesario usar bigM la acompletamos en este paso. Si no, regresar matriz estándar
	if bigM
		% Creando matriz de M's
		small_m = 100 * max(A_p, [], 'all'); % max de todo A no por columnas
		M = diag(ones(1,m-1));

		% Dejando la identidad de una vez restando a costos relativos small_m
		costos = costos - small_m * ones(1, n-2);

		% Concatenando y retornando
		A = [A_p, Hs, M, bes; costos, zeros(1,2*m-1)];
	else
		% Concatenando y retornando
		A = [A_p, Hs, bes; costos, zeros(1,m)];
    end
    
end
