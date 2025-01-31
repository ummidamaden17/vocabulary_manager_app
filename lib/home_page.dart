import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'first_course_page.dart';
import 'fourth_course_page.dart';
import 'play_page.dart';
import 'second_course_page.dart';
import 'third_course_page.dart';
import 'translator_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userNameController = TextEditingController();
  String userName = 'My Friend✌️';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'My Friend✌️';
    });
  }

  Future<void> saveUserName() async {
    final username = userNameController.text.trim();
    ("Saving username: $username");

    if (username.isEmpty || username.length <= 3 || username.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must be between 4 and 20 characters.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    ("Username saved to SharedPreferences");

    setState(() {
      userName = username;
      ("UI updated with username: $userName");
    });
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryPage()),
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

  void showEditUserNameDialog() {
    userNameController.text = userName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: userNameController,
            decoration: const InputDecoration(hintText: 'Your Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: saveUserName,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String level,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(imagePath), fit: BoxFit.cover),
                ),
                child: const SizedBox(width: 150, height: 150),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    level,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF033495),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back,',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033495),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF033495),
                      ),
                      onPressed: showEditUserNameDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    _buildCourseCard(
                      title: '1st Course',
                      level: 'Elementary level',
                      imagePath: 'assets/images/Elementary-English.png',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstCoursePage(),
                          ),
                        );
                        ("Returned from FirstCoursePage with result: $result");
                      },
                    ),
                    _buildCourseCard(
                      title: '2nd Course',
                      level: 'Intermediate level',
                      imagePath: 'assets/images/intermediate.png',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondCoursePage(),
                          ),
                        );
                        ("Returned from SecondCoursePage with result: $result");
                      },
                    ),
                    _buildCourseCard(
                      title: '3rd Course',
                      level: 'Upper Intermediate level',
                      imagePath: 'assets/images/upper-intermediate.png',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThirdCoursePage(),
                          ),
                        );
                        ("Returned from ThirdCoursePage with result: $result");
                      },
                    ),
                    _buildCourseCard(
                      title: '4th Course',
                      level: 'Advanced level',
                      imagePath: 'assets/images/advanced.png',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FourthCoursePage(),
                          ),
                        );
                        ("Returned from FourthCoursePage with result: $result");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
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
            icon: Icon(Icons.g_translate_rounded),
            label: 'New Page',
          ),
        ],
      ),
    );
  }
}
