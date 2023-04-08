import 'package:child_vaccination/screen/chatbot/chat_message.dart';
import 'package:child_vaccination/screen/chatbot/message_bubble.dart';
import 'package:flutter/material.dart';
import 'chat_api.dart';
import 'chat_prompts.dart';
import 'message_composer.dart';

class ChatPage extends StatefulWidget {
  final ChatApi chatApi;
  const ChatPage({
    required this.chatApi,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messagesSend = <ChatMessage>[
    ChatMessage(prompts.prompt1, true),
    ChatMessage(prompts.prompt2, false),
    ChatMessage(prompts.prompt3, true),
    ChatMessage(prompts.prompt4, false),
  ];
  final _messagesShow = <ChatMessage>[
    ChatMessage(prompts.prompt4, false),
  ];
  var _awaitingResponse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Talk with Immunie",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: [
                  ..._messagesShow.map(
                    (msg) => MessageBubble(
                      content: msg.content,
                      isUserMessage: msg.isUserMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MessageComposer(
            onSubmitted: _onSubmitted,
            awaitingResponse: _awaitingResponse,
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmitted(String message) async {
    setState(() {
      _messagesSend.add(ChatMessage(message, true));
      _messagesShow.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });
    final response = await widget.chatApi.completeChat(_messagesSend);
    setState(() {
      _messagesSend.add(ChatMessage(response, false));
      _messagesShow.add(ChatMessage(response, false));
      _awaitingResponse = false;
    });
  }
}
