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


%% Ventana2: 
dlgtitle = 'Desigualdades e Igualdades';

for i = 1:nRestricciones
    prompt = {['Especificar: (<=, >=, =) para la restriccion no.',i]};
    Formato = {''};
    answer = inputdlg(prompt,dlgtitle,1,Formato,options);
end
%% Ventana3 : matriz A
dlgtitle = 'Coeficientes de las restricciones';
prompt = {'introduce la Matriz A'};
Formato = {'[]'}; 
answer = inputdlg(prompt,dlgtitle,1,Formato,options);
A = str2num(answer{1});

%% Ventana4: vector b
dlgtitle = 'vector de restricciones';
prompt = {'introduce el vector b'};
Formato = {'[]'}; %Matlbal vector
answer = inputdlg(prompt,dlgtitle,1,Formato,options);
b = str2num(answer{1});
