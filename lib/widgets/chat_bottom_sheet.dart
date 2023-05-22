import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function(String msg) onPressed;
  final TextEditingController _controller = TextEditingController();

  ChatBottomSheet({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ]),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              alignment: Alignment.centerRight,
              width: 270,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Escribe algo",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                onPressed(_controller.value.text);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
