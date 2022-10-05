import 'number_statistics.dart';

enum QuestionCandidate {
  black1,
  black9,
  black11,
  black19,
  green, //앞이 커요?
  red1, //odd
  red9,
  red11,
  red19,
  blue1, //gt4
  blue9,
  blue11,
  blue19
}

class QuestionCase {
  List<QuestionCandidate> questionList;
  int worstCount;

  QuestionCase(this.questionList, this.worstCount);

  List<QuestionCandidate> getQuestionList() {
    return questionList;
  }

  void setQuestionList(List<QuestionCandidate> questionList) {
    this.questionList = questionList;
  }

  int getWorstCount() {
    return worstCount;
  }

  void setWorstCount(int worstCount) {
    this.worstCount = worstCount;
  }

  @override
  String toString() {
    String str = "";
    for (int i = 0; i < questionList.length; i++) {
      str += questionList[i].name + " " + worstCount.toString();
    }
    return str;
  }
}

class QuestionMaker {
  late int matrixSize;
  late NumberStatistics numberStatistics;

  QuestionMaker(List<List<int>> pairList) {
    this.matrixSize = QuestionCandidate.values.length;

    numberStatistics = NumberStatistics(pairList.length);
    numberStatistics.makeStatistics(pairList, 4, 4);
  }

  List<QuestionCase> getBestQuestionSet(List<QuestionCase> resultList) {
    resultList.sort((a, b) => a.worstCount - b.worstCount);
    List<QuestionCase> bestResult =
        List<QuestionCase>.from(resultList.where((questionCase) => questionCase.worstCount == 1));
    bestResult.sort((a, b) => a.questionList.length - b.questionList.length);
    return bestResult;
  }

  getFirstDepthQuestionCase(List<QuestionCase> resultList) {
    for (int i = 0; i < matrixSize; i++) {
      List<QuestionCandidate> candidateList = [];
      QuestionCandidate questionCandidate = QuestionCandidate.values[i];
      candidateList.add(questionCandidate);
      int worstCount = numberStatistics.getWorstCount(candidateList);

      //resultMap.put(candidateList, maxValue);
      resultList.add(new QuestionCase(candidateList, worstCount));
    }
  }

  getSecondDepthQuestionCase(List<QuestionCase> resultList) {
    for (int i = 0; i < matrixSize; i++) {
      List<QuestionCandidate> candidateList = [];
      QuestionCandidate questionCandidate = QuestionCandidate.values[i];
      candidateList.add(questionCandidate);
      for (int j = 0; j < matrixSize; j++) {
        QuestionCandidate questionCandidate2 = QuestionCandidate.values[j];
        if (candidateList.contains(questionCandidate2)) {
          continue;
        }
        List<QuestionCandidate> candidateList2 = List<QuestionCandidate>.from(candidateList);
        candidateList2.add(questionCandidate2);
        int maxValue = numberStatistics.getWorstCount(candidateList2);
        //resultMap.put(candidateList2, maxValue);
        resultList.add(QuestionCase(candidateList2, maxValue));
      }
    }
  }

  getThirdDepthQuestionCase(List<QuestionCase> resultList) {
    for (int i = 0; i < matrixSize; i++) {
      List<QuestionCandidate> candidateList = [];
      QuestionCandidate questionCandidate = QuestionCandidate.values[i];
      candidateList.add(questionCandidate);
      for (int j = 0; j < matrixSize; j++) {
        QuestionCandidate questionCandidate2 = QuestionCandidate.values[j];
        if (candidateList.contains(questionCandidate2)) {
          continue;
        }
        List<QuestionCandidate> candidateList2 = List<QuestionCandidate>.from(candidateList);
        candidateList2.add(questionCandidate2);

        for (int k = 0; k < matrixSize; k++) {
          QuestionCandidate questionCandidate3 = QuestionCandidate.values[k];
          if (candidateList2.contains(questionCandidate3)) {
            continue;
          }
          List<QuestionCandidate> candidateList3 = List<QuestionCandidate>.from(candidateList2);
          candidateList3.add(questionCandidate3);

          int maxValue = numberStatistics.getWorstCount(candidateList3);
          //resultMap.put(candidateList3, maxValue);
          resultList.add(new QuestionCase(candidateList3, maxValue));
        }
      }
    }
  }

  getFourthDepthQuestionCase(List<QuestionCase> resultList) {
    for (int i = 0; i < matrixSize; i++) {
      List<QuestionCandidate> candidateList = [];
      QuestionCandidate questionCandidate = QuestionCandidate.values[i];
      candidateList.add(questionCandidate);
      for (int j = 0; j < matrixSize; j++) {
        QuestionCandidate questionCandidate2 = QuestionCandidate.values[j];
        if (candidateList.contains(questionCandidate2)) {
          continue;
        }
        List<QuestionCandidate> candidateList2 = List<QuestionCandidate>.from(candidateList);
        candidateList2.add(questionCandidate2);

        for (int k = 0; k < matrixSize; k++) {
          QuestionCandidate questionCandidate3 = QuestionCandidate.values[k];
          if (candidateList2.contains(questionCandidate3)) {
            continue;
          }
          List<QuestionCandidate> candidateList3 = List<QuestionCandidate>.from(candidateList2);
          candidateList3.add(questionCandidate3);

          for (int l = 0; l < matrixSize; l++) {
            QuestionCandidate questionCandidate4 = QuestionCandidate.values[l];
            if (candidateList3.contains(questionCandidate4)) {
              continue;
            }
            List<QuestionCandidate> candidateList4 = List<QuestionCandidate>.from(candidateList3);
            candidateList4.add(questionCandidate4);

            int maxValue = numberStatistics.getWorstCount(candidateList4);
            //resultMap.put(candidateList4, maxValue);
            resultList.add(new QuestionCase(candidateList4, maxValue));
          }
        }
      }
    }
  }
}
