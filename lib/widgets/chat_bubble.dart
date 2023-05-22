import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

enum ChatBubbleAlignment { start, end }

class ChatBubble extends StatelessWidget {
  final String text;
  final ChatBubbleAlignment alignment;

  const ChatBubble(
    this.text, {
    super.key,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        alignment == ChatBubbleAlignment.start
            ? BubbleLeft(text)
            : BubbleRight(text),
      ],
    );
  }
}

class BubbleLeft extends StatelessWidget {
  final String text;

  const BubbleLeft(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 77),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFE1E1E2),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class BubbleRight extends StatelessWidget {
  final String text;

  const BubbleRight(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 77),
        child: ClipPath(
          clipper: LowerNipMessageClipper(MessageType.send),
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF113753),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
