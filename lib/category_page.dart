import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'models/word.dart';
import 'play_page.dart';

class CategoryPage extends StatefulWidget {
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
    print('Cleared saved words from SharedPreferences');
  }

  Future<void> addWord(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    final savedWords = await loadSavedWords();
    savedWords.add(word);

    await prefs.setStringList('saved_words',
        savedWords.map((word) => jsonEncode(word.toMap())).toList());
    print('Added word: $word');

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

    print('Removed word: $wordToRemove');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learned Words'),
        backgroundColor: Color(0xFFA8D1E7),
      ),
      body: FutureBuilder<List<Word>>(
        future: savedWordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final savedWords = snapshot.data ?? [];

          if (savedWords.isEmpty) {
            return Center(child: Text('No words saved yet!'));
          }

          return ListView.builder(
            itemCount: savedWords.length,
            itemBuilder: (context, index) {
              final word = savedWords[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(word.word),
                  subtitle: Text(word.definition),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFA8D1E7),
                    child: Text(
                      word.word[0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PlayPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black, size: 30),
            label: 'Words',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow, color: Colors.black),
            label: 'Play',
          ),
        ],
      ),
    );
  }
}
