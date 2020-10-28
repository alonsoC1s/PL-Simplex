function [i,j] = encuentra_pivote(A)
    %Salida de la funci�n [i,j] renglon i, columna j
    % Iterando sobre costos de izq a derecha as per Bland
    % Se asume que ya hay una identidad. Si no la hay se debió manejar antes
    [m, n] = size(A);
    b = A(:, n);
    costos = A(m, 1:n-1);

    % Identificamos la columna pivote (j)
    for j = 1:n-1
        if costos(j) < 0 
            break
        end
    end

    % Checamos si hubo costo negativo
<<<<<<< HEAD
    if j == n 
=======
    if j == n-1
>>>>>>> 54ac876c8a7405f0ea858d3f36b761f5d6acb79c
        % Recorrio todo y no hay. No hay pivote
        i = 0; j = 0; % Indice 0 (no permitido) afuera se entiende como: no hay pivote
        return 
    end

    % Identificamos una columna pivote. Ahora vemos que entrada de la columna es pivote
    epsilons = b ./ (A(:,j) .* (A(:,j ) > 0)); % Dividiendo b entre los coefs de col. A no-negativos 
    [epi, i] = min(epsilons(not(isinf(epsilons))));
end 
