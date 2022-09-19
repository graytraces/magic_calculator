enum QuestionCandidate {
  black1,
  black9,
  black11,
  black19,
  green,  //앞이 커요?
  red1,   //odd
  red9,
  red11,
  red19,
  blue1,  //gt4
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
}
