import 'package:expense/dbs/settings.dart';
import 'package:expense/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Currency{
  String code;
  BuildContext context;

  Currency(
    this.context,
    {this.code = 'USD'}
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
    final curC = Provider.of<SettingsProvider>(context).mySettings;
    return curC.currencySymbolPosition == 'Left' ? '${currencies[curC.currencyCode]}$text':'$text${currencies[curC.currencyCode]}';
  }




}