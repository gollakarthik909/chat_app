import 'package:flutter/material.dart';
import 'package:flashchatapp/screens/welcome_screen.dart';
import 'package:flashchatapp/screens/login_screen.dart';
import 'package:flashchatapp/screens/registration_screen.dart';
import 'package:flashchatapp/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
