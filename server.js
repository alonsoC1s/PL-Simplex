const { exec } = require('child_process')
const fs = require('fs')
const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3000

app.use(bodyParser.json()); // to support JSON-encoded bodies

app.use(express.static(__dirname + '/public')); // exposes index.html, per below

app.post('/run', async (req, res) => {
  // Obtiene el problema de programación lineal
  const lp = req.body
  // Luego lo resuelve y regresa el resultado
  const resolved = await solveLinearProblem(lp)
  res.send(resolved)
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})

app.get('/read', async (req, res) => {
  fs.readFile('tablas/server_output.csv', 'utf8', (err, data) => {
    if (err) return console.log(err);
    const table = 
    // Va renglón por renglón
  });
})

/**
 * Resuelve un problema de programación lineal.
 * @param {} lp 
 */
async function solveLinearProblem(lp) {
  // Primero, guarda el archivo en un csv
  const csv = getCSV(lp)
  // Guarda en el archivo
  await fs.writeFile('tablas/server_input.csv', csv, err => {
    if (err) console.error(err)
  })
  // Luego corre matlab
  return new Promise(resolve => {
    exec("matlab -batch \"readTableu('tablas/server_input.csv')\"", (error, stdout, stderr) => {
      if (error) {
        console.log(`error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
      }
      resolve({ res: stdout })
    });
  })
}

function getCSV(lp) {
  let csv = ''
  // Guarda restricciones
  for (const restriction of lp.restrictions) {
    for (let i = 0; i < restriction.values.length; i++) {
      if (i < restriction.values.length - 1)
        csv += restriction.values[i] + ','
      else
        csv += `"${restriction.restriction}",${restriction.values[i]}\n`
    }
  }
  // Guarda función objetivo
  for (const v of lp.objective.values)
    csv += v + ','
  csv += `,${lp.objective.restriction}`
  return csv
}