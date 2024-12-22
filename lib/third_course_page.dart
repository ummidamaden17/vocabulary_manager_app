import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/word.dart';

class ThirdCoursePage extends StatefulWidget {
  @override
  _ThirdCoursePageState createState() => _ThirdCoursePageState();
}

class _ThirdCoursePageState extends State<ThirdCoursePage> {
  List<Word> words = [];
  List<Word> filteredWords = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _searchController = TextEditingController();

  Future<void> loadWords() async {
    try {
      final String response = await rootBundle.rootBundle
          .loadString('assets/thirdCourse_words.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        words = data.map((wordData) => Word.fromMap(wordData)).toList();
        filteredWords = List.from(words);
      });

      for (var i = 0; i < filteredWords.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    } catch (e) {
      print('Error loading words: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load words. Please try again.')),
      );
    }
  }

  void _filterWords(String query) {
    final List<Word> newFilteredWords = query.isEmpty
        ? List.from(words)
        : words
            .where(
                (word) => word.word.toLowerCase().contains(query.toLowerCase()))
            .toList();

    final List<Word> oldFilteredWords = List.from(filteredWords);

    for (int i = oldFilteredWords.length - 1; i >= 0; i--) {
      if (!newFilteredWords.contains(oldFilteredWords[i])) {
        final removedWord = oldFilteredWords[i];
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => FadeTransition(
            opacity: animation,
            child: ListTile(
              title: Text(removedWord.word),
              subtitle: Text(removedWord.definition),
            ),
          ),
        );
      }
    }

    for (int i = 0; i < newFilteredWords.length; i++) {
      if (!oldFilteredWords.contains(newFilteredWords[i])) {
        _listKey.currentState?.insertItem(i);
      }
    }

    setState(() {
      filteredWords = newFilteredWords;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWords();
    _searchController.addListener(() {
      _filterWords(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Course Words'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 1, color: Colors.grey.shade200)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: Color(0xFF033495),
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            label: Text('What do you need help with?',
                                style: TextStyle(color: Colors.grey)),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredWords.isEmpty
                ? Center(
                    child: Text(
                      'No words found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: filteredWords.length,
                    itemBuilder: (context, index, animation) {
                      final word = filteredWords[index];
                      return FadeTransition(
                        opacity: animation,
                        child: ListTile(
                          title: Text(word.word),
                          subtitle: Text(word.definition),
                          onTap: () => _showWordDetails(context, word),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showWordDetails(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word.word,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                word.transcription,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                word.definition,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  saveWordToCategory(context, word); // Save word to category
                  Navigator.pop(context);
                },
                icon: Icon(Icons.thumb_up, color: Colors.black),
                label: Text('Learn this word',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFBFC5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveWordToCategory(BuildContext context, Word word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedWords = prefs.getStringList('saved_words') ?? [];

    final wordJson = json.encode({
      'word': word.word,
      'transcription': word.transcription,
      'definition': word.definition,
    });

    print('Saved words before: $savedWords');

    if (!savedWords.contains(wordJson)) {
      savedWords.add(wordJson);
      await prefs.setStringList('saved_words', savedWords);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${word.word} added to categories!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${word.word} is already saved!')),
      );
    }

    print('Saved words after: ${prefs.getStringList('saved_words')}');
  }
}
