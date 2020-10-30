function B = pivotea(A, i, j)
	[m, n] = size(A);
	% A = sym(A); % Esto solo se activa en casos especiales

	% Dividiendo el renglon que contiene el pivote para obtener un 1 principal
	% Suena a que se puede hacer toda la operacion en una sola matriz elemental pero no es asi
	A = diag([ones(1,i-1), A(i,j)^-1, ones(1,m-i)]) * A

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
