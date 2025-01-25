import 'package:flutter/material.dart';

class commonTextone extends StatelessWidget {
  const commonTextone({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      title,
      style: TextStyle(fontSize: 14, color: Color(0xff12263b)),
    ));
  }
}
