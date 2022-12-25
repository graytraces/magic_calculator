import 'package:flutter/material.dart';
import 'package:magic_calculator_app/common_functions.dart';
import 'package:provider/provider.dart';

import '../app_stat_provider.dart';
import '../common_constants.dart';
import '../database_helper.dart';
import '../key_value_map.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigScreenStateful(Provider.of<AppStatProvider>(context, listen: false));
  }
}

class ConfigScreenStateful extends StatefulWidget {
  const ConfigScreenStateful(this._appStatProvider, {Key? key}) : super(key: key);
  final AppStatProvider _appStatProvider;

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreenStateful> {
  bool _isUseBlackQuestion = false;
  bool _showHideMenu = false;
  int _maxNumberOfCase = 1;

  TextEditingController _authKeyController = TextEditingController();
  TextEditingController _sendMessageController = TextEditingController();

  @override
  void initState() {
    loadSavedData();
  }

  @override
  void dispose() {
    super.dispose();
    _authKeyController.dispose();
    _sendMessageController.dispose();
  }

  //저장된 길이 세팅
  loadSavedData() async {
    var db = DatabaseHelper.instance;

    KeyValueMap blackQuestionUseYn = await db.selectKeyValueMap(CommonConstants.blackQuestionUseYn);

    if (blackQuestionUseYn.key != null) {
      setState(() {
        _isUseBlackQuestion = blackQuestionUseYn.value! == "true";
      });
    } else {
      //초기값은 true
      _isUseBlackQuestion = true;
      await db.insertKeyValueMap(CommonConstants.blackQuestionUseYn, true.toString());
    }

    //db.deleteKeyValueMap(CommonConstants.authKeyLocalKey);  //테스트할때 필요하면 지워라

    KeyValueMap authKeyMap = await db.selectKeyValueMap(CommonConstants.authKeyLocalKey);
    if (authKeyMap.key != null) {
      String authKey = authKeyMap.value ?? authKeyMap.value.toString();
      if (authKey.isNotEmpty) {
        setState(() {
          _authKeyController.text = authKey;
          _showHideMenu = true;
        });
      }
    }

    KeyValueMap sendMessageMap = await db.selectKeyValueMap(CommonConstants.sendMessageKeyForDB);
    if (sendMessageMap.key != null) {
      String sendMessage = sendMessageMap.value ?? sendMessageMap.value.toString();
      if (sendMessage.isNotEmpty) {
        setState(() {
          _sendMessageController.text = sendMessage;
        });
      }
    }

    KeyValueMap maxNumberOfCaseMap =
        await db.selectKeyValueMap(CommonConstants.maxNumberOfCaseKeyForDB);
    if (maxNumberOfCaseMap.key != null) {
      String maxNumberOfCase = maxNumberOfCaseMap.value ?? maxNumberOfCaseMap.value.toString();
      if (maxNumberOfCase.isNotEmpty) {
        setState(() {
          _maxNumberOfCase = int.parse(maxNumberOfCase);
        });
      }
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
    return TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
  }

  _getSubTitleTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 14);
  }

  @override
  Widget build(BuildContext context) {
    var remainNumberOfCase = <String>['1', '2', '3', '4'];

    return Scaffold(
        appBar: AppBar(title: Text('설정')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("인증키 : "),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: _authKeyController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        enabled: !_showHideMenu,
                        style: _showHideMenu
                            ? TextStyle(color: Colors.grey)
                            : TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                        onPressed: () async {
                          UserDeviceInfo userDeviceInfo = await CommonFunctions.getUserDeviceInfo();
                          await widget._appStatProvider
                              .checkAuthKey(_authKeyController.text, userDeviceInfo);
                          setState(() {
                            _showHideMenu = widget._appStatProvider.getIsAuthorized();
                          });
                        },
                        child: Text("인증하기"))
                  ],
                ),
                !_showHideMenu
                    ? SizedBox(
                        width: double.infinity,
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '○ 한자리 직접 묻는 질문 사용여부',
                                style: _getTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "사용여부 : ",
                                  style: _getContentTextStyle(),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text("N"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Switch(
                                          value: _isUseBlackQuestion,
                                          onChanged: (newValue) async {
                                            setState(() {
                                              _isUseBlackQuestion = newValue;
                                            });
                                            saveKeyValue(CommonConstants.blackQuestionUseYn,
                                                newValue.toString());
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text("Y"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '○ 최대 잔여 경우의수',
                                    style: _getTitleTextStyle(),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: remainNumberOfCase
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child:
                                              Center(child: Text(value == "false" ? "선택" : value)),
                                        );
                                      }).toList(),
                                      value: _maxNumberOfCase.toString(),
                                      onChanged: (value) async {
                                        setState(() {
                                          _maxNumberOfCase = int.parse(value.toString());
                                        });

                                        var db = DatabaseHelper.instance;
                                        db.updateKeyValueMap(
                                            CommonConstants.maxNumberOfCaseKeyForDB,
                                            value.toString());

                                        widget._appStatProvider
                                            .setMaxNumberOfCase(int.parse(value.toString()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '○ 발송메세지',
                                style: _getTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: _sendMessageController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 5),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                                  onPressed: () async {
                                    var db = DatabaseHelper.instance;

                                    String message = _sendMessageController.text;
                                    widget._appStatProvider.setSendMessage(message);

                                    KeyValueMap sendMessageMap = await db
                                        .selectKeyValueMap(CommonConstants.sendMessageKeyForDB);
                                    if (sendMessageMap.key != null) {
                                      await db.updateKeyValueMap(
                                          CommonConstants.sendMessageKeyForDB, message);
                                    } else {
                                      await db.insertKeyValueMap(
                                          CommonConstants.sendMessageKeyForDB, message);
                                    }
                                  },
                                  child: Text("저장하기")),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}
