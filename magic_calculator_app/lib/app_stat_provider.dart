import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'common_functions.dart';

class AppStatProvider extends ChangeNotifier{


  bool _isAuthorized = false;
  String _authKey = "";

  bool getIsAuthorized() => _isAuthorized;

  void checkAuthKey(String authKey) async{

    var uri = CommonFunctions.getUri("check_key");

    print(uri);

    var response = await http.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({"key" : authKey}));

    if (response.statusCode.toString().substring(0, 1) != "2") {
      if (response.body.length != 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['error'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "ERROR : " + response.statusCode.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    }else{
      _isAuthorized = true;
      _authKey = authKey;
    }

  }
}