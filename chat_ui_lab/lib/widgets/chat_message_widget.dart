// File: lib/widgets/chat_message_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  // ✨ 1. Define the onSpeak callback parameter
  final VoidCallback? onSpeak;
  final ChatMessage message;

  // ✨ 2. Add 'onSpeak' to the constructor
  const ChatMessageWidget({
    super.key,
    required this.message,
    this.onSpeak, // Allow it to be passed in
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MMM d, h:mm a').format(message.timestamp);
    final isUser = message.isUserMessage;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.grey[700],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (!isUser)
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                    // ✨ 3. Use the 'onSpeak' callback when the button is pressed
                    onPressed: onSpeak,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
