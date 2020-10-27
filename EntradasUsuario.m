%% Read cost function, max/min, number of constraints
options.Resize = 'on';
dlgtitle = 'Datos del problema de programación Lineal';

prompt = {'Vector de costos (vector)',...
    'Max (enter 1) Min (enter 2)',...
    'Número de restricciones'};
Formato = {'[]', '', ''};
dims = [1 40];
answer = inputdlg(prompt, dlgtitle, dims,Formato,options);

c = str2num(answer{1});
type = str2num(answer{2}); 
nRestricciones = str2num(answer{3});

s = struct('variable',{}, 'Type', {}); %array estructura

%% Ventana2: 
dlgtitle = 'Desigualdades e Igualdades';

for i = 1:nRestricciones
    prompt = {['Especificar: (<=, >=, =) para la restriccion no.',i]};
    Formato = {''};
    answer = inputdlg(prompt,dlgtitle,1,Formato,options);
    s(1,i).Type = answer{1}; %vec_info{1} = vector de costos
    
end
%% Ventana3 : matriz A
dlgtitle = 'Coeficientes de las restricciones';
prompt = {'introduce la Matriz A'};
Formato = {'[]'}; 
answer = inputdlg(prompt,dlgtitle,1,Formato,options);
A = str2num(answer{1});

%% Fourth Window: vector b
dlgtitle = 'vector de restricciones';
prompt = {'introduce el vector b'};
Formato = {'[]'}; %Matlbal vector
answer = inputdlg(prompt,dlgtitle,1,Formato,options);
b = str2num(answer{1});

%% Ventana Casos
Matriz_Holg = []; 
Matriz_Artif = []; 

variables_holg = []; 
variables_artif = []; 
vec_b = []; 


for i = 1:nRestricciones
    n = s(1,i).Type;
    
    switch n 
        case '<='
            variables_holg = [variables_holg b(i)];
            Matriz_Holg(i,length(variables_holg))= 1;
            
        case '>='
            variables_holg = [variables_holg b(i)];
            Matriz_Holg(i,length(variables_holg)) = -1;
            
            
   
        %case '='
            %Si hay un excedente o una holgura hay que agregar una columna
            %de ceros
    end
    vec_b = [vec_b b(i)];

end
A = [A, Matriz_Holg];

