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
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stuid = prefs.getString('studentid');
    String? branchid = prefs.getString('BranchID');
    String? classstruid = prefs.getString('ClassID');
    String? subid = prefs.getString('subid');
    String? finatimetableid = prefs.getString('FinalDayTTid');
    print("Student ID: $stuid");
    print("Branch ID: $branchid");
    print("Class ID: $classstruid");
    print("Subject ID: $subid");
    print("Final TimeTable ID: $finatimetableid");
    // Ensure that none of these values are null
    if (stuid == null ||
        branchid == null ||
        classstruid == null ||
        subid == null ||
        finatimetableid == null) {
      throw Exception("Missing required parameters in SharedPreferences.");
    }

    final baseUrl =
        'https://shikshaappservice.kalln.com/api/Home/GetstuHWlist_remark/stuid/$stuid/brid/$branchid/class_struid/$classstruid/subid/$subid/finatimetableid/$finatimetableid';
    // 'https://shikshaappservice.kalln.com/api/Home/stu_hwremark/stuid/$stuid/brid/$branchid/classid/$classstruid/subid/$subid/finaldayttid/$finatimetableid';
    print("Base URL: $baseUrl");

    final response = await http.get(Uri.parse(baseUrl));
    print("responsefdfs: ${response}");
    print("Response Status Code: ${response.statusCode}"); // Log status code
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      // .cast<Map<String, dynamic>>();
      if (parsed is List) {
        return parsed
            .map<hwitemremarkmodal>((json) => hwitemremarkmodal.fromMap(json))
            .toList();
      } else {
        throw Exception("API returned invalid JSON format.");
      }
    } else if (response.statusCode == 404) {
      throw Exception("No remarks found for this student.");
    } else {
      throw Exception('Failed to load remarks: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching homework remarks: $e");
    throw Exception("Error fetching homework remarks: $e");
  }
}

class HomeworkItemRemarks extends StatefulWidget {
  const HomeworkItemRemarks({super.key, required this.openrequest});
  final homeworkmodal openrequest;

  @override
  State<HomeworkItemRemarks> createState() => _HomeworkItemRemarksState();
}

class _HomeworkItemRemarksState extends State<HomeworkItemRemarks> {
  late Future<List<hwitemremarkmodal>> futureHwItemRemarkModal;

  @override
  void initState() {
    super.initState();
    _saveHomeworkDetails();
    futureHwItemRemarkModal = hwitemremarkmodalfunction();
  }

  /// Saves homework details in SharedPreferences
  Future<void> _saveHomeworkDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('FinalDayTTid', widget.openrequest.finalTimeTableId);
    await prefs.setString('hwid', widget.openrequest.homeworkId);
    await prefs.setString('clienteid', widget.openrequest.clientId);
    await prefs.setString('ClasiD', widget.openrequest.classId);
    await prefs.setString('subid', widget.openrequest.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homework Remarks',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: Container(
            color: appcolors.whiteColor,
            child: FutureBuilder<List<hwitemremarkmodal>>(
              future: futureHwItemRemarkModal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No remarks available for this homework.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) =>
                        _buildRemarkCard(snapshot.data![index]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a card for each remark
  Widget _buildRemarkCard(hwitemremarkmodal remark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 1),
        elevation: 1,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => openhwremarkitem(openrequest: remark),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: appcolors.primaryColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                // remark.pathimg,
                'https://cdn1.iconfinder.com/data/icons/human-resources-2-5/128/164-512.png',
              ),
            ),
          ),
          title: Text(
         remark.hwRemark_text!=""? remark.hwRemark_text!:"No Remark",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            remark.createdDate ?? "Unknown Date",
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey2,
            ),
          ),
        ),
      ),
    );
  }
}
