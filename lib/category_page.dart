import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midterm_project/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/word.dart';
import 'play_page.dart';
import 'translator_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<Word>>? savedWordsFuture;

  @override
  void initState() {
    super.initState();
    savedWordsFuture = loadSavedWords();
  }

  Future<List<Word>> loadSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedWordStrings = prefs.getStringList('saved_words');

    if (savedWordStrings == null) {
      return [];
    }

    return savedWordStrings
        .map((wordData) => Word.fromMap(jsonDecode(wordData)))
        .toList();
  }

  Future<void> clearSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_words');
    ('Cleared saved words from SharedPreferences');
  }

  Future<void> addWord(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    final savedWords = await loadSavedWords();
    savedWords.add(word);

    await prefs.setStringList('saved_words',
        savedWords.map((word) => jsonEncode(word.toMap())).toList());
    ('Added word: $word');

    setState(() {
      savedWordsFuture = loadSavedWords();
    });
  }

  Future<void> removeWord(String wordToRemove) async {
    setState(() {
      savedWordsFuture = savedWordsFuture?.then((savedWords) {
        savedWords.removeWhere(
          (savedWord) =>
              savedWord.word.toLowerCase() == wordToRemove.toLowerCase(),
        );
        return savedWords;
      });
    });

    final prefs = await SharedPreferences.getInstance();
    final savedWords = await loadSavedWords();
    savedWords.removeWhere(
      (savedWord) => savedWord.word.toLowerCase() == wordToRemove.toLowerCase(),
    );
    await prefs.setStringList(
      'saved_words',
      savedWords.map((word) => jsonEncode(word.toMap())).toList(),
    );

    ('Removed word: $wordToRemove');
  }

  int _currentIndex = 1;

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlayPage()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learned Words'),
        backgroundColor: const Color(0xFFA8D1E7),
      ),
      body: FutureBuilder<List<Word>>(
        future: savedWordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final savedWords = snapshot.data ?? [];

          if (savedWords.isEmpty) {
            return const Center(child: Text('No words saved yet!'));
          }

          return ListView.builder(
            itemCount: savedWords.length,
            itemBuilder: (context, index) {
              final word = savedWords[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(word.word),
                  subtitle: Text(word.definition),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFA8D1E7),
                    child: Text(
                      word.word[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeWord(word.word);
                    },
                  ),
                ),
              );
            },
          );
        },
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
