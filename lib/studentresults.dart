
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Resource/Colors/app_colors.dart';

class studentresults extends StatefulWidget {
  const studentresults({Key? key}) : super(key: key);

  @override
  State<studentresults> createState() => _studentresultsState();
}

class _studentresultsState extends State<studentresults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body:Container(
           child: Center(child:Text("Your Result will be Coming Soon"),
        ),
      )
    );
  }
}
