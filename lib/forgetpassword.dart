

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilles/boldtext.dart';
import 'Utilles/buttons.dart';
import 'Utilles/spac.dart';
import 'Utilles/textfields.dart';
import 'Utilles/toasts.dart';
import 'loginpage.dart';

checklogin(String appid, String stuid, BuildContext context) async {
  String loginid="2333";
  String appId=appid;
  String stuId=stuid;
  var uri=("http://shikshaappservice.outomate.com/ShikshaAppService.svc/LoginApp_Post/logid/"+appId+"/brid/"+stuId);
  var response=await get(Uri.parse(uri));
  var dataa=jsonDecode(response.body);

  if(response.statusCode==200)
  {
    print(dataa);
    if(response.body.contains('Correct')) {

      toasts().toastsShortone("send password your email id and password");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginpage()), (Route<dynamic> route) => false);
    }
    else
    {
      toasts().toastsShortone("Login Failed");
      Navigator.of(context).pop();
    }
  }else{
    toasts().toastsShortone("Server Error");
    Navigator.of(context).pop();
  }
}

class forgetpassword extends StatefulWidget {
  const forgetpassword({Key? key}) : super(key: key);

  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  bool valuefirst = true;
  TextEditingController s1=TextEditingController();
  TextEditingController s2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: appcolors.primaryColor,
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              margin: EdgeInsets.fromLTRB(30, 180, 30, 100),
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 10,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Image.asset('assets/Icons/loginlogo.png',width: 120,height: 120,),
                  Container(
                    child: boldtext(title: 'FORGET PASSWORD',fontSize: 20,colors: appcolors.primaryColor,),
                  ),
                  space(height: 10,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0,10, 0),
                    child: edittextsone( label: 'App Id', hint: 'Enter App Id', maxlength: 10, controllers: s1,),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0,10, 0),
                    child: edittextsone( label: 'Student Id', hint: 'Enter Student Id', maxlength: 10, controllers: s2,),
                  ),
                  space(height: 20,),
                  InkWell(
                    child: buttons(title: 'Send', onPress: () {},width: 200,),
                    onTap: (){
                      setState(() {
                        if(s1.text.isEmpty==true || s2.text.isEmpty==true){
                          toasts().toastsShortone("Please Fill the Proper Details");
                        }else{
                          toasts().toastsShortone("send password your email and phone number");
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginpage()), (Route<dynamic> route) => false);
                          // showDialog<void>(context: context, barrierDismissible: false,builder: (BuildContext context) {return Center(child: CircularProgressIndicator());},);
                          // checklogin(s1.text.toString(),s2.text.toString(),context);
                        }

                      });
                    },
                  ),
                  space(height: 30,)
                ],
              ),
            ),
          ),
        )
    );
  }
}
