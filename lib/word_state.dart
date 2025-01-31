import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/word.dart';

class WordState extends ChangeNotifier {
  List<Word> learnedWords = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  void loadLearnedWordsFromPrefs(List<String> savedWordsJson) {
    learnedWords = savedWordsJson
        .map((wordJson) => Word.fromMap(json.decode(wordJson)))
        .toList();
    notifyListeners();
  }

  void reset() {
    correctAnswers = 0;
    incorrectAnswers = 0;
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
}
