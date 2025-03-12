import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/chatquerylistmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/toasts.dart';
import 'createquerypage.dart';

Future<List<ChatQueryListModel>> chatqueryfunction() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentid = prefs.getString('studentid');
    String? branchID = prefs.getString('BranchID');

    print("[INFO] Retrieved student ID: $studentid");
    print("[INFO] Retrieved branch ID: $branchID");

    if (studentid == null || branchID == null) {
      throw Exception("Missing student or branch ID in shared preferences.");
    }

    final url = Uri.parse(
        'https://shikshaappservice.kalln.com/api/Home/GetChatTopicqryshow/TopicFor/Stu/brid/$branchID/CreatedbyId/$studentid');
    print("[INFO] Fetching chat queries from URL: $url");

    final response = await http.get(url);

    print("[INFO] Response status code: ${response.statusCode}");
    print("[INFO] Response body: ${response.body}");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      print("[INFO] Parsed response data: ${parsed.length} items retrieved.");

      return parsed
          .map<ChatQueryListModel>((json) => ChatQueryListModel.fromMap(json))
          .toList();
    } else {
      throw Exception(
          'Failed to load Chat Query. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print("[ERROR] chatqueryfunction encountered an error: $e");
    rethrow;
  }
}

class StudentChats extends StatefulWidget {
  const StudentChats({super.key});

  @override
  State<StudentChats> createState() => _StudentChatsState();
}

class _StudentChatsState extends State<StudentChats> {
  late Future<List<ChatQueryListModel>> futureChatQueryList;

  @override
  void initState() {
    super.initState();
    print("[INFO] Initializing StudentChats page.");
    futureChatQueryList = chatqueryfunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Chats Query',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
        backgroundColor: appcolors.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(0.0),
          //   topRight: Radius.circular(0.0),
          // ),
          child: Container(
            width: double.infinity,
            color: appcolors.whiteColor,
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              child: FutureBuilder<List<ChatQueryListModel>>(
                future: futureChatQueryList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("[INFO] FutureBuilder is loading data.");
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(
                        "[ERROR] FutureBuilder encountered an error: ${snapshot.error}");
                    return Center(
                        child: Text(
                            'Error loading chat queries. Please try again later.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print("[INFO] No chat queries available.");
                    return const Center(child: Text('No queries found.'));
                  } else {
                    print("[INFO] Displaying chat queries.");
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => getRow(index, snapshot),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("[INFO] Navigating to CreateQueryPage.");
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const createquerypage()));
        },
        tooltip: 'Create Query',
        backgroundColor: appcolors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white, // Change the icon color here
          size: 30,
        ),
      ),
    );
  }

  Widget getRow(int index, AsyncSnapshot<List<ChatQueryListModel>> snapshot) {
    final query = snapshot.data![index];
    print("[INFO] Displaying query: ${query.qryNo}");

    return Card(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 2,
      child: SizedBox(
        height: 80,
        child: ListTile(
          onTap: () {
            print("[INFO] Query tapped: ${query.qryNo}");
            toasts().toastsShortone("Chat module is coming soon.");
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: appcolors.primaryColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: const NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/6728/6728469.png',
              ),
            ),
          ),
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 20,
                        width: 200,
                        child: Text(
                          "Query No : ${query.qryNo}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                        height: 20,
                        width: 200,
                        child: Text(
                          "Topic Name : ${query.chatTopicName}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        )),
                    Text("Create Date : ${query.createDate}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: CupertinoColors.systemGrey2)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
