import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/word.dart';
import 'home_page.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Word> savedWords = []; // Stores the saved words

  // Load saved words from SharedPreferences
  Future<void> loadSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedWordStrings = prefs.getStringList('saved_words');

    setState(() {
      // Convert the saved strings into Word objects
      savedWords = savedWordStrings?.map((wordData) {
        // Assuming you store a map of word data as a JSON string
        return Word.fromMap(jsonDecode(wordData));
      }).toList() ?? [];
    });
  }

  // Remove a word from the saved list
  // Remove a word from the saved list
  Future<void> removeWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Remove the word from the list
      savedWords.removeWhere((savedWord) => savedWord.word == word);

      // Save the updated list of words to SharedPreferences
      prefs.setStringList('saved_words', savedWords.map((word) => jsonEncode(word.toMap())).toList());
    });

    // Show a message that the word was removed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$word removed from your learning list!')),
    );
  }


  // Initialize the saved words when the screen opens
  @override
  void initState() {
    super.initState();
    loadSavedWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learned Words'),
        backgroundColor: Color(0xFFA8D1E7),
      ),
      body: savedWords.isEmpty
          ? const Center(
        child: Text(
          'No words added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: savedWords.length,
        itemBuilder: (context, index) {
          final word = savedWords[index]; // Get the Word object

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                word.word, // Access word property
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(word.definition), // Access definition property
              leading: CircleAvatar(
                backgroundColor: Color(0xFFA8D1E7),
                child: Text(
                  word.word[0].toUpperCase(), // First letter of the word
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  removeWord(word.word); // Pass the word.word (the word as a string)
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set current tab to 'Categories'
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ); // Navigate to Home
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Colors.black, size: 30),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}
