import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  Pixel({
    super.key,
    this.index,
    this.innerColour,
    this.outerColor,
  });

  int? index;
  Color? innerColour;
  Color? outerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
            padding: const EdgeInsets.all(4),
            color: outerColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: innerColour,
              ),
            )),
      ),
    );
  }
}
