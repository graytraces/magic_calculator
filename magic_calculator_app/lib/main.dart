import 'package:flutter/material.dart';
import 'package:magic_calculator_app/config_screen.dart';

import 'database_helper.dart';
import 'key_value_map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'number_analysis/question_helper.dart';
import 'package:provider/provider.dart';
import 'app_stat_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (BuildContext context) => AppStatProvider()),
  ], child: const MyApp() ));
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
      home: MyHomePage(Provider.of<AppStatProvider>(context, listen:false), title: 'Simple Memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this._appStatProvider, {Key? key, required this.title}) : super(key: key);
  final AppStatProvider _appStatProvider;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _magicNumber = TextEditingController();
  TextEditingController _blackAnswer = TextEditingController();

  String _resultMessage = "";
  String _firstNumberLength = "4";
  String _secondNumberLength = "4";
  bool _isUseBlackQuestion = true;

  int _hideCount = 0;
  bool _showHide = false;

  List<List<String>> _strNumberPairList = [];
  List<List<String>> _strFilteredNumberPairList = [];

  List<List<int>> _intNumberPairList = [];
  List<QuestionCase> _bestQuestionSet = [];

  QuestionCase _bestQuestion = QuestionCase([], 0);
  List<String> _answerList = [];
  QuestionMaker _questionMaker = QuestionMaker([]);

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
    _answerList = [];

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
      return;
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

    KeyValueMap blackKeyValueMap = await db.selectKeyValueMap(BLACK_QUESTION_USE_YN);
    if (blackKeyValueMap.key != null) {
      _isUseBlackQuestion = blackKeyValueMap.value == "true";
    }
  }

  _getTitleTextStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  _getAlertTextStyle() {
    return const TextStyle(
        fontSize: 20,
        backgroundColor: Colors.yellowAccent,
        color: Colors.red,
        fontWeight: FontWeight.bold);
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 16);
  }

  _getQuestionText(String name) {
    String questionText = "";

    if (name.contains("red")) {
      questionText = name.replaceAll("red", "");
    } else if (name.contains("blue")) {
      questionText = name.replaceAll("blue", "");
    } else if (name.contains("green")) {
      questionText = "xxxx > yyyy";
    } else if (name.contains("black")) {
      questionText = name.replaceAll("black", "");
    }

    return questionText;
  }

  _getQuestionExplainText(String name) {
    String questionExplainText = "";

    String questionNumber = name.replaceAll(RegExp("[^0-9]"), "");

    if (questionNumber.isNotEmpty) {
      if (questionNumber == "1") {
        //questionExplainText = "@000-0000";
        questionExplainText = "?xxx-yyyy";
      } else if (questionNumber == "9") {
        //questionExplainText = "000@-0000";
        questionExplainText = "xxx?-yyyy";
      } else if (questionNumber == "11") {
        //questionExplainText = "0000-@000";
        questionExplainText = "xxxx-?yyy";
      } else if (questionNumber == "19") {
        //questionExplainText = "0000-000@";
        questionExplainText = "xxxx-yyy?";
      }
    } else {
      questionExplainText = "xxxx-yyyy";
    }

    return questionExplainText;
  }

  _getQuestionTextStyle() {
    return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);
  }

  _getQuestionExplainTextStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  }

  Color _getQuestionBackgroundColor(String name) {
    Color questionColor = Colors.black;
    if (name.contains("red")) {
      questionColor = Colors.red;
    } else if (name.contains("blue")) {
      questionColor = Colors.blue;
    } else if (name.contains("green")) {
      questionColor = Colors.green;
    }

    return questionColor;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _hideCount = _hideCount + 1;

                  if (_hideCount == 3) {
                    _hideCount = 0;

                    if(widget._appStatProvider.getIsAuthorized()) {
                      if (_showHide == false) {
                        _calculateNumber();
                      }

                      setState(() {
                        _showHide = !_showHide;
                      });
                    }
                  }
                },
                onChanged: (value) {
                  _hideCount = 0;
                },
                controller: _magicNumber,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: 10,
              ),
            ),
            _showHide
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            onPressed: () {
                              _calculateNumber();
                            },
                            child: const Text('계산하기')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _strNumberPairList.length == 0
                            ? SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text(_resultMessage, style: _getAlertTextStyle()),
                                  ],
                                )))
                            : SizedBox(
                                width: double.infinity,
                                height: 20,
                                child: Text(
                                    "○ 경우의수 : " + _strNumberPairList.length.toString() + " 가지",
                                    style: _getContentTextStyle())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: drawOptimalQuestion(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: drawResult(),
                        ),
                      ),
                      SizedBox(height: 200,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("검증용 경우의수 출력(추후삭제)", style: _getTitleTextStyle()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
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
    );
  }

  drawOptimalQuestion() {
    var blackAnswerList = <String>['false', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    return _bestQuestionSet.isEmpty
        ? SizedBox(
            width: double.infinity,
            height: 90,
            child: Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("최적질문이 없습니다", style: _getAlertTextStyle()),
                ),
              ],
            )))
        : SizedBox(
            width: double.infinity,
            height: (90 * _bestQuestion.questionList.length).toDouble(),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: SizedBox(
                        width: 140,
                        height: 80,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: _getQuestionBackgroundColor(
                                  _bestQuestion.questionList[index].name)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      _getQuestionText(_bestQuestion.questionList[index].name),
                                      style: _getQuestionTextStyle()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    _getQuestionExplainText(_bestQuestion.questionList[index].name),
                                    style: _getQuestionExplainTextStyle(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _bestQuestion.questionList[index].name.contains("black")
                            ? SizedBox(
                                width: 100,
                                height: 40,
                                child: DropdownButton(
                                  isExpanded: true,
                                  items:
                                      blackAnswerList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Center(child: Text(value == "false" ? "선택" : value)),
                                    );
                                  }).toList(),
                                  value: _answerList[index],
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      _answerList[index] = newValue!;
                                    });
                                    _applyFilter();
                                  },
                                ),
                              )
                            : ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: (int toggleIndex) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    _answerList[index] = (0 == toggleIndex).toString();
                                  });
                                  _applyFilter();
                                },
                                selectedBorderColor: getToggleButtonSelectedColor(
                                    _bestQuestion.questionList[index].name),
                                selectedColor: getToggleButtonSelectedColor(
                                    _bestQuestion.questionList[index].name),
                                fillColor: Colors.white,
                                color: Colors.grey,
                                constraints: const BoxConstraints(
                                  minHeight: 40.0,
                                  minWidth: 80.0,
                                ),
                                isSelected: [
                                  _answerList[index].toLowerCase() == "true",
                                  _answerList[index].toLowerCase() == "false"
                                ],
                                children:
                                    getToggleButtonTextList(_bestQuestion.questionList[index].name),
                              ),
                      ),
                    ),
                  ],
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bestQuestion.questionList.length,
            ),
          );
  }

  getToggleButtonSelectedColor(String name) {
    Color returnColor = Colors.white;

    if (name.contains("red")) {
      returnColor = Colors.red;
    } else if (name.contains("blue")) {
      returnColor = Colors.blue;
    } else if (name.contains("green")) {
      returnColor = Colors.green;
    } else if (name.contains("black")) {}

    return returnColor;
  }

  getToggleButtonTextList(String name) {
    List<Widget> questionAnswers = [];

    if (name.contains("red")) {
      questionAnswers = <Widget>[
        Text(
          '홀',
          style: _getContentTextStyle(),
        ),
        Text(
          '짝',
          style: _getContentTextStyle(),
        )
      ];
    } else if (name.contains("blue")) {
      questionAnswers = <Widget>[
        Text(
          '0~4',
          style: _getContentTextStyle(),
        ),
        Text(
          '5~9',
          style: _getContentTextStyle(),
        )
      ];
    } else if (name.contains("green")) {
      questionAnswers = <Widget>[
        Text(
          '앞',
          style: _getContentTextStyle(),
        ),
        Text(
          '뒤',
          style: _getContentTextStyle(),
        )
      ];
    } else if (name.contains("black")) {}

    return questionAnswers;
  }

  drawResult() {
    return _strFilteredNumberPairList.isEmpty
        ? Text(
            "답변이 잘못 입력되었습니다.",
            style: _getContentTextStyle(),
          )
        : SizedBox(
            width: double.infinity,
            height: (20 * _strFilteredNumberPairList.length).toDouble(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
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
          );
  }
}
