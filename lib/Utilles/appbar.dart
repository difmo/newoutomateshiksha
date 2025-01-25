import 'package:flutter/material.dart';

import '../Resource/Colors/app_colors.dart';

class appbar extends StatelessWidget {
  const appbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor)),
      backgroundColor: appcolors.primaryColor,
      iconTheme: IconThemeData(color: appcolors.whiteColor),
    );
  }
}
