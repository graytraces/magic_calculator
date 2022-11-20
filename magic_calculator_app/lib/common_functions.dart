import 'dart:io';

import 'package:device_info/device_info.dart';

class CommonFunctions {
  static getUri(String address, [Map<String, dynamic>? queryParameters]) {
    //const String baseUrl = "localhost:5000"; //ios
    //const String baseUrl = "10.0.2.2:5000";//Android

    const String baseUrl = "asia-northeast3-magic-calculator-d37ff.cloudfunctions.net";//Real

    //const String baseApiUrl = "/magic-calculator-d37ff/asia-northeast3/api/";

    const String baseApiUrl = "/api/"; //Real

    bool useHttps = true;

    Uri uri;
    if(useHttps){
      uri = Uri.https(baseUrl, baseApiUrl + address, queryParameters);
    }else{
      uri = Uri.http(baseUrl,baseApiUrl +  address, queryParameters);
    }


    return uri;
  }

  static getUserDeviceInfo() async{
    UserDeviceInfo userDeviceInfo = UserDeviceInfo();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userDeviceInfo.deviceId = androidInfo.androidId;
      userDeviceInfo.deviceModel = androidInfo.manufacturer + " " + androidInfo.model;

    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      userDeviceInfo.deviceId = iosInfo.identifierForVendor; //UUID for iOS
      userDeviceInfo.deviceModel = "Apple " + iosInfo.model;
    }
    return userDeviceInfo;
  }
}

class UserDeviceInfo{
  String deviceModel = "";
  String deviceId = "";
}