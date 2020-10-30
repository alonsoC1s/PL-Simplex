function [K] = klee_minty(d)
	R = vander(5 * ones(1, d));
	C = vander(2 * ones(1, d));
	r = fliplr(R(d, :))';

	% Creando matriz de coeficientes Klee-Minty
	A = eye(d);
	for i = 1:d-1
		A = A + diag(2^(i+1) * ones(1, d-i), -i);
	end

	% Costos
	cs = C(d, :);

	% Concatenando restricciones y costos
	K  = [A, eye(d), r; -cs, zeros(1,d+1)];
end
