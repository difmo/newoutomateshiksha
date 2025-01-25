import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:in_app_update/in_app_update.dart';
import 'Resource/Colors/app_colors.dart';
// import 'package:newoutomateshiksha/Utilles/appbar.dart';
// import 'package:newoutomateshiksha/Utilles/boldtext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilles/buttons.dart';
import 'Utilles/spac.dart';
import 'Utilles/textfields.dart';
import 'Utilles/toasts.dart';
import 'checkconnection.dart';
import 'forgetpassword.dart';
import 'homescreen.dart';

checklogin(String appID, String studentID, String password,
    BuildContext context) async {
  var uri =
      ("https://shikshaappservice.kalln.com/api/Home/GetLoginApp/logid/$appID/passid/$studentID/brid/$password");
  try {
    var response = await get(Uri.parse(uri));
    var dataa = jsonDecode(response.body);
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print(dataa);
      if (response.body.contains('Correct')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('appID', appID ?? '');
        prefs.setString('stuID', studentID ?? '');

        prefs.setString('BranchID', dataa[0]["branchID"] ?? '');
        prefs.setString('BranchLogo', dataa[0]["branchLogo"] ?? '');
        prefs.setString('BranchName', dataa[0]["branchName"] ?? '');
        prefs.setString('ClassID', dataa[0]["classID"] ?? '');
        prefs.setString('ClassNm', dataa[0]["classNm"] ?? '');
        prefs.setString('Cur_Sessionyr', dataa[0]["cur_Sessionyr"] ?? '');
        prefs.setString('F_SessionId', dataa[0]["f_SessionId"] ?? '');
        prefs.setString('MotherMobileNo', dataa[0]["motherMobileNo"] ?? '');
        prefs.setString('FatherMobileNo', dataa[0]["fatherMobileNo"] ?? '');
        prefs.setString('ParentId', dataa[0]["parentId"] ?? '');
        prefs.setString('Rollno', dataa[0]["rollno"] ?? '');
        prefs.setString('clientid', dataa[0]["clientid"] ?? '');
        prefs.setString('clsstrucidFK', dataa[0]["clsstrucidFK"] ?? '');
        prefs.setString('dob', dataa[0]["dob"] ?? '');
        prefs.setString('fathername', dataa[0]["fathername"] ?? '');
        prefs.setString('mothername', dataa[0]["mothername"] ?? '');
        prefs.setString('secname', dataa[0]["secname"] ?? '');
        prefs.setString('studentid', dataa[0]["studentid"] ?? '');
        prefs.setString('studentname', dataa[0]["studentname"] ?? '');

        toasts().toastsShortone("Login Successfull");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => homescreen()),
            (Route<dynamic> route) => false);
      } else {
        toasts().toastsShortone(dataa[0]["errormessage:"] ?? "Login Failed");
        Navigator.of(context).pop();
      }
    } else {
      toasts().toastsShortone("Server Error");
      Navigator.of(context).pop();
    }
  } catch (e) {
// Catch network or parsing errors
    toasts().toastsShortone("Error: $e");
    Navigator.of(context).pop();
    print("Error: $e");
  }
}

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  String appID = "";
  String stuID = "";
  String T = "";
  bool rotate = false;
  bool isoffline = false;
  bool valuefirst = true;
  bool _isObscure = true;
  bool ActiveConnection = false;
  StreamSubscription? internetconnection;

  TextEditingController appIDCtrl = TextEditingController(text: '');
  TextEditingController studentIDCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    getpreferenceData();
    CheckUserConnection();
    _checkVersion();

    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
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
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/loginbg.jpg"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Card(
                margin: EdgeInsets.fromLTRB(30, 180, 30, 100),
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/Icons/loginlogo.png',
                      width: 120,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: edittextsone(
                        label: 'App Id',
                        hint: 'Enter App Id',
                        maxlength: 10,
                        controllers: appIDCtrl,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: edittextsone(
                        label: 'Student Id',
                        hint: 'Enter Student Id',
                        maxlength: 10,
                        controllers: studentIDCtrl,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: TextField(
                        maxLength: 10,
                        controller: passwordCtrl,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          counterText: "",
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          hintText: 'Enter Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Checkbox(
                                  activeColor: appcolors.primaryColor,
                                  value: valuefirst,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      setState(() {
                                        valuefirst = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Remember Me',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appcolors.primaryColor,
                                        fontSize: 12),
                                  )),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Text('Forget Password ?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appcolors.primaryColor,
                                        fontSize: 12)),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => forgetpassword()));
                                },
                              )),
                        ],
                      ),
                    ),
                    space(
                      height: 20,
                    ),
                    InkWell(
                      child: buttons(
                        title: 'Login',
                        onPress: () {},
                        width: 200,
                      ),
                      onTap: () {
                        setState(() {
                          if (appIDCtrl.text.isEmpty ||
                              studentIDCtrl.text.isEmpty ||
                              passwordCtrl.text.isEmpty) {
                            toasts().toastsShortone(
                                "Please Fill the Proper Details");
                          } else {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                            checklogin(
                                appIDCtrl.text.toString(),
                                studentIDCtrl.text.toString(),
                                passwordCtrl.text.toString(),
                                context);
                          }
                        });
                      },
                    ),
                    space(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'By clicking this button,you agree with \n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: 'our  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: appcolors.primaryColor))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    space(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  // getpreferenceData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   appID = prefs.getString('appID') ?? ''; // Default to empty string if null
  //   stuID = prefs.getString('stuID') ?? ''; // Default to empty string if null
  //
  //   // Check if appID and stuID are non-empty before setting them
  //   if (appID.isNotEmpty && stuID.isNotEmpty) {
  //     setState(() {
  //       s0.text = appID;
  //       s1.text = stuID;
  //     });
  //   } else {
  //     // Handle case where preferences are not available or need to be set.
  //     print("No saved preferences for appID or stuID.");
  //   }
  // }

  getpreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appID = prefs.getString('appID')!;
    stuID = prefs.getString('stuID')!;
    setState(() {
      appIDCtrl.text = appID.toString();
      studentIDCtrl.text = stuID.toString();
    });
  }
}
