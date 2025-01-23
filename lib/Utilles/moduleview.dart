

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Resource/Colors/app_colors.dart';

class moduleview  extends StatelessWidget {
  const moduleview ({Key? key,
    required this.title,
    required this.path,
    this.hasBeenPressed = false,
  }) : super(key: key);
  

  final String path;
  final String title;
  final bool hasBeenPressed;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
       // margin: EdgeInsets.fromLTRB(10,5,10,10),
        color: hasBeenPressed ? appcolors.primaryColor : appcolors.whiteColor,
        shadowColor: Colors.black,
        elevation: 5,
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(path,height: 40,width: 40,color: hasBeenPressed ? appcolors.whiteColor : appcolors.primaryColor,),
              SizedBox(height: 5),
              Text(title, style: TextStyle(fontSize: 12, color: hasBeenPressed ? appcolors.whiteColor : appcolors.primaryColor,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
