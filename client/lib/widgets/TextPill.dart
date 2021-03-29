import 'package:flutter/material.dart';

class TextPill extends StatelessWidget {
  final String text;
  const TextPill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
    );
  }
}
