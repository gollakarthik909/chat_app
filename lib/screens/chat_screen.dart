import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashchatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static  const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String messageText;

  final messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    }
    catch (e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(fireStore: _fireStore),
            Container(

              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(

                    child: TextField(
                  controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageController.clear();
                      _fireStore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required Firestore fireStore,
  }) : _fireStore = fireStore, super(key: key);

  final Firestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder:(context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
         }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(text: messageText,sender: messageSender,isme: currentUser == messageSender,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
            children: messageBubbles ,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender,this.isme});
   String text;
   String sender;
   bool isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text('$sender',
          style: TextStyle(
            color: Colors.black54,
          ),
          ),
          Material(
            borderRadius: isme ?  BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))
            : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
            ),
            color: isme ? Colors.lightBlueAccent : Colors.white,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Text(
                  '$text ',
              style: TextStyle(
                fontSize: 15,
                color: isme ? Colors.white : Colors.black,
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
