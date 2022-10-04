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
  List<List<int>> greenRedBlueMatrix = [];

  NumberStatistics(this.pairSize) {
    for (int i = 0; i < QuestionCandidate.values.length - QuestionCandidate.green.index; i++) {
      greenRedBlueMatrix.add(List.filled(pairSize, 0));
    }

    for (int i = 0; i < greenRedBlueMatrix.length; i++) {
      for (int j = 0; j < greenRedBlueMatrix[i].length; j++) {
        greenRedBlueMatrix[i][j] = 0;
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

    int correctionValue = QuestionCandidate.green.index;

    for (int i = 0; i < pairList.length; i++) {
      List<int> pair = pairList[i];

      int firstPositionFirstNumber = pair[0] ~/ firstPositionFirstNumberDevider;
      if (firstPositionFirstNumber % 2 == 1) {
        greenRedBlueMatrix[QuestionCandidate.red1.index - correctionValue][i] = 1;
      }

      if (firstPositionFirstNumber > 4) {
        greenRedBlueMatrix[QuestionCandidate.blue1.index - correctionValue][i] = 1;
      }
      black[0][firstPositionFirstNumber]++;

      int firstPositionLastNumber = pair[0] % 10;
      if (firstPositionLastNumber % 2 == 1) {
        greenRedBlueMatrix[QuestionCandidate.red9.index - correctionValue][i] = 1;
      }

      if (firstPositionLastNumber > 4) {
        greenRedBlueMatrix[QuestionCandidate.blue9.index - correctionValue][i] = 1;
      }
      black[1][firstPositionLastNumber]++;

      int lastPositionFirstNumber = pair[1] ~/ lastPositionFirstNumberDevider;
      if (lastPositionFirstNumber % 2 == 1) {
        greenRedBlueMatrix[QuestionCandidate.red11.index - correctionValue][i] = 1;
      }
      if (lastPositionFirstNumber > 4) {
        greenRedBlueMatrix[QuestionCandidate.blue11.index - correctionValue][i] = 1;
      }
      black[2][lastPositionFirstNumber]++;

      int lastPositionLastNumber = pair[1] % 10;
      if (lastPositionLastNumber % 2 == 1) {
        greenRedBlueMatrix[QuestionCandidate.red19.index - correctionValue][i] = 1;
      }
      if (lastPositionLastNumber > 4) {
        greenRedBlueMatrix[QuestionCandidate.blue19.index - correctionValue][i] = 1;
      }
      black[3][lastPositionLastNumber]++;

      if (pair[0] > pair[1]) {
        greenRedBlueMatrix[QuestionCandidate.green.index - correctionValue][i] = 1;
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
      for (QuestionCandidate questionCandidate in filterList) {
        stringArray[i] += (greenRedBlueMatrix[questionCandidate.index - modifier][i]).toString();
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
}
