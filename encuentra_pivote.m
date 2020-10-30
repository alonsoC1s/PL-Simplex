function [i, j, epi] = encuentra_pivote(A)
    %Salida de la funci�n [i,j] renglon i, columna j
    % Iterando sobre costos de izq a derecha as per Bland
    % Se asume que ya hay una identidad. Si no la hay se debió manejar antes
    [m, n] = size(A);
    b = A(1:m-1, n);
    costos = A(m, 1:n-1);

    % Identificamos la columna pivote (j)
    % Esto se puede simplificar con un indice booleano
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
        i = 0; j = 0, epi=[]; % Indice 0 (no permitido) afuera se entiende como: no hay pivote
        return 
    end

    % Identificamos una columna pivote. Ahora vemos que entrada de la columna es pivote
    Aj = A(1:m-1, j);
    % Hacemos un índice que vuelve los no candidatos de Aj en NaNs
    Idx = Aj .* (Aj > 0); Idx(Idx==0) = nan;
    epsilons = b ./ Aj .* Idx; % Dividiendo b entre los coefs de col. A no-negativos 
    [epi, i] = min(epsilons(not(isinf(epsilons)))); % Puede regresar vector vacío en i => no hay solución
end 
