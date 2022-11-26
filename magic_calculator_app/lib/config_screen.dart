import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:magic_calculator_app/common_functions.dart';

import 'common_constants.dart';
import 'database_helper.dart';
import 'key_value_map.dart';
import 'package:provider/provider.dart';
import 'app_stat_provider.dart';

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

  _getSubTitleTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 14);
  }

  _getQuestionTextStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
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
                                '○ Black 질문 사용여부',
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '○ 튜토리얼',
                                style: _getTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '1) 기본 동작',
                                style: _getSubTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '- 입력창을 3번 터치하면 계산메뉴가 보여집니다.',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '- 입력창을 3번 더 터치하면 계산메뉴가 사라집니다',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '- 숫자 입력시 터치 카운트가 초기화됩니다',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '- 한자리 숫자 묻는 질문은 설정에서 끌 수 있습니다.',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '- 암기 편의를 위해 추천질문은 최대 4개입니다.',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '2) 박스의 색깔은 질문의 종류를 나타냅니다.',
                                style: _getSubTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '적혀있는 자리의 수를 알려주세요.',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '적혀있는 자릿수가 홀수인가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '적혀있는 자릿수가 4보다 큰가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.green),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '앞4자리가 뒷4자리보다 큰가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '3) 박스안의 숫자는 물어볼 자릿수를 의미합니다.',
                                style: _getSubTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '1 : 앞 4자리 중 첫번째 자리 (?xxx-yyyy)',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '9 : 앞 4자리 중 마지막 자리 (xxx?-yyyy)',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '11 : 뒷 4자리 중 첫번째 자리 (xxxx-?yyy)',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '19 : 뒷 4자리 중 마지막 자리 (xxxx-yyy?)',
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '4) 예시',
                                style: _getSubTitleTextStyle(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.black),
                                        child: Center(
                                            child: Text(
                                          '1',
                                          style: _getQuestionTextStyle(),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '앞 4자리의 첫번째 자리가 뭔가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      height: 20,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.red),
                                        child: Center(
                                            child: Text(
                                          '19',
                                          style: _getQuestionTextStyle(),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '뒷 4자리 중 마지막 숫자가 홀수인가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}
