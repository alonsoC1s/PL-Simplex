function B = pivotea(A, i, j)
	[m, n] = size(A);

	% Dividiendo el renglon que contiene el pivote para obtener un 1 principal
	A = diag([ones(1,i-1), A(i,j)^-1, ones(1,m-i)]) * A;

	% Obteniendo los factores t.q R_i - efes_i * pivote = 0
	efes = A(:,j);

	% Preparando una indentidad que se vuelve matriz elemental
	E = eye(m,m);

	% Construyendo matriz elemental que hace el pivoteo 
	E(:,i) = -efes;  
	E(i,:) = -E(i,:) % Feo. Corrige error de signo  
	
	% Premultiplicando por elemental para pivotear
	B = E * A;
end
