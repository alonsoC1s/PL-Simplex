/**
 * Corre toda la información para obtener el resultado.
 */
function run() {
  const lp = getLinealProblem()
  // Muestra mensaje de cargando
  $('#display').text('Cargando...')
  $.ajax({
    url: '/run',
    type: 'POST',
    contentType:'application/json',
    data: JSON.stringify(lp),
    dataType:'json',
    success: function(data){
      //On ajax success do this
      console.log(data)
      readResult()
    },
    error: function(xhr, ajaxOptions, thrownError) {
       //On error do this
         if (xhr.status == 200) {
             console.error(ajaxOptions);
         }
         else {
             console.error(xhr.status);
             console.error(thrownError);
         }
     }
  });
}

/**
 * Lee el resultado generado en matlab.
 */
function readResult() {
  // Obtiene el resultado del servidor
  $.ajax({
    url: '/read',
    type: 'GET',
    contentType:'application/json',
    dataType:'json',
    success: function(data){
      //On ajax success do this
      showResult(data)
    },
    error: function(xhr, ajaxOptions, thrownError) {
       //On error do this
         if (xhr.status == 200) {
             console.error(ajaxOptions);
         }
         else {
             console.error(xhr.status);
             console.error(thrownError);
         }
     }
  });
}

/**
 * Muestra los resultados obtenidos.
 * @param {*} data 
 */
function showResult(data) {
  const display = $('#display').text('')
  // No acotado
  if (data.length === 0) {
    display.text('Problema no acotado :(')
    return
  }
  // Todo ok
  for (let pos = 0; pos < data.length; pos++) {
    const iter = data[pos]
    const div = $('<div>')
    // Muestra la iteración
    div.append($('<p>').text(pos < data.length - 1 ? `Iteración ${iter.iter}` : 'Tabla final'))
    // Muestra la matriz
    const matrix = iter.A
    const table = $('<table>').addClass('table table-bordered')
    const thead = $('<thead>')
    const tbody = $('<tbody>')
    table.append(thead)
    table.append(tbody)
    // Agrega datos de la tabla simplex
    for (let i = 0; i < matrix.length; i++) {
      const tr = $('<tr>')
      for (let j = 0; j < matrix[i].length; j++) {
        const val = matrix[i][j]
        const td = $('<td>').text(Number.isInteger(val) ? val : val.toFixed(3))
        // Agrega el pivote
        if (iter.i - 1 === i && iter.j - 1 === j)
          td.addClass('pivote')
        tr.append(td)
      }
      tbody.append(tr)
    }
    // Agrega el header de la tabla
    const trhead = $('<tr>')
    for (let i = 1; i <= matrix[0].length; i++) {
      // Variables
      if (i < matrix[0].length)
        trhead.append($('<th>').text('x').append($('<sub>').text(i)))
      // b
      else trhead.append($('<th>').text('b'))
    }
    thead.append(trhead)
    // Agrega la tabla al bloque
    div.append(table)

    // Si es la última tabla, entonces sacamos los valores de variables
    if (pos === data.length - 1) {
      const variables = {}
      // Pasa columna por columna ignorando la última
      for (let col = 0; col < matrix[0].length - 1; col++) {
        let nonZeros = 0
        let pivote = -1
        for (let i = 0; i < matrix.length; i++) {
          // Cuenta cuántos zeros hay en la columna
          if (matrix[i][col] !== 0)
            nonZeros++
          // Busca pivote
          if (matrix[i][col] === 1)
            pivote = i
        }
        // Checa si hubo pivote, entonces aggara el valor de b correspondiente
        if (nonZeros === 1 && pivote >= 0)
          variables[col] = matrix[pivote][matrix[0].length - 1]
        else variables[col] = 0
      }
      // Imprime los valores de las variables
      const ul = $('<ul>').addClass('variables')
      for (const num in variables) {
        let val = variables[num]
        val = Number.isInteger(val) ? val : val.toFixed(3)
        ul.append($('<li>').text('x').append($('<sub>').text(Number(num) + 1)).append(` = ${val}`))
      }
      // Agrega zeta
      let val = matrix[matrix.length - 1][matrix[0].length - 1]
      val = Number.isInteger(val) ? val : val.toFixed(3)
      ul.append($('<li>').text(`z = ${val}`))
      div.append(ul)
    }
    // Finalmente agrega div
    display.append(div)
  }
}

/**
 * Obtiene una tabla con los valores escritos.
 */
function getLinealProblem() {
  const lp = {}
  let values = []
  // Obtiene función objetivo
  const objective = $('#objective')
  let restriction = $('#minmax').val()
  for (const input of objective.find('input')) {
    let num = Number(input.value)
    values.push(isNaN(num) ? 0 : num)
  }
  lp.objective = { restriction, values }
  // Luego restricciones
  const restrictions = $('#restrictions')
  lp.restrictions = []
  for (const r of restrictions.find('.variables-display')) {
    restriction = r.getElementsByTagName('select')[0].value
    values = []
    for (const input of r.getElementsByTagName('input')) {
      let num = Number(input.value)
      values.push(isNaN(num) ? 0 : num)
    }
    lp.restrictions.push({ restriction, values })
  }
  return lp
}

/**
 * Genera los input para función objetivo.
 */
function generateObjective() {
  // Datos importantes
  const numVariables = Number($('#numVariables').val())
  // Genera función objetivo
  const div = $('#objective').text('')
  $('#restrictions').text('')
  let text
  for (let i = 1; i <= numVariables; i++) {
    div.append($('<input>').addClass('form-control').attr('type', 'number'))
    text = $('<label>').text('x').append($('<sub>').text(i))
    if (i < numVariables)
      text.append(' + ')
    div.append(text)
  }
  // Habilita las restricciones
  $('#main-display').css('display', 'block')
}

/**
 * Agrega una restricción.
 */
function addRestriction() {
  // Datos importantes
  const numVariables = Number($('#numVariables').val())
  // Genera una restricción
  const div = $('#restrictions')
  let text
  const variables = $('<div>').addClass('variables-display')
  for (let i = 1; i <= numVariables; i++) {
    variables.append($('<input>').addClass('form-control').attr('type', 'number'))
    text = $('<label>').text('x').append($('<sub>').text(i))
    if (i < numVariables)
      text.append(' + ')
    variables.append(text)
  }
  // Ahora agregamos lo de restricciones
  variables.append($('<select>').addClass('custom-select input-sm')
    .append($('<option>').val('<=').text('\u2264'))
    .append($('<option>').val('=').text('='))
    .append($('<option>').val('>=').text('\u2265'))
  )
  variables.append($('<input>').addClass('form-control').attr('type', 'number'))
  // Finalmente agregamos al div
  div.append(variables)
}