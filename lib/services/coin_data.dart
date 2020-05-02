import 'package:http/http.dart' as http;
import 'package:cryptotickerflutter/services/key.dart' as key;
import 'dart:convert';

const String apiEndpoint = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<dynamic> getCoinData({String crypto, String fiat}) async {
    http.Response response =
        await http.get('$apiEndpoint/$crypto/$fiat?apikey=${key.apiKey}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['rate'];
    } else {
      print(response.statusCode);
      throw 'Problem with GET request';
    }
  }
}

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
