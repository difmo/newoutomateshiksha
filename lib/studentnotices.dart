
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/noticemodal.dart';
import 'package:http/http.dart' as http;

import 'Resource/Colors/app_colors.dart';

Future<List<Post>> fetchPost() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid =prefs.getString('studentid')!;
  String? BranchID =prefs.getString('BranchID')!;
  final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/Stu_Sendsms/sms_maxid/0/brid/'+BranchID+'/Stuid/'+studentid));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Post>((json) => Post.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load notice');
  }
}


class studentnotices extends StatefulWidget {
  const studentnotices({Key? key}) : super(key: key);

  @override
  State<studentnotices> createState() => _studentnoticesState();
}

class _studentnoticesState extends State<studentnotices> {

  late Future<List<Post>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0),),
          child: Container(
            color: appcolors.whiteColor,
            child:  Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(20,30,10,10),
                  child: Text("NOTIFICATION",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.backColor,),textAlign: TextAlign.left,),
                ),
                Container(
                  height:  MediaQuery.of(context).size.height/1.3,
                  child: FutureBuilder<List<Post>>(
                    future: futurePost,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => getdata(index,snapshot),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  Widget? getdata(int index,var snapshot){
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: appcolors.whiteColor,
          border: Border.all(
            color: appcolors.primaryColor, //                   <--- border color
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${snapshot.data![index].SmsContent}",style: TextStyle(color: appcolors.backColor,fontSize: 14,),),

                  SizedBox(height: 5),

                  Text("${snapshot.data![index].msgdatetime}",style: TextStyle(color: CupertinoColors.systemGrey3,fontSize: 12,fontWeight: FontWeight.bold),),

                ],
              ),
            ),
            Container(
              child: Image.asset('assets/Icons/notice.png',height: 30,width: 30,color:appcolors.primaryColor,),
            )
          ],
        ),
      ),
    );
  }
}

