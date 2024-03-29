import 'package:flutter/material.dart';
import 'package:magic_calculator_app/app_stat_provider.dart';
import 'package:magic_calculator_app/common_constants.dart';
import 'package:magic_calculator_app/common_functions.dart';
import 'package:magic_calculator_app/custom_widget/above_keyboard.dart';
import 'package:magic_calculator_app/database_helper.dart';
import 'package:magic_calculator_app/key_value_map.dart';
import 'package:magic_calculator_app/number_analysis/question_helper.dart';
import 'package:magic_calculator_app/screens/calculator_home_screen.dart';
import 'package:magic_calculator_app/screens/calculator_screen.dart';
import 'package:magic_calculator_app/screens/config_screen.dart';
import 'package:magic_calculator_app/screens/tutorial_screen.dart';
import 'package:magic_calculator_app/widgets/main/explain_result.dart';
import 'package:magic_calculator_app/widgets/main/explain_text.dart';
import 'package:provider/provider.dart';

class NoteLikeScreen extends StatefulWidget {
  const NoteLikeScreen({Key? key}) : super(key: key);

  @override
  State<NoteLikeScreen> createState() => _NoteLikeScreenState();
}

enum MenuItem { item1, item2, item3, item4 }

class _NoteLikeScreenState extends State<NoteLikeScreen> {
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

  QuestionCase _bestQuestion = QuestionCase([], 0, 0);
  List<String> _answerList = [];
  QuestionMaker _questionMaker = QuestionMaker([]);

  String pageTitle = '제목';
  Icon greenIcon = Icon(Icons.bookmark_border);
  String redQuestionNumbers = " 0 ";
  String blueQuestionNumbers = " 0 ";

  _setDefaultState() {
    setState(() {
      pageTitle = '제목';
      greenIcon = Icon(Icons.bookmark_border);
      redQuestionNumbers = " 0 ";
      blueQuestionNumbers = " 0 ";
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppStatProvider appStatProvider = context.read<AppStatProvider>();
      loadSavedData(appStatProvider);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _magicNumber.dispose();
    _blackAnswer.dispose();
  }

  //숫자 계산
  void _calculateNumber(bool hideKeyboard, AppStatProvider appStatProvider) {
    _strNumberPairList = []; //입력값에 대한 pair String ver
    _intNumberPairList = []; //입력값에 대한 pair int ver

    _strFilteredNumberPairList = []; //filter 결과값

    _bestQuestionSet = []; //최종 베스트답
    _bestQuestion = QuestionCase([], 0, 0);

    _answerList = []; //입력한 답 담는곳

    var inputText = _magicNumber.text;

    if (!isInt(inputText)) {
      setState(() {
        _resultMessage = "정수 숫자를 입력해주세요";
      });
      return;
    }

    var inputNumber = int.parse(inputText);

    int startNumber = 2000;
    int endNumber = 9999;
    // for (int idx = 1; idx < int.parse(_firstNumberLength); idx++) {
    //   //startNumber *= 10;
    //   endNumber = endNumber * 10 + 9;
    // }

    String strFirstNumber = "";
    String strSecondNumber = "";

    for (int firstNumber = startNumber; firstNumber <= endNumber; firstNumber++) {
      //if (inputNumber % (100000 + firstNumber) == 0) {
      if (inputNumber % (firstNumber) == 0) {
        var secondNumber = (inputNumber / firstNumber).toInt();

        //if (firstNumber.toString().length > int.parse(_firstNumberLength) + 2 ||
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
      _setDefaultState();
      return;
    }

    List<QuestionCase> resultList = [];
    _questionMaker = QuestionMaker(_intNumberPairList);

    QuestionCandidate? blackOneShotQuestion;
    if (_isUseBlackQuestion) {
      blackOneShotQuestion = _questionMaker.getBlackOneShotQuestion();
    }

    QuestionCase blackBestQuestion = QuestionCase([], 0, 0);
    List<QuestionCase> blackBestQuestionSet = [];

    if (blackOneShotQuestion != null) {
      List<QuestionCandidate> blackOneshotQuestionCandidateList = [];
      List<QuestionCase> blackOneshotQuestionCaseList = [];
      blackOneshotQuestionCandidateList.add(blackOneShotQuestion);
      blackBestQuestion = QuestionCase(blackOneshotQuestionCandidateList, 1, 1);
      blackOneshotQuestionCaseList.add(blackBestQuestion);
      blackBestQuestionSet = blackOneshotQuestionCaseList;
    }

    bool findFirstStep = false;

    for (int i = 0; i < 4; i++) {
      //resultList = 모든 케이스를 넣는다.
      _questionMaker.getQuestionCase(resultList, _isUseBlackQuestion); //실제 답 찾는 로직
      _bestQuestionSet = _questionMaker.getBestQuestionSet(
          resultList, appStatProvider.getMaxNumberOfCase());

      if (_bestQuestionSet.isNotEmpty) {
        if (i == 0) {
          findFirstStep = true;
        }
        break;
      } else if (i == 0) {
        if (blackOneShotQuestion != null) {
          // 한방에 답 찾은경우
          setState(() {
            _bestQuestion = blackBestQuestion;
            _bestQuestionSet = blackBestQuestionSet;
          });
          break;
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

    if (hideKeyboard) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    drawMarks();
  }

  //숫자인지 검사
  bool isInt(String inputStr) {
    if (inputStr == null) {
      return false;
    }
    return int.tryParse(inputStr) != null;
  }

  //저장된 길이 세팅
  loadSavedData(AppStatProvider appStatProvider) async {
    var db = DatabaseHelper.instance;

    KeyValueMap blackKeyValueMap = await db.selectKeyValueMap(CommonConstants.blackQuestionUseYn);
    if (blackKeyValueMap.key != null) {
      _isUseBlackQuestion = blackKeyValueMap.value == "true";
    }

    KeyValueMap authKeyMap = await db.selectKeyValueMap(CommonConstants.authKeyLocalKey);
    if (authKeyMap.key != null) {
      String authKey = authKeyMap.value ?? authKeyMap.value.toString();
      if (authKey.isNotEmpty) {
        UserDeviceInfo userDeviceInfo = await CommonFunctions.getUserDeviceInfo();
        await appStatProvider.checkAuthKey(authKey, userDeviceInfo);
      }
    }

    KeyValueMap sendMessageMap = await db.selectKeyValueMap(CommonConstants.sendMessageKeyForDB);

    var defaultMessage = "안녕하세요";
    if (sendMessageMap.key == null) {
      appStatProvider.setSendMessage(defaultMessage);
      await db.insertKeyValueMap(CommonConstants.sendMessageKeyForDB, defaultMessage);
    } else {}

    KeyValueMap maxNumberOfCaseMap =
    await db.selectKeyValueMap(CommonConstants.maxNumberOfCaseKeyForDB);
    if (maxNumberOfCaseMap.key == null) {
      appStatProvider.setMaxNumberOfCase(1);
      await db.insertKeyValueMap(CommonConstants.maxNumberOfCaseKeyForDB, "1");
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

  _getQuestionNumber(String name) {
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

    AppStatProvider appStatProvider = context.read<AppStatProvider>();
    return Scaffold(
      appBar: AppBar(
          title: Text(pageTitle, style: TextStyle(color: Colors.grey)),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.grey,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: greenIcon),
            IconButton(
                onPressed: () {
                  _hideCount = _hideCount + 1;

                  if (_hideCount == 2) {
                    _hideCount = 0;

                    if (appStatProvider.getIsAuthorized()) {
                      if (_showHide == false) {
                        _calculateNumber(true, appStatProvider);
                      }

                      setState(() {
                        _showHide = !_showHide;
                      });
                    }
                  }
                },
                icon: Icon(Icons.attach_file)),
            PopupMenuButton(
              //don't specify icon if you want 3 dot menu
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: MenuItem.item1,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      Text(
                        "설정",
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.item2,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      Text(
                        "앱에 대하여",
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.item3,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      Text(
                        "그냥계산기",
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (item) => {
                if (item == MenuItem.item1)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfigScreen()),
                    ).then((value) => loadSavedData(appStatProvider))
                  }
                else if (item == MenuItem.item2)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TutorialScreen()),
                    )
                  }
                else if (item == MenuItem.item3)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalculatorScreen()),
                      )
                    }
                  else if (item == MenuItem.item4)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalculatorHomeScreen()),
                        )
                      }
              },
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onTap: () {},
                      onChanged: (value) {
                        _hideCount = 0;

                        if (appStatProvider.getIsAuthorized() && value.length > 4) {
                          _calculateNumber(false, appStatProvider);
                        }
                      },
                      controller: _magicNumber,
                      keyboardType: TextInputType.multiline,
                      minLines: 16,
                      maxLines: 16,
                    ),
                  ),
                  _showHide
                      ? Column(
                    children: [
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
                                "○ 경우의수 : " +
                                    _strNumberPairList.length.toString() +
                                    " 가지",
                                style: _getContentTextStyle())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: drawOptimalQuestion(),
                        ),
                      ),
                      ExplainResult(_strFilteredNumberPairList, appStatProvider),
                      SizedBox(
                        height: 200,
                      ),
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
          ),
          AboveKeyboard(
              redQuestionNumbers: redQuestionNumbers, blueQuestionNumbers: blueQuestionNumbers)
        ],
      ),
    );
  }

  drawMarks() {
    String localPageTitle = '제목';

    String redString = "";
    String blueString = "";
    bool hasGreen = false;

    for (int index = 0; index < _bestQuestion.questionList.length; index++) {
      if (_bestQuestion.questionList[index].name.contains("black")) {
        localPageTitle = "제목 (" + _getQuestionNumber(_bestQuestion.questionList[index].name) + ")";
      }

      if (_bestQuestion.questionList[index].name.contains("green")) {
        hasGreen = true;
      }

      if (_bestQuestion.questionList[index].name.contains("red")) {
        redString += _bestQuestion.questionList[index].name.replaceAll("red", "");
      }

      if (_bestQuestion.questionList[index].name.contains("blue")) {
        blueString += _bestQuestion.questionList[index].name.replaceAll("blue", "");
      }

      if (redString == "") {
        redQuestionNumbers = " 0 ";
      } else {
        redQuestionNumbers = redString;
      }

      if (blueString == "") {
        blueQuestionNumbers = " 0 ";
      } else {
        blueQuestionNumbers = blueString;
      }
    }

    setState(() {
      pageTitle = localPageTitle;
      if (hasGreen) {
        greenIcon = Icon(Icons.bookmark);
      }
    });
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ExplainText(_bestQuestion.questionList[index].name),
                ),
                Center(
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
                    selectedColor: Colors.white,
                    fillColor: Colors.white24,
                    color: Colors.white24,
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 60.0,
                    ),
                    isSelected: [
                      _answerList[index].toLowerCase() == "true",
                      _answerList[index].toLowerCase() == "false"
                    ],
                    children:
                    getToggleButtonTextList(_bestQuestion.questionList[index].name),
                  ),
                ),
              ],
            ),
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _bestQuestion.questionList.length,
      ),
    );
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
          'Y',
          style: _getContentTextStyle(),
        ),
        Text(
          'N',
          style: _getContentTextStyle(),
        )
      ];
    } else if (name.contains("black")) {}

    return questionAnswers;
  }
}
