import 'package:flashchatapp/constants.dart';
import 'package:flashchatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchatapp/roundedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static  const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   String email;
   String password;
   bool showSpiner = false;
   final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(

                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(

                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Password'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                text: 'Login',
                onPressed:  () {
                  setState(() {
                    showSpiner = true;
                  });
                  setState(() async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    }
                    catch (e) {
                      print(e);
                    }
                  });
                  setState(() {
                    showSpiner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
