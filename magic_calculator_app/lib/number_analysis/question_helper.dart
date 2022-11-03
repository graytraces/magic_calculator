import 'number_statistics.dart';

enum QuestionCandidate {
  //green : 앞이 커요?
  //black : 한자리가 뭐에요?
  //red : 홀수에요?
  //blue : 4보다 커요?
  green,
  black1,
  red1,
  blue1,
  black9,
  red9,
  blue9,
  black11,
  red11,
  blue11,
  black19,
  red19,
  blue19,
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

  QuestionCandidate? getBlackOneShotQuestion() {
    return numberStatistics.getBlackOneShotQuestion();
  }

  getQuestionCase(List<QuestionCase> resultList, bool isUseBlackQuestion) {
    if (resultList.isEmpty) {
      // 이땐 그냥 넣는다.
      for (int j = 0; j < matrixSize; j++) {
        List<QuestionCandidate> candidateList = [];
        QuestionCandidate questionCandidate = QuestionCandidate.values[j];

        //blackQuestion 미사용
        if (!isUseBlackQuestion) {
          if (questionCandidate == QuestionCandidate.black1 ||
              questionCandidate == QuestionCandidate.black9 ||
              questionCandidate == QuestionCandidate.black11 ||
              questionCandidate == QuestionCandidate.black19) {
            continue;
          }
        }

        candidateList.add(questionCandidate);
        int worstCount = numberStatistics.getWorstCount(candidateList);

        //resultMap.put(candidateList, maxValue);
        resultList.add(new QuestionCase(candidateList, worstCount));
      }
    } else {
      int existListLength = resultList.length;

      for (int i = 0; i < existListLength; i++) {
        List<QuestionCandidate> existList = resultList[i].questionList; //candidateList

        for (int j = 0; j < matrixSize; j++) {
          QuestionCandidate questionCandidate = QuestionCandidate.values[j];

          //blackQuestion 미사용
          if (!isUseBlackQuestion) {
            if (questionCandidate == QuestionCandidate.black1 ||
                questionCandidate == QuestionCandidate.black9 ||
                questionCandidate == QuestionCandidate.black11 ||
                questionCandidate == QuestionCandidate.black19) {
              continue;
            }
          }

          //이미 포함된 질문이거나, black 1개라도 포함하는지 확인
          if (existList.contains(questionCandidate) ||
              (questionCandidate.name.contains("black") &&
                  (existList.contains(QuestionCandidate.black1) ||
                      existList.contains(QuestionCandidate.black9) ||
                      existList.contains(QuestionCandidate.black11) ||
                      existList.contains(QuestionCandidate.black19)))) {
            continue;
          }

          List<QuestionCandidate> candidateList = List<QuestionCandidate>.from(existList);
          candidateList.add(questionCandidate);
          int worstCount = numberStatistics.getWorstCount(candidateList);
          resultList.add(new QuestionCase(candidateList, worstCount));
        }
      }
    }
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
        if (candidateList.contains(questionCandidate2) ||
            (questionCandidate.name.contains("black") &&
                (candidateList.contains(QuestionCandidate.black1) ||
                    candidateList.contains(QuestionCandidate.black9) ||
                    candidateList.contains(QuestionCandidate.black11) ||
                    candidateList.contains(QuestionCandidate.black19)))) {
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
        if (candidateList.contains(questionCandidate2) ||
            (questionCandidate2.name.contains("black") &&
                (candidateList.contains(QuestionCandidate.black1) ||
                    candidateList.contains(QuestionCandidate.black9) ||
                    candidateList.contains(QuestionCandidate.black11) ||
                    candidateList.contains(QuestionCandidate.black19)))) {
          continue;
        }
        List<QuestionCandidate> candidateList2 = List<QuestionCandidate>.from(candidateList);
        candidateList2.add(questionCandidate2);

        for (int k = 0; k < matrixSize; k++) {
          QuestionCandidate questionCandidate3 = QuestionCandidate.values[k];
          if (candidateList2.contains(questionCandidate3) ||
              (questionCandidate3.name.contains("black") &&
                  (candidateList2.contains(QuestionCandidate.black1) ||
                      candidateList2.contains(QuestionCandidate.black9) ||
                      candidateList2.contains(QuestionCandidate.black11) ||
                      candidateList2.contains(QuestionCandidate.black19)))) {
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
        if (candidateList.contains(questionCandidate2) ||
            (questionCandidate2.name.contains("black") &&
                (candidateList.contains(QuestionCandidate.black1) ||
                    candidateList.contains(QuestionCandidate.black9) ||
                    candidateList.contains(QuestionCandidate.black11) ||
                    candidateList.contains(QuestionCandidate.black19)))) {
          continue;
        }
        List<QuestionCandidate> candidateList2 = List<QuestionCandidate>.from(candidateList);
        candidateList2.add(questionCandidate2);

        for (int k = 0; k < matrixSize; k++) {
          QuestionCandidate questionCandidate3 = QuestionCandidate.values[k];
          if (candidateList2.contains(questionCandidate3) ||
              (questionCandidate3.name.contains("black") &&
                  (candidateList2.contains(QuestionCandidate.black1) ||
                      candidateList2.contains(QuestionCandidate.black9) ||
                      candidateList2.contains(QuestionCandidate.black11) ||
                      candidateList2.contains(QuestionCandidate.black19)))) {
            continue;
          }
          List<QuestionCandidate> candidateList3 = List<QuestionCandidate>.from(candidateList2);
          candidateList3.add(questionCandidate3);

          for (int l = 0; l < matrixSize; l++) {
            QuestionCandidate questionCandidate4 = QuestionCandidate.values[l];
            if (candidateList3.contains(questionCandidate4) ||
                (questionCandidate4.name.contains("black") &&
                    (candidateList3.contains(QuestionCandidate.black1) ||
                        candidateList3.contains(QuestionCandidate.black9) ||
                        candidateList3.contains(QuestionCandidate.black11) ||
                        candidateList3.contains(QuestionCandidate.black19)))) {
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

  List<int> getApplyFilterArray(QuestionCase bestQuestion, List<String> answerList) {
    return numberStatistics.getApplyFilterArray(bestQuestion, answerList);
  }
}
