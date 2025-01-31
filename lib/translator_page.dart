import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'category_page.dart';
import 'home_page.dart';
import 'play_page.dart';

class translatorPage extends StatelessWidget {
  const translatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: translation(),
    );
  }
}

class translation extends StatefulWidget {
  const translation({super.key});

  @override
  State<translation> createState() => _translationState();
}

class _translationState extends State<translation> {
  final outputController = TextEditingController(text: 'Result here...');
  final translator = GoogleTranslator();

  String inputText = '';
  String inputLanguage = 'ru';
  String outputLanguage = 'en';
  Future<void> translateText() async {
    final translated = await translator.translate(inputText,
        from: inputLanguage, to: outputLanguage);
    setState(() {
      outputController.text = translated.text;
    });
  }

  int _currentIndex = 3;

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
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayPage()), // Navigate to the new page
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/sticker4.jpg',
                fit: BoxFit.contain,
                height: 200,
              ),
              TextField(
                maxLines: 5,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter text to translate'),
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: inputLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        inputLanguage = newValue!;
                      });
                    },
                    items: <String>[
                      'ru',
                      'en',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const Icon(Icons.arrow_forward_rounded),
                  DropdownButton<String>(
                    value: outputLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        outputLanguage = newValue!;
                      });
                    },
                    items: <String>['ru', 'en']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: translateText,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(55)),
                child: const Text('Translate'),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: outputController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
              ),
            ],
          ),
        ),
      )),
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
