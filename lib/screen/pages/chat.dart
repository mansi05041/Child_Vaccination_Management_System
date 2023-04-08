import 'package:child_vaccination/screen/chatbot/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:child_vaccination/screen/chatbot/chat_api.dart';

class ChatScreen extends StatelessWidget {
  final ChatApi chatApi = ChatApi();
  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 160, 195, 224),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey, secondary: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: ChatPage(chatApi: chatApi),
    );
  }
}
