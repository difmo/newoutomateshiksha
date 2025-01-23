


import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/classworkmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/calender.dart';
import 'Utilles/toasts.dart';
import 'classworkopenitem.dart';


Future<List<classworkmodal>> homeworkmodalfunction(String adate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? Classid =prefs.getString('clsstrucidFK')!;
  String? brid =prefs.getString('BranchID')!;
  final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/stu_classwork/Classid/'+Classid+'/brid/'+brid+'/cwdate/$adate'));
  print("ggggg$Classid");
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<classworkmodal>((json) => classworkmodal.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load notice');
  }
}

class studentclasswork extends StatefulWidget {
  const studentclasswork({Key? key}) : super(key: key);

  @override
  State<studentclasswork> createState() => _studentclassworkState();
}

class _studentclassworkState extends State<studentclasswork> {

  DateTime selectedDate = DateTime.now();
  String fdate=DateFormat('EEEE-dd MMMM yyyy').format(DateTime.now());
  String adate=DateFormat('yyyy-MM-dd').format(DateTime.now());
  late Future<List<classworkmodal>> classworkmodalfunction;
  String yturl="https://www.howtogeek.com/wp-content/uploads/2019/10/youtube-logo.jpg?height=200p&trim=2,2,2,2";
  String docurl="https://png.pngtree.com/png-vector/20190413/ourlarge/pngtree-vector-doc-icon-png-image_944072.jpg";
  String pdfurl="https://images.news18.com/ibnlive/uploads/2020/08/1596522361_pdf.jpg";
  String imgurl="https://img.freepik.com/premium-vector/gallery-icon-picture-landscape-vector-sign-symbol_660702-224.jpg";
  @override
  void initState() {
    super.initState();
    classworkmodalfunction = homeworkmodalfunction(adate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    setState(() {
      DateFormat formatter1 = DateFormat('EEEE-dd MMMM yyyy');
      DateFormat formatter2 = DateFormat('yyyy-MM-dd');
      fdate = formatter1.format(selectedDate);
      adate = formatter2.format(selectedDate);
      classworkmodalfunction = homeworkmodalfunction(adate);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classwork",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor)),
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
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15,30,10,10),
                  child: Text("Today Class Work",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10,10,10,10),
                  color: CupertinoColors.systemGrey4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15,10,10,10),
                        color: CupertinoColors.systemGrey4,
                        child: Text("$fdate",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10,10,10,10),
                          color: appcolors.primaryColor,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,color: appcolors.whiteColor,),
                              Text("Select Date",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color:appcolors.whiteColor)),
                            ],
                          ),
                        ),
                        onTap: (){
                          setState(() {
                              selectDate(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 450,
                  padding: EdgeInsets.fromLTRB(1,10,1,10),
                  child:  FutureBuilder<List<classworkmodal>>(
                    future: classworkmodalfunction,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget getRow(int index,var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(5,0,5,1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 2,
      child: Container(
        height: 80,
        child: ListTile(
          onTap: () {
              if(snapshot.data![index].SubjectName==null){
                toasts().toastsShortone("No Records Found");
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => classworkopenitem(openrequest:snapshot.data![index])));
              }
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: appcolors.primaryColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: snapshot.data![index].ContName=='Image' ? NetworkImage(imgurl) : snapshot.data![index].ContName=='File' ? NetworkImage(pdfurl) : snapshot.data![index].ContName=='Video Link' ? NetworkImage(yturl) : NetworkImage(docurl),
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
                      Container(height: 30,width: 200,child: Text("${snapshot.data![index].SubjectName}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),overflow: TextOverflow.ellipsis,)),
                      Text("${snapshot.data![index].TopicName}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: CupertinoColors.systemGrey2),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
