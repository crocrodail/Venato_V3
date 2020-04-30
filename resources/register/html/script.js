let infoMissing = 'Non renseigné'

GUIAction = {
    closeGui () {
        $('#register').css("display", "none")
        $("#home").css("display", "none");
        $("#cursor").css("display", "none")
    },
    openGuiRegisterIdentity () {
        $("#cursor").css("display", "block");
        $("#home").css("display", "block");
        $('#register').css("display", "flex");
    },
    clickGui () {
        var element = $(document.elementFromPoint(cursorX, cursorY))
        element.focus().click()
    }
}

window.addEventListener('message', function (event){
    let method = event.data.method
    if (GUIAction[method] !== undefined) {
        GUIAction[method](event.data.data)
    }
})


$(document).ready(function () {
    $('#register').css("display", "none")
    $("#home").css("display", "none");
    $("#cursor").css("display", "none")
    $('#register').submit(function (event) {
        event.preventDefault()
        let form = event.target
        let data = {}
        let attrs = ['nom', 'prenom', 'day','mounth','year', 'sexe', 'taille']
        attrs.forEach(e => {
            data[e] = form.elements[e].value
        })
        console.log(data.day[0])
        if (data.day < 10 && data.day[0] != 0) {
          data.day = 0 + data.day
        }
        if (data.mounth < 10 && data.mounth[0] != 0) {
          data.mounth = 0 + data.mounth
        }
        data.dateNaissance = data.year + '-' + data.mounth + '-' + data.day
        $.post('http://register/' + 'register', JSON.stringify(data))
    })
})

//
// Gestion de la souris
//
$(document).ready(function(){
    var documentWidth = document.documentElement.clientWidth
    var documentHeight = document.documentElement.clientHeight
    var cursor = $('#cursor')
    cursorX = documentWidth / 2
    cursorY = documentHeight / 2
    cursor.css('left', cursorX)
    cursor.css('top', cursorY)
    $(document).mousemove( function (event) {
        cursorX = event.pageX
        cursorY = event.pageY
        cursor.css('left', cursorX + 1)
        cursor.css('top', cursorY + 1)
    })
})

$('#form .title').on('click',function(){
  $('#form').animate({'top':'3em'},130),
  $('#form').animate({'top':'5em'},120),
  $('#form').animate({'top':'4em'},110),
  $('#form').animate({'top':'5em'},100);
  $('#form ol').slideToggle(300);
});
