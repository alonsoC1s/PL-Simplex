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
  for (let i = 0; i < data.length; i++) {
    const iter = data[i]
    const div = $('<div>')
    // Muestra la iteración
    div.append($('<p>').text(`Iteración ${iter.iter}`))
    // Muestra la matriz
    const matrix = iter.A
    const table = $('<table>').addClass('table table-bordered')
    const thead = $('<thead>')
    const tbody = $('<tbody>')
    table.append(thead)
    table.append(tbody)
    for (let row = 0; row < matrix.length; row++) {
      const tr = $('<tr>')
      for (let col = 0; col < matrix[row].length; col++) {
        const val = matrix[row][col]
        const td = $('<td>').text(Number.isInteger(val) ? val : val.toFixed(3))
        // Agrega el pivote
        if (iter.i - 1 === row && iter.j - 1 === col)
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
    if (i === data.length - 1) {
      
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