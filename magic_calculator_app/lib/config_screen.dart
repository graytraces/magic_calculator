import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'key_value_map.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigScreenStateful();
  }
}

class ConfigScreenStateful extends StatefulWidget {
  const ConfigScreenStateful({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreenStateful> {
  final String BLACK_QUESTION_USE_YN = "blackQuestionUseYn";

  bool _isUseBlackQuestion = false;

  TextEditingController countryCodeController = TextEditingController();
  bool _isUseCountryCode = false;

  TextEditingController prefixCodeController = TextEditingController();
  bool _isUsePrefixCode = false;

  bool _isSendBulk = false;
  TextEditingController smsTextController = TextEditingController();
  TextEditingController smsSendDelayController = TextEditingController();

  @override
  void initState() {
    loadSavedData();
  }

  //저장된 길이 세팅
  loadSavedData() async {
    var db = DatabaseHelper.instance;

    KeyValueMap blackQuestionUseYn = await db.selectKeyValueMap(BLACK_QUESTION_USE_YN);

    if (blackQuestionUseYn.key != null) {
      setState(() {
        _isUseBlackQuestion = blackQuestionUseYn.value! == "true";
      });
    }else{
      //초기값은 true
      _isUseBlackQuestion = true;
      await db.insertKeyValueMap(BLACK_QUESTION_USE_YN, true.toString());
    }
  }

  //길이 저장
  saveKeyValue(String paramKey, String paramValue) async {
    var db = DatabaseHelper.instance;
    KeyValueMap keyValueMap = await db.selectKeyValueMap(paramKey);
    if (keyValueMap.key == null) {
      await db.insertKeyValueMap(paramKey, paramValue);
    } else {
      await db.updateKeyValueMap(paramKey, paramValue);
    }
  }

  _getTitleTextStyle() {
    return TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    var inputNumberLength = <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return Scaffold(
        appBar: AppBar(title: Text('설정')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '○ Black 질문 사용여부',
                    style: _getTitleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("사용여부 : "),
                    Switch(
                        value: _isUseBlackQuestion,
                        onChanged: (newValue) async {
                          setState(() {
                            _isUseBlackQuestion = newValue;
                          });
                          saveKeyValue(BLACK_QUESTION_USE_YN, newValue.toString());
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
