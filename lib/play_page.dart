import 'package:flutter/material.dart';
import 'package:midterm_project/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'models/word.dart';
import 'translator_page.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadLearnedWords();
    });
  }

  Future<void> loadLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedWordsJson = prefs.getStringList('saved_words') ?? [];

    final wordState = Provider.of<WordState>(context, listen: false);
    wordState.loadLearnedWordsFromPrefs(savedWordsJson);
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
        const SnackBar(
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
          title: const Text('Quiz Finished!'),
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
              child: const Text('Restart Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text('Go to Home Page'),
            ),
          ],
        );
      },
    );
  }

  int _currentIndex = 2;

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => translatorPage()), // Navigate to the new page
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordState = Provider.of<WordState>(context);

    if (wordState.learnedWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Play Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No words selected to play.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryPage()),
                  );
                },
                child: const Text('Go to Category Page'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey, // Change background color
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black, // Change selected icon color
          unselectedItemColor: Colors.black54, // Change unselected icon color
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
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases),
              label: 'New Page',
            ),
          ],
        ),
      );
    }

    Word currentWord = wordState.learnedWords[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guess the word for the definition:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              currentWord.definition,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                if (!showAnswer)
                  ElevatedButton(
                    onPressed: checkAnswer,
                    child: const Text('Submit'),
                  ),
                if (showAnswer)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        isCorrect
                            ? 'Correct! 🎉'
                            : 'Wrong! ❌\nCorrect Word: ${currentWord.word}',
                        style: TextStyle(
                          fontSize: 18,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
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
        backgroundColor: Colors.blueGrey, // Change background color
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black, // Change selected icon color
        unselectedItemColor: Colors.black54, // Change unselected icon color
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
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'New Page',
          ),
        ],
      ),
    );
  }
}
