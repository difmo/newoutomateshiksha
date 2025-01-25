import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:launch_review/launch_review.dart';
import '../Resource/Colors/app_colors.dart';
// import 'package:newoutomateshiksha/Utilles/spac.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginpage.dart';
import '../profile.dart';
import '../rateuspage.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  String studentname = "";
  String ClassNm = "";
  String secname = "";
  String studentid = "";

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  Future getAllCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentname = prefs.getString('studentname')!;
      ClassNm = prefs.getString('ClassNm')!;
      secname = prefs.getString('secname')!;
      studentid = prefs.getString('studentid')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appcolors.primaryColor),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: appcolors.whiteColor,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: appcolors.whiteColor,
                        backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                      ),
                    ),
                  ),
                  Text(
                    studentname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appcolors.whiteColor),
                  ),
                  Text(
                    "Class : ${"$ClassNm$secname"}  | $studentid",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: appcolors.whiteColor),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              InkWell(
                child: ListTile(
                  title: Text('Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                  leading: ImageIcon(
                    AssetImage("assets/Icons/profile.png"),
                    color: appcolors.primaryColor,
                    size: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => profile()));
                },
              ),
              InkWell(
                child: ListTile(
                  title: Text('Rate Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                  leading: ImageIcon(
                    AssetImage("assets/Icons/rateus.png"),
                    color: appcolors.primaryColor,
                    size: 20,
                  ),
                ),
                onTap: () {
                  // LaunchReview.launch(
                  //   androidAppId: "saptrishi.infosystem.newoutomateshiksha",
                  //   iOSAppId: "585027354",
                  // );
                },
              ),
              InkWell(
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  leading: ImageIcon(
                    AssetImage("assets/Icons/logout.png"),
                    color: appcolors.primaryColor,
                    size: 20,
                  ),
                ),
                onTap: () async {
                  /*SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('userType', 9);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginpage()));*/
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => loginpage()),
                      (Route<dynamic> route) => false);
                },
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
          SizedBox(
            height: 70,
          ),
          Container(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text(
              "version: 2.0.2",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xff12263b)),
            ),
          )),
        ],
      ),
    );
  }
}
