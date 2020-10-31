function [Results] = benchmark(maxD, reps, problem)
	if problem == "klee-minty"
		gen = @(d) klee_minty(d);
	elseif problem == "rand"
		gen = @(d) rand_lp(d);
	end
		
	% Creando problema Klee-Minty para dims de 2 a maxD
	Results = [];	
	for d = 2:maxD
		for i = 1:reps
			A = gen(d);

			% Corriendo simplex sobre problema Klee-Minty
			fprintf("Aplicando simplex a %s dim %d",problem, d)
			[A, t, steps] = Simplexealo(A);

			Results = [Results; d, steps, t];
		end
	end
end	
