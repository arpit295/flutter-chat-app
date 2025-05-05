import 'package:flutter/material.dart';
import 'package:practice_flashchat/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final auth = FirebaseAuth.instance;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Image(
                      image: AssetImage('images/logo.png'),
                      width: 250,
                      height: 300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Your Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Your Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              WelcomeTwoButton(
                text: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  if (email == null ||
                      email!.isEmpty ||
                      password == null ||
                      password!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please enter email and password.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    return; // stop execution here
                  }

                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: email!, password: password!);
                    if (newUser != null) {
                      Navigator.pushNamed(context, 'chat_screen');
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
          if (showSpinner == true)
            Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}
