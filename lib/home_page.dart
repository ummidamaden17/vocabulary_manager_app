import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page.dart';
import 'first_course_page.dart';
import 'fourth_course_page.dart';
import 'play_page.dart';
import 'second_course_page.dart';
import 'third_course_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userNameController = TextEditingController();
  String userName = 'Guest';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> saveUserName() async {
    final username = userNameController.text.trim();
    print("Saving username: $username");

    if (username.isEmpty || username.length <= 3 || username.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username must be between 4 and 20 characters.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    print("Username saved to SharedPreferences");

    setState(() {
      userName = username;
      print("UI updated with username: $userName");
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
        MaterialPageRoute(builder: (context) => PlayPage()),
      );
    }
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
                offset: Offset(5, 5),
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
                child: SizedBox(width: 150, height: 150),
              ),
              SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    level,
                    style: TextStyle(
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back,',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF033495),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Color(0xFF033495),
                      ),
                      onPressed: showEditUserNameDialog,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
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
                        print(
                            "Returned from FirstCoursePage with result: $result");
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
                        print(
                            "Returned from SecondCoursePage with result: $result");
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
                        print(
                            "Returned from ThirdCoursePage with result: $result");
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
                        print(
                            "Returned from FourthCoursePage with result: $result");
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
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
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
}
