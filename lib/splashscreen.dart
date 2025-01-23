import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:newoutomateshiksha/Utilles/spac.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Resource/Colors/app_colors.dart';
import 'Utilles/buttons.dart';
import 'Utilles/textfields.dart';
import 'Utilles/texts.dart';
import 'homescreen.dart';
import 'loginpage.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),() async {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginpage()));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolors.primaryColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/splash.jpg"), fit: BoxFit.cover),),
        child: Container(
          child: Column(
            children: [
              Container(
                child: Card(
                  margin: EdgeInsets.fromLTRB(30, 80, 30, 50),
                  color: Colors.transparent,
                  shadowColor: appcolors.whiteColor,
                  elevation: 0,
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child:  Image.asset('assets/Icons/loginlogo.png',width: 120,height: 120,) ,
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/Gif/splashgif.gif", ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
