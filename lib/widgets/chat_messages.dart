import 'package:chat_app/services/notifications_services.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessages extends StatefulWidget{
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() {
    return _ChatMessagesState();
  }
}

class _ChatMessagesState extends State<ChatMessages>{
  Timestamp? lastNotified;

  @override
  void initState() {
    super.initState();

    NotificationsServices.showNotifications(
      title: 'Test Notification',
      body: 'This is a local notification test',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser=FirebaseAuth.instance.currentUser!;

    return StreamBuilder(    //listens to a stream of messages so that whenever a new message is uploaded it is automatically loaded and displayed here 
      stream: FirebaseFirestore.instance.collection('chat')  //whenever a new document or chat is uploaded in the 'chat' collection in firestore it will notify firebase so we can update the ui from our builder function 
      .orderBy('createdAt',descending: true)  //our listview below was set from bottom-up so our messages would be not in order if ascending then most recent ones goes above we want them below so setting changed here.
      .snapshots(),

      builder: (context, chatSnapshots) {
        if(chatSnapshots.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if(!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){    //.docs = list of data from the snapshot=map<..>
        //   return Center(
        //     child: Text('No messages found'),
        //   );
        // } 

        if(chatSnapshots.hasError){
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final docs = chatSnapshots.data?.docs ?? [];  //the loaded messages basically retrieves the data in the list/map format using the snapshots so docs' data retrieved

         if (docs.isEmpty) {
          return const Center(child: Text('No messages found'));
        }

        final loadedMessages = docs;
         
        
        final newest = loadedMessages.first.data() as Map<String, dynamic>;
        final newUserId = newest['userId'] ?? '';
        final newestTimestamp = newest['createdAt'] as Timestamp?;
        final title = newest['username'] ?? 'Unknown';
        final body = newest['text'] ?? '';

        if (newUserId.isNotEmpty &&
            newUserId != authenticatedUser.uid &&
            newestTimestamp != null &&
            (lastNotified == null || newestTimestamp.toDate().isAfter(lastNotified!.toDate()))) {
            
            NotificationsServices.showNotifications(title: title, body: body);
            lastNotified = newestTimestamp;
      
      }

  
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,    //goes bottom-up
          itemCount: loadedMessages.length,
          itemBuilder: (context,index){   //to return scrollable list of chats/data
            final chatMessage=loadedMessages[index].data();    //read the loadedMessages, from there through partcular index we access particulr field of that specific data that is text   
            final nextChatMessage=index+1 < loadedMessages.length  //if next chat message is there means will obviously smaller than the current length so we will load that data 
              ? loadedMessages[index+1].data() 
              : null;
            
            final currentMessageUsernameId=chatMessage['userId'];
            final nextMessageUsernameId=nextChatMessage!=null ? nextChatMessage['userId'] : null;
            final nextUserIsSame=currentMessageUsernameId==nextMessageUsernameId;

            if(nextUserIsSame){
              return MessageBubble.next(
                message: chatMessage['text'], 
                isMe: authenticatedUser.uid==currentMessageUsernameId,
              );
            }
            else{
              return MessageBubble.first(
                userImage: chatMessage['userImage'], 
                username: chatMessage['username'], 
                message: chatMessage['text'], 
                isMe: authenticatedUser.uid==currentMessageUsernameId,
              );
            }
        });      
      }, 
    );

    
  }
}