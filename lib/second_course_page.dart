import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/word.dart';

class SecondCoursePage extends StatefulWidget {
  @override
  _SecondCoursePageState createState() => _SecondCoursePageState();
}

class _SecondCoursePageState extends State<SecondCoursePage> {
  List<Word> words = [];
  List<Word> filteredWords = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _searchController = TextEditingController();

  Future<void> loadWords() async {
    try {
      final String response = await rootBundle.rootBundle
          .loadString('assets/secondCourse_words.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        words = data.map((wordData) => Word.fromMap(wordData)).toList();
        filteredWords = List.from(words);
      });

      for (var i = 0; i < filteredWords.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    } catch (e) {
      ('Error loading words: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load words. Please try again.')),
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

  Future<void> saveWordToCategory(BuildContext context, Word word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedWords = prefs.getStringList('saved_words') ?? [];

    final wordJson = json.encode({
      'word': word.word,
      'transcription': word.transcription,
      'definition': word.definition,
    });

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
        title: const Text('Second Course Words'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstFlashcards(words: words),
                ),
              );
            },
          ),
        ],
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
                          color: const Color(0xFF033495),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
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
                ? const Center(
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word.word,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                word.transcription,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                word.definition,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  saveWordToCategory(context, word);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.thumb_up, color: Colors.black),
                label: const Text('Learn this word',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFBFC5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FirstFlashcards extends StatefulWidget {
  final List<Word> words;

  FirstFlashcards({required this.words});

  @override
  _FirstFlashcardsState createState() => _FirstFlashcardsState();
}

class _FirstFlashcardsState extends State<FirstFlashcards> {
  int currentIndex = 0;
  bool showDefinition = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImage(widget.words[currentIndex].word);
  }

  Future<void> _fetchImage(String word) async {
    const String apiKey = '48521316-18bb3c851e33dc1a3dc586ee2';
    final String url =
        'https://pixabay.com/api/?key=$apiKey&q=$word&image_type=photo';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['hits'].isNotEmpty) {
          setState(() {
            imageUrl = data['hits'][0]['webformatURL'];
          });
        } else {
          setState(() {
            imageUrl = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        imageUrl = null;
      });
    }
  }

  void nextCard() {
    if (currentIndex < widget.words.length - 1) {
      setState(() {
        currentIndex++;
        showDefinition = false;
        imageUrl = null; // Reset image before fetching new one
      });
      _fetchImage(widget.words[currentIndex].word);
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showDefinition = false;
        imageUrl = null;
      });
      _fetchImage(widget.words[currentIndex].word);
    }
  }

  void toggleDefinition() {
    setState(() {
      showDefinition = !showDefinition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.words[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Center(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: toggleDefinition,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!showDefinition) ...[
                    Text(
                      word.word,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      word.transcription,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ] else ...[
                    imageUrl != null
                        ? Image.network(imageUrl!,
                            width: 200, height: 200, fit: BoxFit.cover)
                        : Image.asset('assets/default_image.png',
                            width: 200, height: 200),
                    const SizedBox(height: 10),
                    Text(
                      word.definition,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: previousCard),
                      IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: nextCard),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
