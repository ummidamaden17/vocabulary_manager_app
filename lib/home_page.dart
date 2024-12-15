import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'models/word.dart'; // Import your Word model if it's in a separate file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Word> words = [];
  List<Word> filteredWords = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  String userName = 'Guest';
  int _currentIndex = 0;

  Future<void> loadWords() async {
    final String response =
        await rootBundle.rootBundle.loadString('assets/wordnet_words.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      words = data.map((wordData) => Word.fromMap(wordData)).toList();
      filteredWords = [];
    });
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> saveUserName() async {
    final username = userNameController.text.trim();

    if (username.isEmpty || username.length <= 3 || username.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Username must be between 4 and 10 characters.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    setState(() {
      userName = username;
    });

    Navigator.of(context).pop();
  }

  void searchWords(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWords = [];
      } else {
        filteredWords = words.where((word) {
          return word.word.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> saveWordToCategory(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedWords = prefs.getStringList('saved_words') ?? [];

    // Create a JSON object for the word details
    final wordJson = json.encode({
      'word': word.word,
      'transcription': word.transcription,
      'definition': word.definition,
    });

    if (!savedWords.contains(wordJson)) {
      savedWords.add(wordJson); // Add the word JSON to the list
      await prefs.setStringList('saved_words', savedWords);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${word.word} added to categories!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${word.word} is already saved!')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    loadWords();
    loadUserName();
    searchController.addListener(() {
      searchWords(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi, $userName! 👋',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: showEditUserNameDialog,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Vocabulary',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 1, color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFBFC5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            label: Text('Search for a word',
                                style: TextStyle(color: Colors.grey)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (filteredWords.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    Word word = filteredWords[index];
                    return ListTile(
                      title: Text(word.word),
                      onTap: () {
                        showWordDetails(word); // Open details when tapped
                      },
                    );
                  },
                ),
              ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Colors.black),
            label: 'Category',
          ),
        ],
      ),
    );
  }

  void showWordDetails(Word word) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
                  saveWordToCategory(word);
                  Navigator.pop(context); // Close the modal after saving
                },
                icon: Icon(Icons.thumb_up, color: Colors.black),
                label: Text('Learn this word', style: TextStyle(color: Colors.black)),
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


  void showEditUserNameDialog() {
    userNameController.text = userName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: TextField(
            controller: userNameController,
            decoration: InputDecoration(hintText: 'Your Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: saveUserName,
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
