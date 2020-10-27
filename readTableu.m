function [A, bigM] = readTableu(filename)
	T = readtable(filename)
	[m, n] = size(T);

	% Se assume una tabla con una forma como 
	% 1, 2, 3, "<=", 1, -4
	% 3, 4, 9, ">=", 2, -5
	% 8, 9, 2, ">=", 1, -6
	% donde las últimas 3 columnas son
	% restricción, b, costo respectivamente

	B = T{:, 1:n-3}; % Recupera solo matriz de restricciones

	rests = T{:,n-2}; % Recupera strings como "<=" para construir matriz de holguras y excesos

	bes = T{:,n-1}; % Recupera vector b
	costos = T{:,n};% Recupera costos de función obj.

	% Leyendo restricciones para crear matriz
	Hs = eye(m);
	for r = 1:m
		restriccion = rests(r);
		if restriccion == ">="
			Hs(:,r) = -Hs(:,r);
			bigM = true;
		elseif restriccion == "="
			Hs(:,r) = 0 * Hs(:,r);
			bigM = true;
		end	
	end

	A = [B, Hs, bes; costos', zeros(1,m)];
end
