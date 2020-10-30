function [T, ts, D] = benchmark(maxD)
	% Creando problema Klee-Minty para dims de 2 a maxD
	
	for d = 3:maxD
		d
		% Vander de utilidad
		V = fliplr(vander( 5 * ones(1,d+1)));
		% Creamos matriz de potencias de 2
		T = vander(2 * ones(1,d));
		cs = T(d, 2:d);

		% Recortamos 2^1 porque no hace falta, y "triangularizamos" T
		T = [T(:, 1:d-2), T(:, d)];
		T = fliplr(tril(fliplr(T)));

		% Haciendo los costos de la función objetivo en ultimo renglon
		T(d, :) = -cs;
		
		% Tabla final Klee-Minty de dimension D
		T = [T, eye(d, d-1), [V(d, 2:d), 0]'];

		T = Simplexealo(T);
	end
end	
