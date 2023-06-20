class Currency{
  String code;

  Currency(
    {this.code = 'GBP'}
  );


Map<String, dynamic> currencies = {
                    'YEN' :	'¥',
                    'CRC' :	'₡',
                    'CUP' :	'₱',
                    'CZK' :	'č',
                    'EUR' :	'€',
                    'GHS' :	'¢',
                    'INR' :	'₹',
                    'RIA' :	'﷼',
                    'ILS' :	'₪',
                    'WON' :	'₩',
                    'MNT' :	'₮',
                    'NGN' :	'₦',
                    'RUB' :	'₽',
                    'ZAR' :	'R',
                    'THB' :	'฿',
                    'TRY' :	'₺',
                    'UAH' :	'₴',
                    'GBP' :	'£',
                    'USD' :	'\$',
                  };

  String get currencySymbol {
    return currencies[code];
  }


  String wrapCurrencySymbol(String text) {
    return '${currencies[code]}$text';
  }




}