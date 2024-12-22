import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midterm_project/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'models/word.dart';
import 'word_state.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  int currentIndex = 0;
  bool showAnswer = false;
  bool isCorrect = false;
  bool finished = false;

  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLearnedWords();
  }

  Future<void> loadLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedWordsJson = prefs.getStringList('saved_words') ?? [];

    final wordState = Provider.of<WordState>(context, listen: false);
    wordState.learnedWords = savedWordsJson
        .map((wordJson) => Word.fromMap(json.decode(wordJson)))
        .toList();
    wordState.notifyListeners();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  void restartQuiz() {
    final wordState = Provider.of<WordState>(context, listen: false);
    setState(() {
      wordState.reset();
      currentIndex = 0;
      showAnswer = false;
      isCorrect = false;
      answerController.clear();
    });
    loadLearnedWords();
  }

  void checkAnswer() {
    final wordState = Provider.of<WordState>(context, listen: false);
    String userAnswer = answerController.text.trim().toLowerCase();

    if (userAnswer.isEmpty) {
      setState(() {
        showAnswer = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an answer before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String correctAnswer =
        wordState.learnedWords[currentIndex].word.toLowerCase();

    setState(() {
      isCorrect = userAnswer == correctAnswer;
      showAnswer = true;
    });

    if (isCorrect) {
      wordState.incrementCorrect();
    } else {
      wordState.incrementIncorrect();
    }
  }

  void goToNextQuestion() {
    final wordState = Provider.of<WordState>(context, listen: false);

    if (currentIndex + 1 < wordState.learnedWords.length) {
      setState(() {
        currentIndex++;
        showAnswer = false;
        answerController.clear();
        isCorrect = false;
      });
    } else {
      _showResultDialog(wordState);
    }
  }

  void _showResultDialog(WordState wordState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Finished!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Correct Answers: ${wordState.correctAnswers}'),
              Text('Incorrect Answers: ${wordState.incorrectAnswers}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                restartQuiz();
                Navigator.of(context).pop();
              },
              child: Text('Restart Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Go to Home Page'),
            ),
          ],
        );
      },
    );
  }

  void onTabTapped(int index) async {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoryPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PlayPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordState = Provider.of<WordState>(context);

    if (wordState.learnedWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Play Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No words selected to play.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                },
                child: Text('Go to Category Page'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Words',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: 'Play',
            ),
          ],
        ),
      );
    }

    Word currentWord = wordState.learnedWords[currentIndex];

    return Scaffold(
        appBar: AppBar(
          title: Text('Play Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guess the word for the definition:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                currentWord.definition,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'Your Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  if (!showAnswer)
                    ElevatedButton(
                      onPressed: checkAnswer,
                      child: Text('Submit'),
                    ),
                  if (showAnswer)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          isCorrect
                              ? 'Correct! 🎉'
                              : 'Wrong! ❌\nCorrect Word: ${currentWord.word}',
                          style: TextStyle(
                            fontSize: 18,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: goToNextQuestion,
                          child: Text(
                            currentIndex + 1 < wordState.learnedWords.length
                                ? 'Next Word'
                                : 'Finish Quiz',
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) async {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PlayPage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Words',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.play_arrow,
                size: 30,
              ),
              label: 'Play',
            ),
          ],
        ));
  }
}
