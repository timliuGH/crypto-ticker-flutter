import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cryptotickerflutter/services/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  int numCrypto = cryptoList.length;
  List<String> values = [];

  List<Widget> makeCards() {
    List<Widget> cards = [];
    for (int i = 0; i < numCrypto; i++) {
      cards.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 ${cryptoList[i]} = ${values[i]} $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  // color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  DropdownButton<String> getDropdownButton() {
    // Create list of dropdown menu items
    List<DropdownMenuItem<String>> menuItems = [];
    for (String currency in currenciesList) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getRate();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          getRate();
        });
      },
      children: pickerItems,
    );
  }

  void getRate() async {
    for (int i = 0; i < values.length; i++) {
      values[i] = '?';
    }
    try {
      for (int i = 0; i < numCrypto; i++) {
        double rate = await CoinData()
            .getCoinData(crypto: cryptoList[i], fiat: selectedCurrency);
        values[i] = rate.toStringAsFixed(0);
      }
      setState(() {/* Selected currency updated along with crypto values. */});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numCrypto; i++) {
      values.add('?');
    }
    getRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: makeCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropdownButton(),
          ),
        ],
      ),
    );
  }
}
