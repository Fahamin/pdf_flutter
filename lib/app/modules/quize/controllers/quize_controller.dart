import 'package:get/get.dart';
import 'package:pdf_flutter/app/modules/quize/question_model.dart';

class QuizeController extends GetxController {
  var questionIndex = 0.obs;
  var score = 0.obs;
  var questions = <QuestionModel>[].obs;
  var isLoading = true.obs;
  var isAnswered = false.obs;
  var selectedAnswer = (-1).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void loadQuestions() {
    // Simulate loading questions from an API or database

    questions.addAll([
      QuestionModel("What is the capital of France?", [
        Answer("London", false),
        Answer("Paris", true),
        Answer("Berlin", false),
        Answer("Madrid", false),
      ]),
      QuestionModel("Which planet is known as the Red Planet?", [
        Answer("Venus", false),
        Answer("Mars", true),
        Answer("Jupiter", false),
        Answer("Saturn", false),
      ]),
      QuestionModel("Who painted the Mona Lisa?", [
        Answer("Vincent van Gogh", false),
        Answer("Pablo Picasso", false),
        Answer("Leonardo da Vinci", true),
        Answer("Michelangelo", false),
      ]),
    ]);
  }

  void nextQuestion() {
    if (questionIndex.value < questions.length - 1) {
      questionIndex.value++;
      isAnswered.value = false;
      selectedAnswer.value = -1;
    } else {
      Get.defaultDialog(
        title: "Quiz Completed",
        middleText: "Your score is ${score.value}/${questions.length}",
        onConfirm: () {
          score.value = 0; // Reset score for next quiz
          questionIndex.value = 0; // Reset question index
          isAnswered.value = false;
          selectedAnswer.value = -1; // Reset answered state
          Get.back(); // Close dialog
        },
        textConfirm: "Restart",
      );
    }
  }

  void checkAnswer(int answerIndex) {
    if (isAnswered.value) return; // Prevent multiple answers

    isAnswered.value = true;
    selectedAnswer.value = answerIndex;

    if (questions[questionIndex.value].answersList[answerIndex].isCorrect) {
      score.value++;
      Get.snackbar(
          "Correct!", "Well done!", snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Wrong!", "Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void resetQuiz() {
    questionIndex.value = 0;
    score.value = 0;
    isAnswered.value = false;
    selectedAnswer.value = -1;
  }

  String get currentQuestionText {
    return questions[questionIndex.value].questionText;
  }

  List<Answer> get currentAnswers {
    return questions[questionIndex.value].answersList;
  }

  bool get isQuizCompleted {
    return questionIndex.value >= questions.length - 1;
  }

  int get totalQuestions {
    return questions.length;
  }

  bool get isLastQuestion {
    return questionIndex.value == questions.length - 1;
  }
}
