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
var date = getUrlParameter('date');
var nomprenom = getUrlParameter('nomprenom');
var nomprenomd = getUrlParameter('nomprenomd');
var montant = "* * " + getUrlParameter('montant') + " €";
var montant1 = "* * " + getUrlParameter('montant') + " Euro * *";
var num = getUrlParameter('num');

if (type === "show") {
  $('#cheque').show();
  $('#date').text(date);
  $('#nomprenom').text(nomprenom);
  $('#nomprenomd').text(nomprenomd);
  $('#montant').text(montant);
  $('#montant1').text(montant1);
  $('#num').text(num);
} else if (type === "close") {
  $('#cheque').hide();
}
