import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String content;
  final bool isUserMessage;
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String name = 'Anonymous';
  void initState() {
    getName();
  }

  Future<void> getName() async {
    await HelperFunction.getUserName().then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        name = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: widget.isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.isUserMessage
                  ? themeData.colorScheme.primary.withOpacity(0.4)
                  : Colors.blueGrey[700]?.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: widget.isUserMessage
                        ? Alignment.topLeft
                        : Alignment.topLeft,
                    child: Text(
                      widget.isUserMessage ? '$name' : 'Immunie',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: widget.isUserMessage
                        ? Alignment.topLeft
                        : Alignment.topLeft,
                    child: Text(widget.content),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
