import 'package:flutter/material.dart';


class edittextsone extends StatelessWidget {
   edittextsone({Key? key,
    required this.controllers,
    required this.label,
    required this.hint,
    required this.maxlength,
  }) : super(key: key);

  TextEditingController controllers;
  String label;
  String hint;
  int maxlength;

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: TextField(
          maxLength: maxlength,
          controller: controllers,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            counterText: "",
            labelText: label,
            hintText: hint,
          ),
        ),
    );
  }
}




