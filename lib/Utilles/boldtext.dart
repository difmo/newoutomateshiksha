import 'package:flutter/material.dart';

class boldtext extends StatelessWidget {
  const boldtext({
    super.key,
    required this.title,
    this.fontSize = 24,
    this.colors = Colors.white,
  });

  final String title;
  final colors;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      title,
      style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.bold, color: colors),
    ));
  }
}
