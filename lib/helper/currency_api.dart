import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/api.dart';

class JsonCurrenciesAPIHelper {
  JsonCurrenciesAPIHelper._();

  static final JsonCurrenciesAPIHelper jsonCurrenciesAPIHelper =
      JsonCurrenciesAPIHelper._();

  Future<List> fetchSingleCurrenciesData() async {
    String uri = "https://open.er-api.com/v6/latest/USD";
    var response =
        await http.get(Uri.parse(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    var currencies = curMap.keys.toList();

    print(currencies);
    // return "Success";
    return currencies;
  }
}
