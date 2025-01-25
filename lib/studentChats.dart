import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/chatquerylistmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/toasts.dart';
import 'createquerypage.dart';

Future<List<chatquerylistmodal>> chatqueryfunction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid = prefs.getString('studentid')!;
  String? BranchID = prefs.getString('BranchID')!;
  final response = await http.get(Uri.parse(
      'https://shikshaappservice.kalln.com/api/Home/GetChatTopicqryshow/TopicFor/Stu/brid/$BranchID/CreatedbyId/$studentid'));
  print(
      'https://shikshaappservice.kalln.com/api/Home/GetChatTopicqryshow/TopicFor/Stu/brid/$BranchID/CreatedbyId/$studentid');
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    print("sssssssssss${parsed[0]['ChatTopicId_Fk']}");
    return parsed
        .map<chatquerylistmodal>((json) => chatquerylistmodal.fromMap(json))
        .toList();
  } else {
    throw Exception('Failed to load Chat Query');
  }
}

class studentChats extends StatefulWidget {
  const studentChats({super.key});

  @override
  State<studentChats> createState() => _studentChatsState();
}

class _studentChatsState extends State<studentChats> {
  late Future<List<chatquerylistmodal>> futurechatquerylistmodal;

  @override
  void initState() {
    super.initState();
    futurechatquerylistmodal = chatqueryfunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats Query',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: Container(
            width: 400,
            color: appcolors.whiteColor,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: FutureBuilder<List<chatquerylistmodal>>(
                future: futurechatquerylistmodal,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => getRow(index, snapshot),
                    );
                  } else {
                    if (snapshot.data == null) {
                      return Center(child: Text('Query Loading..'));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => createquerypage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getRow(int index, var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 2,
      child: SizedBox(
        height: 80,
        child: ListTile(
          onTap: () {
            // Navigate to Next Details
            toasts().toastsShortone("Chat module are coming soon");
            //Navigator.push(context, MaterialPageRoute(builder: (context) => chatqueryitempage(openrequest:snapshot.data![index])));
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: appcolors.primaryColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/6728/6728469.png',
              ),
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
                      SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(
                            "Query No : ${snapshot.data![index].QryNo}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          )),
                      SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(
                            "Topic Name : ${snapshot.data![index].ChatTopicName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          )),
                      Text("Create Date : ${snapshot.data![index].Createdate}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: CupertinoColors.systemGrey2)),
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
