
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/homeworkmodal.dart';
import 'Utilles/hwitemremarkmodal.dart';
import 'openhwremarkitem.dart';

Future<List<hwitemremarkmodal>> hwitemremarkmodalfunction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stuid =prefs.getString('studentid')!;
  String? branchid =prefs.getString('BranchID')!;
  String? classstruid =prefs.getString('ClassID')!;
  String? subid =prefs.getString('subid')!;
  String? finatimetableid =prefs.getString('FinalDayTTid')!;

  final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/GetstuHWlist_remark/stuid/'+stuid+'/brid/'+branchid+'/class_struid/'+classstruid+'/subid/'+subid+'/finatimetableid/'+finatimetableid));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<hwitemremarkmodal>((json) => hwitemremarkmodal.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load remarks');
  }
}

class homeworkitemremarks extends StatefulWidget {
  const homeworkitemremarks({super.key, required this.openrequest});
  final homeworkmodal openrequest;

  @override
  State<homeworkitemremarks> createState() => _homeworkitemremarksState();
}

class _homeworkitemremarksState extends State<homeworkitemremarks> {

  late Future<List<hwitemremarkmodal>> futurehwitemremarkmodal;

  @override
  void initState() {
    super.initState();
    gethomeworkid();
    futurehwitemremarkmodal = hwitemremarkmodalfunction();
  }

  gethomeworkid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FinalDayTTid', '${widget.openrequest.FinalDayTimeTable_Id_fk}');
    prefs.setString('hwid', '${widget.openrequest.homework_id}');
    prefs.setString('clienteid', '${widget.openrequest.stu_clientid}');
    prefs.setString('ClasiD', '${widget.openrequest.stu_classid}');
    prefs.setString('subid','${widget.openrequest.subjectmst_id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Remarks Homework'),
      ),
      body:  Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0),),
          child: Container(
            color: appcolors.whiteColor,
            child:  Container(
              margin: EdgeInsets.only(top: 30),
              child: FutureBuilder<List<hwitemremarkmodal>>(
                future: futurehwitemremarkmodal,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => getRow(index,snapshot),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      )
    );
  }
  Widget? getRow(int index,var snapshot) {
    if(snapshot.data![index].HWRemark_text!="")
      {
        return  Card(
          margin: EdgeInsets.fromLTRB(5,0,5,1),
          color: Colors.white,
          shadowColor: appcolors.primaryColor,
          elevation: 2,
          child: Container(
            height: 80,
            child: ListTile(
              onTap: () {
                // Navigate to Next Details
                Navigator.push(context, MaterialPageRoute(builder: (context) => openhwremarkitem(openrequest:snapshot.data![index])));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: appcolors.primaryColor,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage('https://cdn1.iconfinder.com/data/icons/human-resources-2-5/128/164-512.png'),
                ),
              ),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 30,width:220,child: Text("${snapshot.data![index].HWRemark_text}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),overflow: TextOverflow.ellipsis,)),
                          Text("${snapshot.data![index].CreatedDate}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: CupertinoColors.systemGrey2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),
        );
      }else{
      return Card();
    }
  }
}
