
import 'package:flutter/material.dart';



class commonTextone extends StatelessWidget {
  const commonTextone({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text(title, style:TextStyle(fontSize: 14,color: Color(0xff12263b)),)
    );
  }
}








