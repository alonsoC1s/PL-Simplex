function [Results] = benchmark(maxD)
	% Creando problema Klee-Minty para dims de 2 a maxD
	Results = [];	
	for d = 2:maxD
		A = klee_minty(d);

		% Corriendo simplex sobre problema Klee-Minty
		fprintf("Aplicando simplex a Klee-Minty dim %d", d)
		[A, t, steps] = Simplexealo(A);

		Results = [Results; d, steps, t];
	end
end	
