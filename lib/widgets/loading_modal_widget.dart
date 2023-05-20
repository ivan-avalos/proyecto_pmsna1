import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(value: null),
          ),
        ),
      ),
    );
  }
}
