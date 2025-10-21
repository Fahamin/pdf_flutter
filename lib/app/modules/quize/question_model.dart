class QuestionModel {
  final String questionText;
  final List<Answer> answersList;

  QuestionModel(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer(this.answerText, this.isCorrect);
}
