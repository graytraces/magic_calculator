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

  _getQuestionTextStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24),
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24),
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
                          ExpansionTile(
                            title: Text(
                              '○ 튜토리얼',
                              style: _getTitleTextStyle(),
                            ),
                            children: [                          Padding(
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
                                    '- 4자리 이상의 숫자가 입력되면 경우의 수를 계산하여 화면에 마킹을 표시합니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 클립 아이콘을 2번 터치하면 답을 입력할 수 있는 계산메뉴가 보여집니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 클립 아이콘을 2번 더 터치하면 계산메뉴가 사라집니다',
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
                                    '- 한자리를 직접 묻는 질문은 설정에서 끌 수 있습니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 추천질문은 최대 4개입니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '2) 표시되는 마킹은 다음과 같습니다.',
                                    style: _getSubTitleTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 제목 옆에 (숫자) 가 표시되면 해당 자릿수가 무엇인지 물어야함을 의미합니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '제목(8) = 8번째 자리가 뭔가요?',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 북마크 버튼이 채워지면 앞자리가 큰지 뒷자리가 큰지 물어야 합니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.bookmark_border),
                                        Text('->'),
                                        Icon(Icons.bookmark),
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 키보드 위의 아이콘 중 좌측 붓 아이콘 옆 숫자는 홀짝을 물어야 하는 자릿수를 표시합니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.brush),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text('14 : 1번째, 4번째 자리가 홀수?'),
                                        ),
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '- 키보드 위의 아이콘 중 가운데 목차아이콘 옆 숫자는 4보다 큰지를 물어야 하는 자릿수를 표시합니다.',
                                    style: _getContentTextStyle(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(36, 2, 8, 2),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.format_line_spacing),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text('5 : 5번째 숫자가 4보다 큼?'),
                                        ),
                                      ],
                                    )),
                              ),],
                          ),

                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}
