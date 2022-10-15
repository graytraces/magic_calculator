import 'package:flutter/material.dart';
import 'package:magic_calculator_app/config_screen.dart';

import 'database_helper.dart';
import 'key_value_map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'number_analysis/question_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Memo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Simple Memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _magicNumber = TextEditingController();
  TextEditingController _blackAnswer = TextEditingController();

  String _resultMessage = "";
  String _firstNumberLength = "1";
  String _secondNumberLength = "1";
  bool _isUseBlackQuestion = false;

  int _hideCount = 0;
  bool _showHide = false;

  List<List<String>> _strNumberPairList = [];
  List<List<String>> _strFilteredNumberPairList = [];

  List<List<int>> _intNumberPairList = [];
  List<QuestionCase> _bestQuestionSet = [];

  QuestionCase _bestQuestion = QuestionCase([], 0);
  List<String> _answerList = [];
  QuestionMaker _questionMaker = QuestionMaker([]);

  final String FIRST_NUMBER_LENGTH = "firstNumberLength";
  final String SECOND_NUMBER_LENGTH = "secondNumberLength";
  final String BLACK_QUESTION_USE_YN = "blackQuestionUseYn";

  @override
  void initState() {
    loadSavedLength();
  }

  @override
  void dispose() {
    super.dispose();
    _magicNumber.dispose();
    _blackAnswer.dispose();
  }

  //숫자 계산
  void _calculateNumber() {
    _strNumberPairList = [];
    _strFilteredNumberPairList = [];
    _intNumberPairList = [];
    _bestQuestionSet = [];
    _bestQuestion = QuestionCase([], 0);

    var inputText = _magicNumber.text;

    if (!isInt(inputText)) {
      setState(() {
        _resultMessage = "정수 숫자를 입력해주세요";
      });
      return;
    }

    var inputNumber = int.parse(inputText);

    int startNumber = 1;
    int endNumber = 9;
    for (int idx = 1; idx < int.parse(_firstNumberLength); idx++) {
      //startNumber *= 10;
      endNumber = endNumber * 10 + 9;
    }

    String strFirstNumber = "";
    String strSecondNumber = "";

    for (int firstNumber = startNumber; firstNumber <= endNumber; firstNumber++) {
      if (inputNumber % firstNumber == 0) {
        var secondNumber = (inputNumber / firstNumber).toInt();

        if (firstNumber.toString().length > int.parse(_firstNumberLength) ||
            secondNumber.toString().length > int.parse(_secondNumberLength)) {
          continue;
        }

        strFirstNumber = firstNumber.toString();
        if (strFirstNumber.length < int.parse(_firstNumberLength)) {
          for (int idx2 = strFirstNumber.length; idx2 < int.parse(_firstNumberLength); idx2++) {
            strFirstNumber = "0" + strFirstNumber;
          }
        }

        strSecondNumber = secondNumber.toString();

        if (strSecondNumber.length < int.parse(_secondNumberLength)) {
          for (int idx2 = strSecondNumber.length; idx2 < int.parse(_secondNumberLength); idx2++) {
            strSecondNumber = "0" + strSecondNumber;
          }
        }

        _strNumberPairList.add([strFirstNumber, strSecondNumber]);
        _intNumberPairList.add([firstNumber, secondNumber]);
      }
    }

    if (_strNumberPairList.isEmpty) {
      setState(() {
        _resultMessage = "계산결과값이 없습니다";
      });
    }

    List<QuestionCase> resultList = [];
    _questionMaker = QuestionMaker(_intNumberPairList);

    QuestionCandidate? blackOneShotQuestion;
    if (_isUseBlackQuestion) {
      blackOneShotQuestion = _questionMaker.getBlackOneShotQuestion();
    }

    QuestionCase blackBestQuestion = QuestionCase([], 0);
    List<QuestionCase> blackBestQuestionSet = [];

    if (blackOneShotQuestion != null) {
      List<QuestionCandidate> blackOneshotQuestionCandidateList = [];
      List<QuestionCase> blackOneshotQuestionCaseList = [];
      blackOneshotQuestionCandidateList.add(blackOneShotQuestion);
      blackBestQuestion = QuestionCase(blackOneshotQuestionCandidateList, 1);
      blackOneshotQuestionCaseList.add(blackBestQuestion);
      blackBestQuestionSet = blackOneshotQuestionCaseList;
    }

    bool findFirstStep = false;

    for (int i = 0; i < 4; i++) {
      _questionMaker.getQuestionCase(resultList, _isUseBlackQuestion);
      _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList);

      if (_bestQuestionSet.isNotEmpty) {
        if (i == 0) {
          findFirstStep = true;
        }
        break;
      } else if (i == 0) {
        if (blackOneShotQuestion != null) {
          setState(() {
            _bestQuestion = blackBestQuestion;
            _bestQuestionSet = blackBestQuestionSet;
          });
        }
      }
    }

    // _questionMaker.getFirstDepthQuestionCase(resultList);
    // _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList);
    // if (_bestQuestionSet.isEmpty) {
    //   if (blackOneShotQuestion != null) {
    //     setState(() {
    //       _bestQuestion = blackBestQuestion;
    //       _bestQuestionSet = blackBestQuestionSet;
    //     });
    //   }
    //
    //   _questionMaker.getSecondDepthQuestionCase(resultList);
    //   _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList);
    //   if (_bestQuestionSet.isEmpty) {
    //     _questionMaker.getThirdDepthQuestionCase(resultList);
    //     _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList);
    //     if (_bestQuestionSet.isEmpty) {
    //       _questionMaker.getFourthDepthQuestionCase(resultList);
    //       _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList);
    //     }
    //   }
    // }

    for (QuestionCase qCase in _bestQuestionSet) {
      qCase.questionList.sort((a, b) => a.index - b.index);
    }

    if (_bestQuestionSet.isEmpty) {
      _bestQuestionSet.add(resultList[0]);
      setState(() {
        _bestQuestionSet[0].questionList.sort((a, b) => a.index - b.index);
      });
    } else {
      //한방에 찾았고, black을 안쓸수 있는지 확인해본다.
      if (findFirstStep) {
        QuestionCase qCase = _bestQuestionSet[_bestQuestionSet.length - 1];

        if (!qCase.questionList[0].name.contains("black")) {
          //black 외에 질문이 존재함

          for (int i = 0; i < _bestQuestionSet.length; i++) {
            QuestionCase qCase2 = _bestQuestionSet[i];
            if (qCase2.questionList[0].name.contains("black")) {
              _bestQuestionSet.remove(qCase2);
              i--;
            }
          }
        }
      }
    }

    setState(() {
      _bestQuestion = _bestQuestionSet[0];
      _answerList = List.filled(_bestQuestion.questionList.length, "false");
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  //숫자인지 검사
  bool isInt(String inputStr) {
    if (inputStr == null) {
      return false;
    }
    return int.tryParse(inputStr) != null;
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

    KeyValueMap secondKeyValueMap = await db.selectKeyValueMap(SECOND_NUMBER_LENGTH);
    if (secondKeyValueMap.key != null) {
      setState(() {
        _secondNumberLength = secondKeyValueMap.value!;
      });
    }

    KeyValueMap blackKeyValueMap = await db.selectKeyValueMap(BLACK_QUESTION_USE_YN);
    if (blackKeyValueMap.key != null) {
      _isUseBlackQuestion = blackKeyValueMap.value == "true";
    }
  }

  _getTitleTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  _launchCall(String phoneNumber) async {
    final Uri _url = Uri.parse('tel' + phoneNumber);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void _applyFilter() {
    setState(() {
      _strFilteredNumberPairList = [];
    });

    List<int> applyFilterArray = _questionMaker.getApplyFilterArray(_bestQuestion, _answerList);

    for (int i = 0; i < applyFilterArray.length; i++) {
      setState(() {
        _strFilteredNumberPairList.add(_strNumberPairList[applyFilterArray[i]]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var blackAnswerList = <String>['false', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigScreen()),
            ).then((value) => loadSavedLength());
          },
          style: TextButton.styleFrom(primary: Colors.white),
          child: const Icon(Icons.settings),
        ),
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _hideCount = _hideCount + 1;

                  if (_hideCount == 3) {
                    _hideCount = 0;

                    if (_showHide == false) {
                      _calculateNumber();
                    }

                    setState(() {
                      _showHide = !_showHide;
                    });
                  }
                },
                controller: _magicNumber,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: 10,
              ),
              SizedBox(
                height: 20,
              ),
              _showHide
                  ? Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            onPressed: () {
                              _calculateNumber();
                            },
                            child: const Text('계산하기')),
                        SizedBox(
                          height: 20,
                        ),
                        _strNumberPairList.length == 0
                            ? SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text(_resultMessage, style: _getTitleTextStyle()),
                                  ],
                                )))
                            : SizedBox(
                                width: double.infinity,
                                height: 40,
                                child:
                                    Text("경우의수 : " + _strNumberPairList.length.toString() + " 가지")),
                        SizedBox(
                          height: 20,
                        ),
                        Text("최적질문", style: _getTitleTextStyle()),
                        _bestQuestionSet.isEmpty
                            ? SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Text("최적질문이 없습니다", style: _getTitleTextStyle()),
                                    ),
                                  ],
                                )))
                            : SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(_bestQuestion.questionList[index].name),
                                        ),
                                        _bestQuestion.questionList[index].name.contains("black")
                                            ? SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: blackAnswerList
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Center(
                                                          child: Text(
                                                              value == "false" ? "선택" : value)),
                                                    );
                                                  }).toList(),
                                                  value: _answerList[index],
                                                  onChanged: (String? newValue) async {
                                                    setState(() {
                                                      _answerList[index] = newValue!;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Switch(
                                                value: _answerList[index].toLowerCase() == "true",
                                                onChanged: (value) => setState(() {
                                                  _answerList[index] = value.toString();
                                                }),
                                              ),
                                      ],
                                    );
                                  },
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _bestQuestion.questionList.length,
                                ),
                              ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            onPressed: () {
                              _applyFilter();
                            },
                            child: const Text('필터적용')),
                        _strFilteredNumberPairList.isEmpty
                            ? SizedBox(
                                width: double.infinity,
                                height: 160,
                                child: Text("답변이 잘못 입력되었습니다."),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 160,
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text("010-" +
                                              _strFilteredNumberPairList[index][0] +
                                              "-" +
                                              _strFilteredNumberPairList[index][1]),
                                        ),
                                      ],
                                    );
                                  },
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _strFilteredNumberPairList.length,
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("검증용 경우의수 출력(추후삭제)", style: _getTitleTextStyle()),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: _strNumberPairList.length * 20,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text("010-" +
                                        _strNumberPairList[index][0] +
                                        "-" +
                                        _strNumberPairList[index][1]),
                                  ),
                                ],
                              );
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _strNumberPairList.length,
                          ),
                        )
                      ],
                    )
                  : SizedBox(
                      height: 20,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
