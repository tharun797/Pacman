import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({super.key, 
    required this. score,
    required this.onPressed
  });

  int score;
  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Center(child: Text('G A M E  O V E R')),
      actions: [
        Text('SCORE: $score'),
        TextButton(onPressed: onPressed, child: const Text('PLAY AGAIN'))
      ],
    );
  }
}