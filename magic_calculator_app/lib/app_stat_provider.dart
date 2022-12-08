import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:magic_calculator_app/common_constants.dart';

import 'common_functions.dart';
import 'database_helper.dart';
import 'key_value_map.dart';

class AppStatProvider extends ChangeNotifier {
  bool _isAuthorized = false;
  String _authKey = "";
  String _sendMessage = "";
  int _maxNumberOfCase = 1;

  bool getIsAuthorized() => _isAuthorized;
  int getMaxNumberOfCase() => _maxNumberOfCase;

  String getAuthKey() => _authKey;
  String getSendMessage() => _sendMessage;


  setMaxNumberOfCase(int paramNumberOfCase){
    _maxNumberOfCase = paramNumberOfCase;
  }


  setSendMessage(String sendMessage){
    _sendMessage = sendMessage;
  }

  checkAuthKey(String authKey, UserDeviceInfo userDeviceInfo) async {
    var uri = CommonFunctions.getUri("check_key");
    var db = DatabaseHelper.instance;

    var response = await http.post(uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          "key": authKey,
          "deviceId": userDeviceInfo.deviceId,
          "deviceModel": userDeviceInfo.deviceModel
        }));

    if (response.statusCode.toString().substring(0, 1) != "2") {
      if (response.body.length != 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['error'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);

        if(jsonDecode(response.body)['error'].toString().contains("사용중")){
          _isAuthorized = false;
          _authKey = "";
          db.deleteKeyValueMap(CommonConstants.authKeyLocalKey);
        }

        return;
      } else {
        Fluttertoast.showToast(
            msg: "ERROR : " + response.statusCode.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        return;
      }
    } else {
      _isAuthorized = true;
      _authKey = authKey;



      KeyValueMap authKeyMap = await db.selectKeyValueMap(CommonConstants.authKeyLocalKey);
      if (authKeyMap.key != null) {
        String authKey = authKeyMap.value ?? authKeyMap.value.toString();
        if (authKey.isEmpty) {
          await db.insertKeyValueMap(CommonConstants.authKeyLocalKey, authKey);
        }
      }else{
        await db.insertKeyValueMap(CommonConstants.authKeyLocalKey, authKey);
      }
    }
  }
}
