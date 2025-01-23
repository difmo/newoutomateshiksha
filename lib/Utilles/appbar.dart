

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Resource/Colors/app_colors.dart';


class appbar extends StatelessWidget {
  const appbar({Key? key,
     required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return  AppBar(
        title: Text(title,style:TextStyle(fontWeight: FontWeight.bold,color: appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      );

  }


}












