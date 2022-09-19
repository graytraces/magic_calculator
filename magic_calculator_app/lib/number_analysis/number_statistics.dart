import 'dart:core';

import 'package:magic_calculator_app/number_analysis/question_helper.dart';

class NumberStatistics {
  List<List<int>> black = [
    List.filled(10, 0), List.filled(10, 0), List.filled(10, 0), List.filled(10, 0)
  ];
  List<int> greenRedBlueCnt = List.filled((QuestionCandidate.values.length - QuestionCandidate.green.index), 0);
  int green = 0;
  List<int> red = List.filled(0, 4);
  List<int> blue = List.filled(0, 4);
  int pairSize = 0;


  List<List<double>> cosSimMatrix = [];
  List<List<int>> greenRedBlueMatrix = [];

  NumberStatistics(this.pairSize){
    for(int i=0; i<QuestionCandidate.values.length - QuestionCandidate.green.index; i++){
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
}
