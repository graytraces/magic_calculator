import 'dart:core';

import 'package:magic_calculator_app/number_analysis/question_helper.dart';

class NumberStatistics {
  List<List<int>> black = [
    List.filled(10, 0),
    List.filled(10, 0),
    List.filled(10, 0),
    List.filled(10, 0)
  ];

  int pairSize = 0;
  List<List<int>> statisticsMatrix = [];

  NumberStatistics(this.pairSize) {
    for (int i = 0; i < QuestionCandidate.values.length; i++) {
      statisticsMatrix.add(List.filled(pairSize, 0));
    }

    for (int i = 0; i < statisticsMatrix.length; i++) {
      for (int j = 0; j < statisticsMatrix[i].length; j++) {
        statisticsMatrix[i][j] = 0;
      }
    }
  }

  makeStatistics(List<List<int>> pairList, int firstPositionLength, int lastPositionLength) {
    int firstPositionFirstNumberDevider = 1;
    for (int i = 0; i < firstPositionLength - 1; i++) {
      firstPositionFirstNumberDevider *= 10;
    }

    int lastPositionFirstNumberDevider = 1;
    for (int i = 0; i < lastPositionLength - 1; i++) {
      lastPositionFirstNumberDevider *= 10;
    }

    for (int i = 0; i < pairList.length; i++) {
      List<int> pair = pairList[i];

      int firstPositionFirstNumber = pair[0] ~/ firstPositionFirstNumberDevider;
      if (firstPositionFirstNumber % 2 == 1) {
        statisticsMatrix[QuestionCandidate.red1.index][i] = 1;
      }

      if (firstPositionFirstNumber <= 4) {
        statisticsMatrix[QuestionCandidate.blue1.index][i] = 1;
      }
      black[0][firstPositionFirstNumber]++;
      statisticsMatrix[QuestionCandidate.black1.index][i] = firstPositionFirstNumber;

      int firstPositionLastNumber = pair[0] % 10;
      if (firstPositionLastNumber % 2 == 1) {
        statisticsMatrix[QuestionCandidate.red9.index][i] = 1;
      }

      if (firstPositionLastNumber <= 4) {
        statisticsMatrix[QuestionCandidate.blue9.index][i] = 1;
      }
      black[1][firstPositionLastNumber]++;
      statisticsMatrix[QuestionCandidate.black9.index][i] = firstPositionLastNumber;

      int lastPositionFirstNumber = pair[1] ~/ lastPositionFirstNumberDevider;
      if (lastPositionFirstNumber % 2 == 1) {
        statisticsMatrix[QuestionCandidate.red11.index][i] = 1;
      }
      if (lastPositionFirstNumber <= 4) {
        statisticsMatrix[QuestionCandidate.blue11.index][i] = 1;
      }
      black[2][lastPositionFirstNumber]++;
      statisticsMatrix[QuestionCandidate.black11.index][i] = lastPositionFirstNumber;

      int lastPositionLastNumber = pair[1] % 10;
      if (lastPositionLastNumber % 2 == 1) {
        statisticsMatrix[QuestionCandidate.red19.index][i] = 1;
      }
      if (lastPositionLastNumber <= 4) {
        statisticsMatrix[QuestionCandidate.blue19.index][i] = 1;
      }
      black[3][lastPositionLastNumber]++;
      statisticsMatrix[QuestionCandidate.black19.index][i] = lastPositionLastNumber;

      if (pair[0] > pair[1]) {
        statisticsMatrix[QuestionCandidate.green.index][i] = 1;
      }
    }
  }

  QuestionCandidate? getBlackOneShotQuestion() {
    for (int i = 0; i < 4; i++) {
      bool isBlackOneShot = true;
      for (int j = 0; j < 10; j++) {
        if (black[i][j] > 1) {
          isBlackOneShot = false;
          break;
        }
      }
      if (isBlackOneShot == false) {
        continue;
      }

      return QuestionCandidate.values[i];
    }
    return null;
  }

  //주어진 filterList의 worstCount를 구한다.
  getWorstCount(List<QuestionCandidate> filterList) {
    List<String> stringArray = List.filled(pairSize, "");

    for (int i = 0; i < pairSize; i++) {
      stringArray[i] = "";
    }

    for (int i = 0; i < pairSize; i++) {
      for (QuestionCandidate questionCandidate in filterList) {
        stringArray[i] += (statisticsMatrix[questionCandidate.index][i]).toString();
      }
    }

    Map<String, int> counter = {};

    for (int i = 0; i < pairSize; i++) {
      if (counter.containsKey(stringArray[i]) == false) {
        counter.addAll({stringArray[i]: 1});
      } else {
        counter.update(stringArray[i], (value) => (counter[stringArray[i]]! + 1));
      }
    }

    int maxValue = -1;
    for (int value in counter.values) {
      if (maxValue < value) {
        maxValue = value;
      }
    }

    return maxValue;
  }

  List<int> getApplyFilterArray(QuestionCase bestQuestion, List<String> answerList){
    //두개 순서가 같다는 가정

    List<String> filterMatrix = List.filled(pairSize, "");
    String answerStr = "";

    for(int i=0; i<bestQuestion.questionList.length; i++){

      for(int j=0; j<pairSize; j++) {
        filterMatrix[j] += statisticsMatrix[bestQuestion.questionList[i].index][j].toString();
      }

      if(answerList[i] == "true"){
        answerStr += "1";
      }else if (answerList[i] == "false"){
        answerStr += "0";
      }else{
        answerStr += answerList[i];
      }
    }

    List<int> filterIndexes = [];
    for(int i=0; i<pairSize; i++){
      if(filterMatrix[i] == answerStr){
        filterIndexes.add(i);
      }
    }

    return filterIndexes;

  }
}
