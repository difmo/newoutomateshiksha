
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/circularmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/toasts.dart';
import 'circuleropen.dart';

Future<List<circularmodal>> circularmodalfunction(String brid,String sessionid,String stuid) async {

  final response = await http.get(Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/GetCircular/brid/'+brid+'/sessionid/'+sessionid+'/stuid/'+stuid));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<circularmodal>((json) => circularmodal.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load notice');
  }
}


class studentcirculer extends StatefulWidget {
  const studentcirculer({Key? key}) : super(key: key);

  @override
  State<studentcirculer> createState() => _studentcirculerState();
}

class _studentcirculerState extends State<studentcirculer> {

  String brid ="";
  String sessionid ="";
  String stuid ="";

  late Future<List<circularmodal>> futurecircularmodal;

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  Future getAllCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

       brid =prefs.getString('BranchID')!;
       sessionid =prefs.getString('F_SessionId')!;
       stuid =prefs.getString('studentid')!;
       futurecircularmodal = circularmodalfunction(brid,sessionid,stuid);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Circuler'),
      ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          color: appcolors.primaryColor,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0),),
            child: Container(
              width: 400,
              color: appcolors.whiteColor,
              child:  Container(
                margin: EdgeInsets.only(top: 30),
                child: FutureBuilder<List<circularmodal>>(
                  future: futurecircularmodal,
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
            if(snapshot.data![index].CircularTitle==null){
              toasts().toastsShortone("No Records Found");
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => circuleropen(openrequest:snapshot.data![index])));
            }
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: appcolors.primaryColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('https://images.idgesg.net/images/article/2019/04/pdf-editor-primary-100794256-large.jpg?auto=webp&quality=85,70'),
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
                      Container(height: 30,width: 200,child: Text("${snapshot.data![index].CircularTitle}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),overflow: TextOverflow.ellipsis,)),
                      Text("${snapshot.data![index].CreateDate}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: CupertinoColors.systemGrey2)),
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

