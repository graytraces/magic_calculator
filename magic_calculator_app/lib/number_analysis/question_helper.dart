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
  black4,
  red4,
  blue4,
  black5,
  red5,
  blue5,
  black8,
  red8,
  blue8,
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
              questionCandidate == QuestionCandidate.black4 ||
              questionCandidate == QuestionCandidate.black5 ||
              questionCandidate == QuestionCandidate.black8) {
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
                questionCandidate == QuestionCandidate.black4 ||
                questionCandidate == QuestionCandidate.black5 ||
                questionCandidate == QuestionCandidate.black8) {
              continue;
            }
          }

          //이미 포함된 질문이거나, black 1개라도 포함하는지 확인
          if (existList.contains(questionCandidate) ||
              (questionCandidate.name.contains("black") &&
                  (existList.contains(QuestionCandidate.black1) ||
                      existList.contains(QuestionCandidate.black4) ||
                      existList.contains(QuestionCandidate.black5) ||
                      existList.contains(QuestionCandidate.black8)))) {
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
  
  List<int> getApplyFilterArray(QuestionCase bestQuestion, List<String> answerList) {
    return numberStatistics.getApplyFilterArray(bestQuestion, answerList);
  }
}
