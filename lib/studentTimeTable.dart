

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/timetablemodal.dart';
import 'Resource/Colors/app_colors.dart';





class studentTimeTable extends StatefulWidget {
  const studentTimeTable({Key? key}) : super(key: key);

  @override
  State<studentTimeTable> createState() => _studentTimeTableState();
}

class _studentTimeTableState extends State<studentTimeTable> {

  bool hasbeenpressed1=true;
  bool hasbeenpressed2=false;
  bool hasbeenpressed3=false;
  bool hasbeenpressed4=false;
  bool hasbeenpressed5=false;
  bool hasbeenpressed6=false;

  List mondayItemlist=[];
  List tuesdayItemlist=[] ;
  List wednesdayItemlist=[];
  List thusdayItemlist=[];
  List fridayItemlist =[];
  List saturedayItemlist=[] ;


  late Future<List<timetablemodal>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }


  Future<List<timetablemodal>> fetchPost() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentid =prefs.getString('studentid')!;
    String? BranchID =prefs.getString('BranchID')!;

    print("ggggggggggg${studentid}");

    final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/stu_tt/stuid/'+studentid+'/brid/'+BranchID));

    if (response.statusCode == 200) {
      mondayItemlist.clear();
      tuesdayItemlist.clear();
      wednesdayItemlist.clear();
      thusdayItemlist.clear();
      fridayItemlist .clear();
      saturedayItemlist.clear();

      var parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      print("dddddddddd$parsed");
      // print('dddddddddddddddddddd${parsed[0]}');
      //mondayItemlist=parsed[0];

      for(int i=0;i<parsed.length;i++){
        if(parsed[i]['DayID']=='1'){
          mondayItemlist.add(parsed[i]);
          // print('ddddssssssssss$mondayItemlist');
        }
        if(parsed[i]['DayID']=='2'){
          tuesdayItemlist.add(parsed[i]);
          //print('ddddssssssssss$tuesdayItemlist');
        }
        if(parsed[i]['DayID']=='3'){
          wednesdayItemlist.add(parsed[i]);
          // print('ddddssssssssss$wednesdayItemlist');
        }
        if(parsed[i]['DayID']=='4'){
          thusdayItemlist.add(parsed[i]);
          // print('ddddssssssssss$thusdayItemlist');
        }
        if(parsed[i]['DayID']=='5'){
          fridayItemlist.add(parsed[i]);
          // print('ddddssssssssss$fridayItemlist');
        }
        if(parsed[i]['DayID']=='6'){
          saturedayItemlist.add(parsed[i]);
          // print('ddddssssssssss$saturedayItemlist');
        }
      }

    //  print('ddddssssssssss${mondayItemlist[1]['MobNo']}');


      return parsed.map<timetablemodal>((json) => timetablemodal.fromMap(json)).toList();


    } else {
      throw Exception('Failed to load notice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Table",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          color: appcolors.primaryColor,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0),),
            child: Container(
              color: appcolors.whiteColor,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(30,30,10,10),
                    child: Text("Class Time Table",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.backColor,),textAlign: TextAlign.left,),
                  ),
                  Container(
                    color: Colors.black12,
                    margin: EdgeInsets.fromLTRB(0,10,0,10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed1 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Mon",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed1 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=true;
                              hasbeenpressed2=false;
                              hasbeenpressed3=false;
                              hasbeenpressed4=false;
                              hasbeenpressed5=false;
                              hasbeenpressed6=false;

                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed2 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Tue",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed2 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=true;
                              hasbeenpressed3=false;
                              hasbeenpressed4=false;
                              hasbeenpressed5=false;
                              hasbeenpressed6=false;

                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed3 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Wed",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed3 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=false;
                              hasbeenpressed3=true;
                              hasbeenpressed4=false;
                              hasbeenpressed5=false;
                              hasbeenpressed6=false;
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed4 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Thus",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed4 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=false;
                              hasbeenpressed3=false;
                              hasbeenpressed4=true;
                              hasbeenpressed5=false;
                              hasbeenpressed6=false;
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed5 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Fri",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed5 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=false;
                              hasbeenpressed3=false;
                              hasbeenpressed4=false;
                              hasbeenpressed5=true;
                              hasbeenpressed6=false;
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed6 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Sat",style:TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed6 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=false;
                              hasbeenpressed3=false;
                              hasbeenpressed4=false;
                              hasbeenpressed5=false;
                              hasbeenpressed6=true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 500,
                      child:   FutureBuilder(
                        future: fetchPost(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            int? day=0;

                            day=hasbeenpressed1 ? mondayItemlist.length : hasbeenpressed2 ? tuesdayItemlist.length : hasbeenpressed3 ? wednesdayItemlist.length : hasbeenpressed4 ? thusdayItemlist.length : hasbeenpressed5 ? fridayItemlist.length : hasbeenpressed6 ? saturedayItemlist.length : 0;

                            return ListView.builder(
                                itemCount:day,
                                itemBuilder: (BuildContext context, int index ) {
                                  return getRow(index,snapshot);
                                }
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }

                        },

                      ),),
                 ],
              ),
            ),
          ),
        ),
      )
    );
  }
  Widget getRow(int index,var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(14,0,14,1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 1,
      child: Container(
        height: 80,
        child: ListTile(
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0,5,0,2),
                  alignment: Alignment.centerLeft,
                  child: Container(padding: EdgeInsets.fromLTRB(6,2,6,2),color: Colors.black12,child: Text("Lecture - ${hasbeenpressed1 ? mondayItemlist[index]['PeriodName'] : hasbeenpressed2 ? tuesdayItemlist[index]['PeriodName'] : hasbeenpressed3 ? wednesdayItemlist[index]['PeriodName'] : hasbeenpressed4 ? thusdayItemlist[index]['PeriodName'] : hasbeenpressed5 ? fridayItemlist[index]['PeriodName'] : saturedayItemlist[index]['PeriodName'] }",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 8),)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text("${hasbeenpressed1 ? mondayItemlist[index]['SubjectName'] : hasbeenpressed2 ? tuesdayItemlist[index]['SubjectName'] : hasbeenpressed3 ? wednesdayItemlist[index]['SubjectName'] : hasbeenpressed4 ? thusdayItemlist[index]['SubjectName'] : hasbeenpressed5 ? fridayItemlist[index]['SubjectName'] : saturedayItemlist[index]['SubjectName']  }",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: appcolors.primaryColor,),overflow: TextOverflow.ellipsis,)),
                    Container(
                      height: 30,
                      padding: EdgeInsets.fromLTRB(6,2,6,2),
                      color: appcolors.primaryColor,
                       child: Row(
                         children: [
                           Icon(Icons.access_time,color: appcolors.whiteColor,),
                           Text("  ${hasbeenpressed1 ? mondayItemlist[index]['PeriodTime'] : hasbeenpressed2 ? tuesdayItemlist[index]['PeriodTime'] : hasbeenpressed3 ? wednesdayItemlist[index]['PeriodTime'] : hasbeenpressed4 ? thusdayItemlist[index]['PeriodTime'] : hasbeenpressed5 ? fridayItemlist[index]['PeriodTime'] : saturedayItemlist[index]['PeriodTime']   }",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.whiteColor)),
                         ],
                       )),
                      ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${hasbeenpressed1 ? mondayItemlist[index]['TechName'] : hasbeenpressed2 ? tuesdayItemlist[index]['TechName'] : hasbeenpressed3 ? wednesdayItemlist[index]['TechName'] : hasbeenpressed4 ? thusdayItemlist[index]['TechName'] : hasbeenpressed5 ? fridayItemlist[index]['TechName'] : saturedayItemlist[index]['TechName']     }",style: const TextStyle(fontSize: 10,color: appcolors.primaryColor),overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
