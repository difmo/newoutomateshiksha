import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:newoutomateshiksha_newmaster/Utilles/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/homeworkmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/buttons.dart';
import 'homeworkitemremarks.dart';
import 'homeworkitemsubmit.dart';
import 'homeworkopenitem.dart';

Future<List<homeworkmodal>> homeworkfunction(String adate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid = prefs.getString('studentid');
  String? branchID = prefs.getString('BranchID');

  if (studentid == null || branchID == null) {
    throw Exception("Missing student or branch ID");
  }

  final response = await http.get(Uri.parse(
      'https://shikshaappservice.kalln.com/api/Home/stu_homework/stuid/$studentid/brid/$branchID/hwdate/$adate'));

  print(
      "API URL: https://shikshaappservice.kalln.com/api/Home/stu_homework/stuid/$studentid/brid/$branchID/hwdate/$adate");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    try {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      List<homeworkmodal> homeworkList = parsed
          .map<homeworkmodal>((json) => homeworkmodal.fromMap(json))
          .toList();

      print("Parsed Homework Data: $homeworkList");

      return homeworkList;
    } catch (e) {
      throw Exception('Parsing Error: $e');
    }
  } else {
    throw Exception(
        'Failed to load homework. Status Code: ${response.statusCode}');
  }
}

class studenthomework extends StatefulWidget {
  const studenthomework({super.key});

  @override
  State<studenthomework> createState() => _studenthomeworkState();
}

class _studenthomeworkState extends State<studenthomework> {
  DateTime selectedDate = DateTime.now();
  late String fdate;
  late String adate;
  late Future<List<homeworkmodal>> homeworkmodalfunction;

  @override
  void initState() {
    super.initState();
    fdate = DateFormat('EEEE-dd MMMM yyyy').format(selectedDate);
    adate = DateFormat('dd-MM-yyyy').format(selectedDate);
    print("Initial Date: \$adate");
    homeworkmodalfunction = homeworkfunction(adate);
    print("Testing :: $homeworkmodalfunction");
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990, 1),
      lastDate: DateTime(2030, 12),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fdate = DateFormat('EEEE-dd MMMM yyyy').format(selectedDate);
        adate = DateFormat('dd-MM-yyyy').format(selectedDate);
        print("Selected Date: \$adate");
        homeworkmodalfunction = homeworkfunction(adate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homework",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          child: Container(
            color: appcolors.whiteColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15, 30, 10, 10),
                  child: Text("Today Home Work",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: CupertinoColors.systemGrey4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fdate,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: appcolors.primaryColor,
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,
                                  color: appcolors.whiteColor),
                              SizedBox(width: 5),
                              Text("Select Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: appcolors.whiteColor)),
                            ],
                          ),
                        ),
                        onTap: () => selectDate(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<homeworkmodal>>(
                    future: homeworkmodalfunction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No Data Found${snapshot.data}'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => getRow(index, snapshot),
                      );
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

  Widget getRow(int index, AsyncSnapshot<List<homeworkmodal>> snapshot) {
    return Card(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        title: Text(snapshot.data![index].subjectName ?? "No Subject",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text("DOS : ${snapshot.data![index].dateOfSubmission}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: CupertinoColors.systemGrey2)),
        trailing: Wrap(
          spacing: 5,
          children: [
            InkWell(
              child: buttons(
                title: 'view',
                onPress: () {},
                width: 60,
                height: 30,
                borderradious: 2,
                buttonColor: Colors.red,
                textColor: Colors.white,
                textsize: 10,
              ),
              onTap: () {
                if (snapshot.data![index].subjectName == null) {
                  toasts().toastsShortone("No Records Found");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeworkopenitem(
                              openrequest: snapshot.data![index])));
                }
              },
            ),
            SizedBox(width: 5),
            InkWell(
              child: buttons(
                title: 'submit',
                onPress: () {},
                width: 60,
                height: 30,
                borderradious: 2,
                buttonColor: Colors.green,
                textColor: Colors.white,
                textsize: 10,
              ),
              onTap: () {
                if (snapshot.data![index].subjectName == null) {
                  toasts().toastsShortone("No Records Found");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeworkitemsubmit(
                              openrequest: snapshot.data![index])));
                }
              },
            ),
            SizedBox(width: 5),
            InkWell(
              child: buttons(
                title: 'remarks',
                onPress: () {},
                width: 60,
                height: 30,
                borderradious: 2,
                buttonColor: Colors.orange,
                textColor: Colors.white,
                textsize: 10,
              ),
              onTap: () {
                if (snapshot.data![index].subjectName == null) {
                  toasts().toastsShortone("No Records Found");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeworkItemRemarks(
                              openrequest: snapshot.data![index])));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
