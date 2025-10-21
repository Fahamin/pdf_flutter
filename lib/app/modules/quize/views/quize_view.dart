import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/quize_controller.dart';

class QuizeView extends GetView<QuizeController> {
  const QuizeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => LinearProgressIndicator(
              value: (controller.questionIndex.value + 1) /
                  controller.totalQuestions,
            )),
            const SizedBox(height: 20),
            Obx(() => Text(
              'Question ${controller.questionIndex.value + 1}/${controller.totalQuestions}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.currentQuestionText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 30),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.currentAnswers.length,
                itemBuilder: (context, index) {
                  final answer = controller.currentAnswers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isAnswered.value
                            ? (answer.isCorrect
                            ? Colors.green
                            : index == controller.selectedAnswer.value
                            ? Colors.red
                            : null)
                            : null,
                      ),
                      onPressed: controller.isAnswered.value
                          ? null
                          : () => controller.checkAnswer(index),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          answer.answerText,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
            Obx(() => controller.isAnswered.value
                ? ElevatedButton(
              onPressed: controller.nextQuestion,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  controller.isLastQuestion ? 'See Results' : 'Next Question',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}