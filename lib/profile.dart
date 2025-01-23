

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  String studentname = "";
  String ClassNm = "";
  String secname = "";
  String studentid ="";
  String dob = "";
  String fathername = "";
  String mothername = "";
  String FatherMobileNo = "";
  String MotherMobileNo = "";
  String Cur_Sessionyr = "";

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
      dob = prefs.getString('dob')!;
      fathername = prefs.getString('fathername')!;
      mothername = prefs.getString('mothername')!;
      FatherMobileNo = prefs.getString('FatherMobileNo')!;
      MotherMobileNo = prefs.getString('MotherMobileNo')!;
      Cur_Sessionyr = prefs.getString('Cur_Sessionyr')!;

      if(FatherMobileNo==""){
        FatherMobileNo="XXXXXXXXXX";
      }
      if(MotherMobileNo==""){
        MotherMobileNo="XXXXXXXXXX";
      }

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
          backgroundColor: appcolors.primaryColor,
          iconTheme: IconThemeData(color: appcolors.whiteColor),
        ),
        body:Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30,30,10,10),
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: appcolors.primaryColor,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: appcolors.whiteColor,
                      backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                    ),
                  ),
                ),
                Text("$studentname",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:appcolors.primaryColor),),

                Text("Class : ${ClassNm+"" +secname}  | ${studentid}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color:appcolors.primaryColor),),


                Card(
                margin: EdgeInsets.fromLTRB(20,20,20,20),
                color: Colors.white,
                shadowColor: appcolors.primaryColor,
                elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                  height: 350,
                  child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0),),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10,10,10,10),
                                alignment: Alignment.center,
                                color: appcolors.primaryColor,
                                child: Text("Student Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: appcolors.whiteColor),),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Date Of Birth",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                 Container(child: Text("$dob",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.man,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Gender",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Text("XXXX",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.bloodtype,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Blood Group",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Text("XXXX",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Father Name",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),
                                      ],
                                    ),
                                  ),
                                  Container(child: Expanded(child: Text("$fathername",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor),overflow: TextOverflow.ellipsis,))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Mother Name",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),
                                      ],
                                    ),
                                  ),
                                  Container(child: Expanded(child: Text("$mothername ",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor),overflow: TextOverflow.ellipsis,))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Father No",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Text("$FatherMobileNo",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Mother No",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Text("$MotherMobileNo",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Session Year",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Text("$Cur_Sessionyr",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on,color: appcolors.backColor,),
                                        SizedBox(width: 5,),
                                        Text("Address",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)),

                                      ],
                                    ),
                                  ),
                                  Container(child: Expanded(child: Text("XXXXXXXXXXXX",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.backColor)))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
