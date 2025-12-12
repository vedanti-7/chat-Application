import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget{
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage>{
  var _messageController=TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();   //to make sure the memory resources occupied by the controller get freed up as its not needed anymore 
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage=_messageController.text;

    if(enteredMessage.trim().isEmpty){
      return;
    }

    FocusScope.of(context).unfocus();  //will close any open keyboard by removing the focus from the input field
    _messageController.clear();  //so the text checked by the textcontroller gets emptied for the next field or for the next instance to check 

    final user=FirebaseAuth.instance.currentUser!;
    final userData=await FirebaseFirestore.instance.collection('users').doc(user.uid).get(); //gives us the user detail retrieved fron the 'users' collection of that user's. id 
    
    FirebaseFirestore.instance.collection('chat').add({ //automatically generates unique doc name 
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid, 
      'username': userData.data()!['username'],  //userData provoded a map<dynamic, string> a snapshot of data basically so we used the data method to access the actual data
      'userImage': userData.data()!['image_url'],
    });

     
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,  //will capitalize the start of sentence
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            color: const Color.fromARGB(255, 95, 137, 137),
            onPressed: _submitMessage, 
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}