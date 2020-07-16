var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),
    sURLVariables = sPageURL.split('&'),
    sParameterName,
    i;

  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');

    if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
    }
  }
};

var type = getUrlParameter('type');
var nom = getUrlParameter('nom');
var prenom = getUrlParameter('prenom');
var age = getUrlParameter('age');
var sex = getUrlParameter('sex');
var job = getUrlParameter('job');
var id = getUrlParameter('id') + "<<<<<<<vnt<<" + getUrlParameter('steam');
var datevoiture = getUrlParameter('datevoiture')
var datecamion = getUrlParameter('datecamion')
var point = getUrlParameter('point')
var startvisa = getUrlParameter('startvisa')
var endvisa = getUrlParameter('endvisa')
var newStr = getUrlParameter('url').replace(/ù/g, ":");
var newStr1 = newStr.replace(/_/g, "/");
var newStr2 = newStr1.replace(/!/g, ".");
var url = newStr2;

if (type === "identity") {
  $('#identity').show();
  $('#image1').attr('src',url);
  $('#nom').text(nom);
  $('#prenom').text(prenom);
  $('#dateNaissance').text(age);
  $('#sexe').text(sex);
  $('#jobs').text(job);
  $('#numCarte').text(id);
} else if (type === "permis") {
  $('#licenceDrive').show();
  $('#licenceDrive #image1').attr('src',url);
  $('#permisprenom').text(prenom);
  $('#permisdateVoiture').text(datevoiture);
  $('#permisdateCamion').text(datecamion);
  $('#permispoint').text(point);
  $('#licenceDrive #numCarte').text(id);
} else if (type === "visa") {
  $('#visa').show();
  $('#visa #image1').attr('src',url);
  $('#visanom').text(nom);
  $('#visaprenom').text(prenom);
  $('#visasexe').text(sex);
  $('#visadateNaissance').text(age);
  $('#visametier').text(job);
  $('#visadateDebut').text(startvisa);
  $('#visadateFin').text(endvisa);
  $('#visa #numCarte').text(id);
} else if (type === "close") {
  $('#visa').hide();
  $('#licenceDrive').hide();
  $('#identity').hide();
  window.location.href = 'index.html'
}
