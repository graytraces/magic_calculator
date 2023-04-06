import 'package:flutter/material.dart';
import 'package:magic_calculator_app/app_stat_provider.dart';
import 'package:magic_calculator_app/number_analysis/question_helper.dart';
import 'package:magic_calculator_app/widgets/main/explain_result.dart';
import 'package:magic_calculator_app/widgets/main/explain_text.dart';
import 'package:provider/provider.dart';

class CaseCalculatorScreen extends StatefulWidget {
  const CaseCalculatorScreen({Key? key}) : super(key: key);

  @override
  _CaseCalculatorScreenState createState() => _CaseCalculatorScreenState();
}

class _CaseCalculatorScreenState extends State<CaseCalculatorScreen> {
  final double _verticalPaddingBetweenWidget = 20;

  TextEditingController inputNumberController = TextEditingController();

  int _caseNumber = 0;

  @override
  void dispose() {
    super.dispose();
    inputNumberController.dispose();
  }

  _getContentTextStyle() {
    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    AppStatProvider appStatProvider = context.read<AppStatProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: _verticalPaddingBetweenWidget,
              ),
              TextField(
                autofocus: true,
                controller: inputNumberController,
                keyboardType: TextInputType.number,
                minLines: 1,
                maxLines: 1,
              ),
              SizedBox(
                height: _verticalPaddingBetweenWidget,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      getCaseResultText(inputNumberController.text);
                    },
                    child: Text('계산하기')),
              ),
              SizedBox(
                height: _verticalPaddingBetweenWidget,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: Text("○ 경우의수 : " + _caseNumber.toString() + " 가지",
                      style: _getContentTextStyle())),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: drawOptimalQuestion(),
                ),
              ),
              ExplainResult(_strFilteredNumberPairList, appStatProvider),
            ],
          ),
        ),
      ),
    );
  }


  List<List<String>> _strNumberPairList = [];
  List<List<String>> _strFilteredNumberPairList = [];

  List<List<int>> _intNumberPairList = [];
  List<QuestionCase> _bestQuestionSet = [];

  QuestionCase _bestQuestion = QuestionCase([], 0, 0);
  List<String> _answerList = [];
  QuestionMaker _questionMaker = QuestionMaker([]);


  bool isInt(String inputStr) {
    if (inputStr == null) {
      return false;
    }
    return int.tryParse(inputStr) != null;
  }

  //숫자 계산
  void calculateNumber(String inputText) {
    String _resultMessage = "";
    String _firstNumberLength = "4";
    String _secondNumberLength = "4";

    _strNumberPairList = []; //입력값에 대한 pair String ver
    _intNumberPairList = []; //입력값에 대한 pair int ver

    _strFilteredNumberPairList = []; //filter 결과값

    _bestQuestionSet = []; //최종 베스트답
    _bestQuestion = QuestionCase([], 0, 0);

    _answerList = []; //입력한 답 담는곳

    if (!isInt(inputText)) {
      _resultMessage = "정수 숫자를 입력해주세요";
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
        if (firstNumber
            .toString()
            .length > int.parse(_firstNumberLength) ||
            secondNumber
                .toString()
                .length > int.parse(_secondNumberLength)) {
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
        _caseNumber = 0;
      });

      return;
    }

    setState(() {
      _caseNumber = _strNumberPairList.length;
    });



    List<QuestionCase> resultList = [];
    _questionMaker = QuestionMaker(_intNumberPairList);

    _questionMaker.getQuestionCase(resultList, true); //실제 답 찾는 로직
    _bestQuestionSet = _questionMaker.getBestQuestionSet(resultList, 1);


    for (QuestionCase qCase in _bestQuestionSet) {
      qCase.questionList.sort((a, b) => a.index - b.index);
    }


    setState(() {
      _bestQuestion = _bestQuestionSet[0];
      _answerList = List.filled(_bestQuestion.questionList.length, "false");
    });

    print(_bestQuestion);
  }

  String getCaseResultText(String number) {
    calculateNumber(number);

    return _intNumberPairList.length.toString();
  }

  int getFirstQuestion() {
    //계산하기 버튼에 의해서 트리거 된다.

    //경우의 수 계산 + 질문추천1번 만들기
    return 10;
  }

  int getSecondQuestion() {
    //첫번째 질문의 답에 의해서 트리거된다.
    return 10;
  }

  int getThirdQuestion() {
    //두번째 질문의 답에 의해서 트리거된다.
    return 10;
  }

  int getFourthQuestion() {
    //세번째 질문의 답에 의해서 트리거 된다.
    return 10;
  }

  int getFifthQuestion() {
    //네번째 질문의 답에 의해서 트리거 된다.
    return 10;
  }






  _getAlertTextStyle() {
    return const TextStyle(
        fontSize: 20,
        backgroundColor: Colors.yellowAccent,
        color: Colors.red,
        fontWeight: FontWeight.bold);
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


}
