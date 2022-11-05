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
    } else {
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


  _getSubTitleTextStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, );
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 14);
  }

  _getQuestionTextStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
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
                ),Padding(
                  padding: const EdgeInsets.fromLTRB(24, 2, 8, 2),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      '- 한자리 숫자 묻는 질문은 설정에서 끌 수 있습니다.',
                      style: _getContentTextStyle(),
                    ),
                  ),
                ),Padding(
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
                              child: Center(child: Text('1', style: _getQuestionTextStyle(),)),
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
                              child: Center(child: Text('19', style: _getQuestionTextStyle(),)),
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
          ),
        ));
  }
}
