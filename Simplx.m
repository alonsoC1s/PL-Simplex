function Simplx(filename, varargin)

    % Verificando argumentos de ejecucion
    p = inputParser;
    addRequired(p, 'filename', @isstring);
    addOptional(p, 'servermode', false, @islogical);
    parse(p,filename, varargin{:})

    % Ingiriendo tabla de csv
    A = readTableu(filename);
    tOrig = A;

    % Aplicando simplex y guardando resultados
    [A, t, steps, Is, Js, Interms] = Simplexealo(A)

    if p.Results.servermode
        % Escribiendo a JSON para GUI
        general = struct('tabOriginal', tOrig, 'totalT', t, 'totalSteps', steps);
        pasos = cell(1, steps);

        % Escribiendo pasos
        for p = 1:steps
            i = Is(p); j = Js(p);
            Tabla = Interms(:, :, p);
            pasos{:, p} = struct('iter', p, 'i', i, 'j', j, 'A', Tabla);
        end

        % Escribiendo al archivo
        fid = fopen("simplxOutput.json", "w");
        fprintf(fid, jsonencode(pasos));

    else
        disp("Showcase")
    end

end