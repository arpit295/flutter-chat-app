import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? loggedInUser;
final firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;
  String? messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.yellow,
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.close),
          ),
        ],
        title: Center(
          child: Text(
            '⚡️Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('messages')
                  .orderBy('timeStamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }
                if (snapshot.hasData) {
                  final messages = snapshot.data?.docs.reversed;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages!) {
                    final messageData = message.data() as Map<String, dynamic>;
                    final messageText = messageData['text'] ?? '';
                    final messageSender = messageData['sender'] ?? '';

                    final currentUser = loggedInUser?.email;

                    // final messageBubble =Text (' $messageText from MessageSender');
                    // messageBubbles.add(messageBubble);

                    final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: currentUser == messageSender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                      child: ListView.builder(
                    itemCount: messageBubbles.length,
                    itemBuilder: (context, index) {
                      return messageBubbles[index];
                    },
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  ));
                }
                return const Center(child: Text('Please Wait'));
              },
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top:
                          BorderSide(color: Colors.lightBlueAccent, width: 2))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Your Message Here...',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'timeStamp': FieldValue.serverTimestamp(),
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
