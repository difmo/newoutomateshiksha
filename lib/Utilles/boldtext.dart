

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class boldtext extends StatelessWidget {
  const boldtext({Key? key,
    required this.title,
    this.fontSize=24,
    this.colors=Colors.white,
  }) : super(key: key);

  final String title;
  final  colors;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(title, style:TextStyle(fontSize: fontSize,fontWeight:FontWeight.bold,color: colors),)
    );
  }
}
