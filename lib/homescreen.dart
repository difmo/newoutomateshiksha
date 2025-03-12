import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

// import 'package:launch_review/launch_review.dart';
import 'package:newoutomateshiksha_newmaster/profile.dart';
import 'Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilles/boldtext.dart';
import 'Utilles/drawer.dart';
import 'Utilles/moduleview.dart';
import 'Utilles/spac.dart';
import 'checkconnection.dart';
import 'loginpage.dart';
import 'studentChats.dart';
import 'studentTimeTable.dart';
import 'studentattendance.dart';
import 'studentcirculer.dart';
import 'studentclasswork.dart';
import 'studentfees.dart';
import 'studenthomework.dart';
import 'studentnotices.dart';
import 'studentresults.dart';

class homescreen extends StatefulWidget implements PreferredSizeWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
   
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _homescreenState extends State<homescreen> {
  bool hasBeenPressed1 = false;
  bool hasBeenPressed2 = false;
  bool hasBeenPressed3 = false;
  bool hasBeenPressed4 = false;
  bool hasBeenPressed5 = false;
  bool hasBeenPressed6 = false;
  bool hasBeenPressed7 = false;
  bool hasBeenPressed8 = false;
  bool hasBeenPressed9 = false;

  String studentname = "";
  String ClassNm = "";
  String secname = "";
  String studentid = "";
  String BranchName = "";
  String BranchLogo = "";

  String T = "";
  bool rotate = false;
  bool isoffline = false;
  bool valuefirst = true;
  final bool _isObscure = true;
  bool ActiveConnection = false;
  StreamSubscription? internetconnection;

  // @override
  @override
  void initState() {
    super.initState();
    getAllCategory();
    CheckUserConnection();
    _checkVersion();

    // Update listener for connectivity changes
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Check the connectivity status by accessing the first item in the list
      ConnectivityResult result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;

      if (result == ConnectivityResult.none) {
        // No internet connection
        setState(() {
          isoffline = true;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => checkinternet()));
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // Internet is available (either mobile data or wifi)
        setState(() {
          isoffline = false;
        });
      }
    });
  }

  Future getAllCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentname = prefs.getString('studentname')!;
      ClassNm = prefs.getString('ClassNm')!;
      secname = prefs.getString('secname')!;
      studentid = prefs.getString('studentid')!;
      BranchName = prefs.getString('BranchName')!;
      BranchLogo = prefs.getString('BranchLogo')!;
    });
  }

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          print(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        setState(() {
          isoffline = true;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => checkinternet()));
        });
      });
    }
  }

  void _checkVersion() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    internetconnection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shiksha ERP",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: InkWell(
                  child: Text("Profile"),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => profile()));
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: InkWell(
                  child: Text("RateUs"),
                  onTap: () {
                    // LaunchReview.launch(
                    //   androidAppId: "saptrishi.infosystem.newoutomateshiksha",
                    //   iOSAppId: "585027354",
                    // );
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: InkWell(
                  child: Text("Logout"),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => loginpage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => studentprofile()));
            } else if (value == 1) {
              print("Settings menu is selected.");
            } else if (value == 2) {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.setInt('userType', 9);
              //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginpage()));
            }
          }),
        ],
      ),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin:
                  EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Icons/dashboardbgorg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  space(),
                  Container(
                    child: Center(
                      child: ClipRect(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                                child: Image.network(
                              BranchLogo,
                              height: 80,
                              width: 80,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  space(),
                  Container(
                    child: boldtext(
                      title: BranchName,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 10,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: appcolors.primaryColor,
                              child: InkWell(
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundColor: appcolors.whiteColor,
                                  backgroundImage: NetworkImage(
                                      'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    child: Text(
                                      "Name : $studentname",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: appcolors.primaryColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      "CLASS : ${"$ClassNm $secname"}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: appcolors.primaryColor),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      "STUDENT ID : $studentid",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: appcolors.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => profile()));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "EXPLORE THE MODULES",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: appcolors.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 420,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: GridView(
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 110,
                        ),
                        children: [
                          InkWell(
                            child: moduleview(
                              title: 'Attendance',
                              path: 'assets/Icons/attendance.png',
                              hasBeenPressed: hasBeenPressed2,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = true;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => studentattendance()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Circuler',
                              path: 'assets/Icons/circuler.png',
                              hasBeenPressed: hasBeenPressed4,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = true;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentCircular()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Time Table',
                              path: 'assets/Icons/time-table.png',
                              hasBeenPressed: hasBeenPressed8,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = true;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentTimeTable()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Classwork',
                              path: 'assets/Icons/classwork.png',
                              hasBeenPressed: hasBeenPressed6,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = true;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentClasswork()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Homework',
                              path: 'assets/Icons/lecturenotes.png',
                              hasBeenPressed: hasBeenPressed7,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = true;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => studenthomework()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Fees',
                              path: 'assets/Icons/fees.png',
                              hasBeenPressed: hasBeenPressed5,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = true;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => studentfees()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Results',
                              path: 'assets/Icons/results.png',
                              hasBeenPressed: hasBeenPressed1,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = true;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => studentresults()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Notices',
                              path: 'assets/Icons/notice.png',
                              hasBeenPressed: hasBeenPressed3,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = true;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = false;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentNotices()));
                              });
                            },
                          ),
                          InkWell(
                            child: moduleview(
                              title: 'Chats',
                              path: 'assets/Icons/chat.png',
                              hasBeenPressed: hasBeenPressed9,
                            ),
                            onTap: () {
                              setState(() {
                                hasBeenPressed1 = false;
                                hasBeenPressed2 = false;
                                hasBeenPressed3 = false;
                                hasBeenPressed4 = false;
                                hasBeenPressed5 = false;
                                hasBeenPressed6 = false;
                                hasBeenPressed7 = false;
                                hasBeenPressed8 = false;
                                hasBeenPressed9 = true;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentChats()));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
