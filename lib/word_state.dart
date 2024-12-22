import 'package:flutter/material.dart';

import 'models/word.dart';

class WordState with ChangeNotifier {
  List<Word> learnedWords = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  void addWord(Word word) {
    learnedWords.add(word);
    notifyListeners();
  }

  void incrementCorrect() {
    correctAnswers++;
    notifyListeners();
  }

  void incrementIncorrect() {
    incorrectAnswers++;
    notifyListeners();
  }

  void reset() {
    correctAnswers = 0;
    incorrectAnswers = 0;
    learnedWords.clear();
    notifyListeners();
  }
}
