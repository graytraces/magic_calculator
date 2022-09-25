import 'dart:core';

import 'package:magic_calculator_app/number_analysis/question_helper.dart';

class NumberStatistics {
  List<List<int>> black = [
    List.filled(10, 0),
    List.filled(10, 0),
    List.filled(10, 0),
    List.filled(10, 0)
  ];
  List<int> greenRedBlueCnt = List.filled(
      (QuestionCandidate.values.length - QuestionCandidate.green.index), 0);
  int green = 0;
  List<int> red = List.filled(0, 4);
  List<int> blue = List.filled(0, 4);
  int pairSize = 0;

  List<List<double>> cosSimMatrix = [];
  List<List<int>> greenRedBlueMatrix = [];

  NumberStatistics(this.pairSize) {
    for (int i = 0;
        i < QuestionCandidate.values.length - QuestionCandidate.green.index;
        i++) {
      cosSimMatrix.add(List.filled(pairSize, 0));
      greenRedBlueMatrix.add(List.filled(pairSize, 0));
    }

    for (int i = 0; i < greenRedBlueMatrix.length; i++) {
      for (int j = 0; j < greenRedBlueMatrix[i].length; j++) {
        greenRedBlueMatrix[i][j] = 0;
        cosSimMatrix[i][j] = 0;
      }
      greenRedBlueCnt[i] = 0;
    }
  }

  makeStatistics(List<List<int>> pairList, int firstPositionLength,
      int lastPositionLength) {
    int firstPositionFirstNumberDevider = 1;
    for (int i = 0; i < firstPositionLength - 1; i++) {
      firstPositionFirstNumberDevider *= 10;
    }

    int lastPositionFirstNumberDevider = 1;
    for (int i = 0; i < lastPositionLength - 1; i++) {
      lastPositionFirstNumberDevider *= 10;
    }

    int correctionValue = QuestionCandidate.green.index;

    for (int i = 0; i < pairList.length; i++) {
      List<int> pair = pairList[i];

      int firstPositionFirstNumber =
          (pair[0] / firstPositionFirstNumberDevider) as int;
      if (firstPositionFirstNumber % 2 == 1) {
        red[0]++;
        greenRedBlueCnt[QuestionCandidate.red1.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.red1.index - correctionValue][i] =
            1;
      }

      if (firstPositionFirstNumber > 4) {
        blue[0]++;
        greenRedBlueCnt[QuestionCandidate.blue1.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.blue1.index - correctionValue][i] =
            1;
      }
      black[0][firstPositionFirstNumber]++;

      int firstPositionLastNumber = pair[0] % 10;
      if (firstPositionLastNumber % 2 == 1) {
        red[1]++;
        greenRedBlueCnt[QuestionCandidate.red9.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.red9.index - correctionValue][i] =
            1;
      }

      if (firstPositionLastNumber > 4) {
        blue[1]++;
        greenRedBlueCnt[QuestionCandidate.blue9.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.blue9.index - correctionValue][i] =
            1;
      }
      black[1][firstPositionLastNumber]++;

      int lastPositionFirstNumber =
          (pair[1] / lastPositionFirstNumberDevider) as int;
      if (lastPositionFirstNumber % 2 == 1) {
        red[2]++;
        greenRedBlueCnt[QuestionCandidate.red11.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.red11.index - correctionValue][i] =
            1;
      }
      if (lastPositionFirstNumber > 4) {
        blue[2]++;
        greenRedBlueCnt[QuestionCandidate.blue11.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.blue11.index - correctionValue]
            [i] = 1;
      }
      black[2][lastPositionFirstNumber]++;

      int lastPositionLastNumber = pair[1] % 10;
      if (lastPositionLastNumber % 2 == 1) {
        red[3]++;
        greenRedBlueCnt[QuestionCandidate.red19.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.red19.index - correctionValue][i] =
            1;
      }
      if (lastPositionLastNumber > 4) {
        blue[3]++;
        greenRedBlueCnt[QuestionCandidate.blue19.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.blue19.index - correctionValue]
            [i] = 1;
      }
      black[3][lastPositionLastNumber]++;

      if (pair[0] > pair[1]) {
        green++;
        greenRedBlueCnt[QuestionCandidate.green.index - correctionValue]++;
        greenRedBlueMatrix[QuestionCandidate.green.index - correctionValue][i] =
            1;
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

  makeOptimalQuestion(List<QuestionCandidate> filterList) {
    int modifier = QuestionCandidate.green.index;
    List<String> stringArray = List.filled(pairSize, "");

    for (int i = 0; i < pairSize; i++) {
      stringArray[i] = "";
    }

    for (int i = 0; i < pairSize; i++) {
      for (int j = 0; j < filterList.length; j++) {
        stringArray[i] += (greenRedBlueMatrix[j - modifier][i]).toString();
      }
    }

    Map<String, int> counter = {};

    for (int i = 0; i < pairSize; i++) {
      if (counter.containsKey(stringArray[i]) == false) {
        counter.addAll({stringArray[i]: 1});
      } else {
        counter.update(
            stringArray[i], (value) => (counter[stringArray[i]]! + 1));
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
}
