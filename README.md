# Proyecto de programación lineal

Pequeño tutorial de Simplx:

`Simplx.m` actua como el script maestro. Coordina lectura y medición de simplexealo y lectura de tablas y diferentes opciones. Hay dos maneras de llamarlo:

1. Sin argumentos: `Simplx("tablas/tablaComex.csv)`. Eso lo pone en modo normal, y solo da las soluciones de simplex y algunos otros datos

2. Con un argumento: `Simplx("tablas/tablaComex.csv, true)`. Si el segundo argumento es `true`, entrará en modo de escribir metadatos en JSON para el servidor.
    1. De entrar en modo servidor, escribe los pasos y sus metadatos en el archivo `simplxOutput.json` que se encuentra en el directorio root.

Paco: Cambié las modificaciones a `readTableu.m` y ahora toda la lectura y corrida de simplex en tu código se debe hacer llamando  `Simplx("tablas/server_input.csv, true)` y es muy imporante que el segundo argumento sea `true`.