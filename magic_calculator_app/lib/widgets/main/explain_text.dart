import 'package:flutter/material.dart';

class ExplainText extends StatelessWidget {
  const ExplainText(String this.questionName, {Key? key}) : super(key: key);
  final String questionName;

  _getQuestionExplainText(String name) {
    String questionExplainText = "";

    String questionNumber = name.replaceAll(RegExp("[^0-9]"), "");

    if (questionNumber.isNotEmpty) {
      if (questionNumber == "1") {
        //questionExplainText = "@000-0000";
        questionExplainText = "? 0 0 0 - 0 0 0 0";
      } else if (questionNumber == "4") {
        //questionExplainText = "000@-0000";
        questionExplainText = "0 0 0 ? - 0 0 0 0";
      } else if (questionNumber == "5") {
        //questionExplainText = "0000-@000";
        questionExplainText = "0 0 0 0 - ? 0 0 0";
      } else if (questionNumber == "8") {
        //questionExplainText = "0000-000@";
        questionExplainText = "0 0 0 0 - 0 0 0 ?";
      }
    } else {
      questionExplainText = "앞자리 > 뒷자리";
    }

    return questionExplainText;
  }

  _getQuestionExplainTextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getQuestionExplainText(questionName),
      //style: _getQuestionExplainTextStyle(),
      style: _getQuestionExplainTextStyle(),
    );
  }
}
