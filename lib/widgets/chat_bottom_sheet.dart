import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function(String msg) onPressed;
  final TextEditingController _controller = TextEditingController();

  ChatBottomSheet({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
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
