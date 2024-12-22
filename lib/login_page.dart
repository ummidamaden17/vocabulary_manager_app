import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_page.dart';
import 'registration_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String correctEmail = "ummida@gmail.com";
  final String correctPassword = "ummida07";

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == correctEmail &&
          _passwordController.text == correctPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                      width: 120,
                      height: 120,
                      child: Image(
                          image: AssetImage('assets/images/sticker4.jpg'))),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
                SizedBox(height: 10),
                Text(
                  'Hi, Enter your details to sign in \nto your account',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                      fontWeight: FontWeight.w200,
                      fontSize: 15),
                ),
                SizedBox(height: 10),
                Container(
                  width: 490,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      final trimmedValue = value?.trim();
                      if (trimmedValue == null || trimmedValue.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,}$')
                          .hasMatch(trimmedValue)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 490,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                SizedBox(height: 25),
                Container(
                  width: 490,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndLogin,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurpleAccent)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: 490,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      },
                      child: Text(
                        ' Registration',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurpleAccent)),
                    )),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Or Sign In via',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          FontAwesomeIcons.google,
                          size: 15,
                          color: Colors.orange,
                        ),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          FontAwesomeIcons.apple,
                          size: 20,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                          color: Colors.blue,
                        ),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
