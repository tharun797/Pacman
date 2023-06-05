import 'package:flutter/material.dart';

class Pathway extends StatelessWidget {
  Pathway(
      {super.key,
      required this.index,
      this.innerColour,
      this.outerColor,});

  int index;
  Color? outerColor;
  Color? innerColour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: innerColour,
              
            ),
          ),
        ),
      ),
    );
  }
}
