import 'package:flutter/material.dart';
import '../Resource/Colors/app_colors.dart';

class buttons extends StatelessWidget {
  const buttons(
      {super.key,
      this.buttonColor = appcolors.primaryColor,
      this.textColor = appcolors.whiteColor,
      required this.title,
      required this.onPress,
      this.width = 60,
      this.height = 40,
      this.textsize = 20,
      this.borderradious = 10,
      this.loading = false});

  final bool loading;
  final String title;
  final double height, width, borderradious, textsize;
  final VoidCallback onPress;
  final Color textColor, buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderradious),
      ),
      child: Center(
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textsize,
                  color: textColor))),
    );
  }
}
