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
  let text
  for (let i = 0; i < numVariables; i++) {
    div.append($('<input>').addClass('form-control').attr('type', 'number'))
    text = $('<label>').text('x').append($('<sub>').text(i))
    if (i < numVariables - 1)
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
  for (let i = 0; i < numVariables; i++) {
    variables.append($('<input>').addClass('form-control').attr('type', 'number'))
    text = $('<label>').text('x').append($('<sub>').text(i))
    if (i < numVariables - 1)
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