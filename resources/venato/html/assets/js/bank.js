$('#paper').show();
var win = 3;

// URL parameter
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

var cash = getUrlParameter('cash');
var bank = getUrlParameter('bank');
var type = getUrlParameter('type');

$('#senderAcc').val(getUrlParameter('account'));
$('#takeAcc').val(getUrlParameter('account'));
$('.firstname').val(getUrlParameter('firstname'));
$('.lastname').val(getUrlParameter('lastname'));
$('.saldo').text('Solde bancaire: ' + bank);
$('.saldoo').text('Solde en poche: ' + cash);

// Fleeca Banking
function fleeca() {
  $('body').removeClass('blaine');
  $('body').removeClass('pacific');
  $('#header img').css('margin-top', '0');
  $('#header img').attr('src', 'assets/images/fleeca.png');
  $('#welcome').text('Bienvenue à Fleeca Banking!');
}

// Blaine County
function blaine() {
  $('body').addClass('blaine');
  $('#header img').css('margin-top', '-10px');
  $('#header img').attr('src', 'assets/images/blaine.png');
  $('#welcome').text('Bienvenue à Blaine County Savings!');
}

// Pacific Standards
function pacific() {
  $('body').addClass('pacific');
  $('#header img').css('margin-top', '-10px');
  $('#header img').attr('src', 'assets/images/pacific.png');
  $('#welcome').text('Bienvenue à Pacific Standards!');
}

// Change bank layout
if ( type == 'fleeca' ) {
  fleeca();
} else if ( type == 'blaine' ) {
  blaine();
} else {
  pacific();
}

// Deposit money
$('#deposit').click(function() {
  if ( win > 1 ) {
    win = 1;
    $('#transaction-form').hide();
    $('#home').hide();
    $('#take-form').show();
  } else {
    var amount = $('#take-amount').val();

    if ( amount.toLowerCase() == 'allt' && cash > 0) {
      $.post('http://venato/insert', JSON.stringify({ money : cash }));

      bank = parseInt(bank) + parseInt(cash);
      cash = parseInt(cash) - parseInt(cash);

      $('.saldo').text('Solde bancaire: ' + bank.toString());
      $('.saldoo').text('Solde bancaire: ' + cash.toString());
    } else if ( amount > 0 && amount != null && amount != ' ' && cash > 0 ) {
      if ( parseInt(cash) >= parseInt(amount) ) {
        $.post('http://venato/insert', JSON.stringify({ money : amount }));

        cash = parseInt(cash) - parseInt(amount);
        bank = parseInt(bank) + parseInt(amount);

        $('.saldo').text('Solde bancaire: ' + bank.toString());
        $('.saldoo').text('Solde en poche: ' + cash.toString());
      }
    }
  }
});

// Withdraw money
$('#withdraw').click(function() {
  if ( win > 1 ) {
    win = 1;
    $('#transaction-form').hide();
    $('#home').hide();
    $('#take-form').show();
  } else {
    var amount = $('#take-amount').val();

    if ( amount.toLowerCase() == 'allt' && cash > 0) {
      $.post('http://venato/insert', JSON.stringify({ money : cash }));

      bank = parseInt(bank) + parseInt(cash);
      cash = parseInt(cash) - parseInt(cash);

      $('.saldo').text('Solde bancaire: ' + bank.toString());
      $('.saldoo').text('Solde en poche: ' + cash.toString());
    } else if ( amount > 0 && amount != null && amount != ' ' && bank > 0 ) {
      if ( parseInt(bank) >= parseInt(amount) ) {
        $.post('http://venato/take', JSON.stringify({ money : amount }));

        cash = parseInt(cash) + parseInt(amount);
        bank = parseInt(bank) - parseInt(amount);

        $('.saldo').text('Solde bancaire: ' + bank.toString());
        $('.saldoo').text('Solde en poche: ' + cash.toString());
      }
    }
  }
});

// Transfer money
$('#transfer').click(function() {
  if ( win < 2 || win > 2 ) {
    win = 2;
    $('#take-form').hide();
    $('#home').hide();
    $('#transaction-form').show();
  } else {
    var anumb = $('#receiverAcc').val();
    var onumb = $('#orgnumb').val();
    var amount = $('#transfer-amount').val();

    if ( amount > 0 && amount != null && amount != ' ' && bank > 0 && anumb.length > 0 ) {
      if ( parseInt(bank) >= parseInt(amount) ) {
        $.post('http://venato/transfer', JSON.stringify({ money : amount, account : anumb }));

        bank = parseInt(bank) - parseInt(amount);

        $('.saldo').text('Solde bancaire: ' + bank);
        $('.saldoo').text('Solde en poche: ' + cash);
      }
    }
  }
});

$('h1, h2, p').mousedown(function() {
  return false;
});

// Disable form submit
$("form").submit(function() {
	return false;
});
