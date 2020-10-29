function [i,j,epi] = encuentra_pivote(A)
    %Salida de la funci�n [i,j] renglon i, columna j
    % Iterando sobre costos de izq a derecha as per Bland
    % Se asume que ya hay una identidad. Si no la hay se debió manejar antes
    [m, n] = size(A);
    b = A(1:m-1, n);
    costos = A(m, 1:n-1);

    % Identificamos la columna pivote (j)
    hayPivote = false;
    for j = 1:n-1
        if costos(j) < 0 
	    hayPivote = true;
            break
        end
    end

    % Checamos si hubo costo negativo
    if hayPivote  == false
        % Recorrio todo y no hay. No hay pivote
        i = 0; j = 0; % Indice 0 (no permitido) afuera se entiende como: no hay pivote
        return 
    end

    % Identificamos una columna pivote. Ahora vemos que entrada de la columna es pivote
    epsilons = b ./ (A(1:m-1 ,j) .* (A(1:m-1 ,j ) > 0)) % Dividiendo b entre los coefs de col. A no-negativos 
    [epi, i] = min(epsilons(not(isinf(epsilons)))); % Puede regresar vector vacío en i => no hay solución
end 
