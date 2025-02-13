import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Image(
                      width: 60,
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 70,
            ),
            WelcomeTwoButton(
              text: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, 'login_screen');
              },
            ),
            SizedBox(
              height: 15,
            ),
            WelcomeTwoButton(
              text: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, 'registration_screen');
              },
            )
          ],
        ),
      ),
    );
  }
}

class WelcomeTwoButton extends StatelessWidget {
  WelcomeTwoButton(
      {required this.text, required this.colour, required this.onPressed});

  final String text;
  final Color colour;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(330, 50),
        backgroundColor: colour,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}
