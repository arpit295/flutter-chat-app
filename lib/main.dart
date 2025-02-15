import 'package:flutter/services.dart';
import 'package:practice_flashchat/chat_screen.dart';
import 'package:practice_flashchat/login_screen.dart';
import 'package:practice_flashchat/registration_screen.dart';
import 'package:practice_flashchat/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(FlashChat());
  });
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.lightBlueAccent),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
        home: WelcomeScreen(),
        routes: {
          'welcome_screen': (context) => WelcomeScreen(),
          'login_screen': (context) => LoginScreen(),
          'registration_screen': (context) => RegistrationScreen(),
          'chat_screen': (context) => ChatScreen(),
        });
  }
}
