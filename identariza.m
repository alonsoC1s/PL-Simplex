function [A] = identariza(B)
	% Primero checamos si ya hay una identidad en la matriz de entrada B
	% Extraigo información de la matriz en forma estándar
	[m,n] = size(B);
	coefs = B(1:m-1, 1:m-2) % Matriz de coefs.
	z = zeros(m-2, 1); % origen in R^m-2
	b = B(1:m-1, n) % restricciones

	restricciones = coefs * z <= b % Verificando si origen cumple restricciones

	if not(all(restricciones))
		fprintf("Identarizando\n")
		% No tenemos al origen. Lo creamos iterando sobre la matriz M
		j = n+m-2;
		for i = 1:m-1 % Sabemos que M es de m-1 X m-1
			B = pivotea(B, i, j+i)
		end
	end
	% Si estaba el origen. Nada que hacer :)
	A = B;
end
