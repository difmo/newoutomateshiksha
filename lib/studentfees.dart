

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/feemodal.dart';
import 'Resource/Colors/app_colors.dart';

class studentfees extends StatefulWidget {
  const studentfees({Key? key}) : super(key: key);

  @override
  State<studentfees> createState() => _studentfeesState();
}

class _studentfeesState extends State<studentfees> {

  bool hasbeenpressed1=true;
  bool hasbeenpressed2=false;
  bool hasbeenpressed3=false;

  List regularItemlist=[];
  List additionalItemlist=[] ;
  List admissionItemlist=[];


  late Future<List<feemodal>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }


  Future<List<feemodal>> fetchPost() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stucode =prefs.getString('clientid')!;
    String? brid =prefs.getString('BranchID')!;
    String? fsecid =prefs.getString('F_SessionId')!;

    final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/stu_Fee/stucode/'+stucode+'/brid/'+brid+'/fsecid/'+fsecid));

    if (response.statusCode == 200) {
      regularItemlist.clear();
      additionalItemlist.clear();
      admissionItemlist.clear();

      var parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      // print('dddddddddddddddddddd${parsed[0]}');
      //mondayItemlist=parsed[0];

      for(int i=0;i<parsed.length;i++){
        if(parsed[i]['Feermk']=='Regular Fees'){
          regularItemlist.add(parsed[i]);
          // print('ddddssssssssss$mondayItemlist');
        }
        if(parsed[i]['Feermk']=='Additional Fees'){
          additionalItemlist.add(parsed[i]);
          //print('ddddssssssssss$tuesdayItemlist');
        }
        if(parsed[i]['Feermk']=='Admission Fees'){
          admissionItemlist.add(parsed[i]);
          // print('ddddssssssssss$wednesdayItemlist');
        }

      }

     // print('ddddssssssssss${mondayItemlist[1]['MobNo']}');


      return parsed.map<feemodal>((json) => feemodal.fromMap(json)).toList();


    } else {
      throw Exception('Failed to load fee');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fees",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: SingleChildScrollView(
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
                    child: Text("Student Fee",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.backColor,),textAlign: TextAlign.left,),
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
                            child: Text("Regular Fees",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed1 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=true;
                              hasbeenpressed2=false;
                              hasbeenpressed3=false;

                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed2 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Additional Fees",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed2 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=true;
                              hasbeenpressed3=false;

                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,10,10,10),
                            color: hasbeenpressed3 ? appcolors.primaryColor : Colors.transparent ,
                            child: Text("Admission Fees",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: hasbeenpressed3 ? appcolors.whiteColor : appcolors.backColor),),
                          ),
                          onTap: (){
                            setState(() {
                              hasbeenpressed1=false;
                              hasbeenpressed2=false;
                              hasbeenpressed3=true;
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
                          int? type=0;

                          type=hasbeenpressed1 ? regularItemlist.length : hasbeenpressed2 ? additionalItemlist.length : hasbeenpressed3 ? admissionItemlist.length : 0;

                          return ListView.builder(
                              itemCount:type,
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
      ),
    );
  }
  Widget getRow(int index,var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(10,0,10,1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 1,
      child: Container(
        height: 100,
        child: ListTile(
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0,5,0,2),
                  alignment: Alignment.centerLeft,
                  child: Container(padding: EdgeInsets.fromLTRB(6,5,6,2),color: Colors.black12,child: Text("Receipt No - XXXX${hasbeenpressed1 ? regularItemlist[index]['FeeGenID'] : hasbeenpressed2 ? additionalItemlist[index]['FeeGenID'] : admissionItemlist[index]['FeeGenID']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 8),)),
                ),
                SizedBox(height: 5,),
                Container(alignment: Alignment.centerLeft,child: Text("FeeMonth - ${hasbeenpressed1 ? regularItemlist[index]['Fee_elementName'] : hasbeenpressed2 ? additionalItemlist[index]['Fee_elementName'] : admissionItemlist[index]['Fee_elementName'] }",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: appcolors.primaryColor,),overflow: TextOverflow.ellipsis,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DueAmount : ${hasbeenpressed1 ? regularItemlist[index]['DueAmt'] : hasbeenpressed2 ? additionalItemlist[index]['DueAmt'] : admissionItemlist[index]['DueAmt'] }",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: appcolors.backColor,),overflow: TextOverflow.ellipsis,),
                  //  Expanded(child: Text("ConcessionAmount-${hasbeenpressed1 ? regularItemlist[index]['Concessamt'] : hasbeenpressed2 ? additionalItemlist[index]['Concessamt'] : admissionItemlist[index]['Concessamt'] }",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w900,color: appcolors.primaryColor,),overflow: TextOverflow.ellipsis,)),
                    Text("FeeAmount : ${hasbeenpressed1 ? regularItemlist[index]['Feeamt'] : hasbeenpressed2 ? additionalItemlist[index]['Feeamt'] : admissionItemlist[index]['Feeamt'] }",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: appcolors.backColor,),overflow: TextOverflow.ellipsis,),
                  ],
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Due Date - ${hasbeenpressed1 ? regularItemlist[index]['feeduedt'] : hasbeenpressed2 ? additionalItemlist[index]['feeduedt'] : admissionItemlist[index]['feeduedt'] }",style: const TextStyle(fontSize: 8,color: appcolors.primaryColor),overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
