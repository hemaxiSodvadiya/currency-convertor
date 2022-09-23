import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_flutter/screens/home_page.dart';

import 'helper/currency_api.dart';
import 'models/api.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CurrencyConverter(),
      },
    ),
  );
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List currencies = [];
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String result = "";

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://open.er-api.com/v6/latest/USD";
    var response =
        await http.get(Uri.parse(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri =
        "https://open.er-api.com/v6/latest/USD?base_code=$fromCurrency&symbols=$toCurrency";
    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) *
              (responseBody["rates"][toCurrency]))
          .toString();
    });
    print(result);
    return "Success";
  }

  _onFromChanged(value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          centerTitle: true,
          title: const Text(
            "Currency Converter",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: FutureBuilder(
            future: JsonCurrenciesAPIHelper.jsonCurrenciesAPIHelper
                .fetchSingleCurrenciesData(),
            builder: (context, i) {
              if (i.hasError) {
                return Center(
                  child: Text("error :- ${i.error}"),
                );
              } else if (i.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "From Currency Amount:",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          TextFormField(
                            controller: fromTextController,
                            decoration:
                                const InputDecoration(hintText: 'Amount'),
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lime.withOpacity(
                                  0.7), //background color of dropdown button
                              border: Border.all(color: Colors.black45),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 130, right: 126),
                              child: DropDownButton(fromCurrency),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            child: FloatingActionButton(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              onPressed: _doConversion,
                              child: const Text(
                                "Convert",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lime.withOpacity(
                                  0.7), //background color of dropdown button
                              border: Border.all(color: Colors.black45),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 130, right: 126),
                              child: DropDownButton(toCurrency),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            "To Currency Amount:",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.4),
                                  width: 5),
                            ),
                            child: (result != null)
                                ? Text(
                                    result,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900),
                                  )
                                : Text(""),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Widget DropDownButton(String currCategory) {
    return DropdownButton(
      iconEnabledColor: Colors.white,
      dropdownColor: Colors.lime,
      underline: Container(
        height: 2,
        width: 80,
        color: Colors.white,
      ),
      value: currCategory,
      items: currencies
          .map((value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(
                      value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 28),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: (val) {
        if (currCategory == fromCurrency) {
          _onFromChanged(val);
        } else {
          _onToChanged(val);
        }
      },
    );
  }
}
