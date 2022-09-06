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
  String _firstNumberLength = "1";
  String _secondNumberLength = "1";

  final String FIRST_NUMBER_LENGTH = "firstNumberLength";
  final String SECOND_NUMBER_LENGTH = "secondNumberLength";

  TextEditingController countryCodeController = TextEditingController();
  bool _isUseCountryCode = false;

  TextEditingController prefixCodeController = TextEditingController();
  bool _isUsePrefixCode = false;

  bool _isSendBulk = false;
  TextEditingController smsTextController = TextEditingController();
  TextEditingController smsSendDelayController = TextEditingController();

  @override
  void initState() {
    loadSavedLength();
  }

  //저장된 길이 세팅
  loadSavedLength() async {
    var db = DatabaseHelper.instance;
    KeyValueMap keyValueMap = await db.selectKeyValueMap(FIRST_NUMBER_LENGTH);
    if (keyValueMap.key != null) {
      setState(() {
        _firstNumberLength = keyValueMap.value!;
      });
    }

    KeyValueMap secondKeyValueMap =
        await db.selectKeyValueMap(SECOND_NUMBER_LENGTH);
    if (secondKeyValueMap.key != null) {
      setState(() {
        _secondNumberLength = secondKeyValueMap.value!;
      });
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
    return TextStyle(
        fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    var inputNumberLength = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ];
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
                    "○ 숫자 자릿수",
                    style: _getTitleTextStyle(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("첫번째 자릿수"),
                    SizedBox(
                      width: 50,
                      child: DropdownButton(
                        isExpanded: true,
                        items: inputNumberLength
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                        value: _firstNumberLength,
                        onChanged: (String? newValue) {
                          setState(() {
                            _firstNumberLength = newValue!;
                          });

                          saveKeyValue(FIRST_NUMBER_LENGTH, newValue!);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("두번째 자릿수"),
                    SizedBox(
                      width: 50,
                      child: DropdownButton(
                        isExpanded: true,
                        items: inputNumberLength
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                        value: _secondNumberLength,
                        onChanged: (String? newValue) async {
                          setState(() {
                            _secondNumberLength = newValue!;
                          });
                          saveKeyValue(SECOND_NUMBER_LENGTH, newValue!);
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '○ 국가코드',
                    style: _getTitleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("사용여부 : "),
                    Switch(
                      value: _isUseCountryCode,
                      onChanged: (value) => setState(() {
                        _isUseCountryCode = value;
                      }),
                    ),
                    Text("코드 : "),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '국가코드(+82)'),
                        controller: countryCodeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '○ 자동입력 앞자리',
                    style: _getTitleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("사용여부 : "),
                    Switch(
                      value: _isUsePrefixCode,
                      onChanged: (value) => setState(() {
                        _isUsePrefixCode = value;
                      }),
                    ),
                    Text("코드 : "),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '자동입력 앞자리(010)'),
                        controller: prefixCodeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "○ SMS 발송",
                    style: _getTitleTextStyle(),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("대량전송 여부 : "),
                      Switch(
                        value: _isSendBulk,
                        onChanged: (value) => setState(() {
                          _isSendBulk = value;
                        }),
                      ),
                      Text("/"),
                      Text("전송 딜레이(초)"),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: '초'),
                            controller: smsSendDelayController,
                            keyboardType: TextInputType.number),
                      ),
                    ]),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "○ SMS 문구",
                    style: _getTitleTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'SMS 문구'),
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 4,
                    controller: smsTextController,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
