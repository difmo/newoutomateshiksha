import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/timetablemodal.dart';
import 'Resource/Colors/app_colors.dart';

class StudentTimeTable extends StatefulWidget {
  const StudentTimeTable({super.key});

  @override
  State<StudentTimeTable> createState() => _StudentTimeTableState();
}

class _StudentTimeTableState extends State<StudentTimeTable> {
  bool hasbeenpressed1 = true;
  bool hasbeenpressed2 = false;
  bool hasbeenpressed3 = false;
  bool hasbeenpressed4 = false;
  bool hasbeenpressed5 = false;
  bool hasbeenpressed6 = false;

  List<dynamic> mondayItemlist = [];
  List<dynamic> tuesdayItemlist = [];
  List<dynamic> wednesdayItemlist = [];
  List<dynamic> thursdayItemlist = [];
  List<dynamic> fridayItemlist = [];
  List<dynamic> saturdayItemlist = [];

  late Future<List<TimetableModel>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  /// Fetch timetable from API
  Future<List<TimetableModel>> fetchPost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentid = prefs.getString('studentid');
      String? branchID = prefs.getString('BranchID');
      // print("122:$studentid");
      // print("cse:$branchID");
      if (studentid == null || branchID == null) {
        throw Exception(
            "Missing student ID or branch ID in SharedPreferences.");
      }

      final baseUrl =
          'https://shikshaappservice.kalln.com/api/Home/stu_tt/stuid/$studentid/brid/$branchID';
      print("Fetching timetable from URL: $baseUrl");
      print("$baseUrl");
      final response = await http.get(Uri.parse(baseUrl));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        mondayItemlist.clear();
        tuesdayItemlist.clear();
        wednesdayItemlist.clear();
        thursdayItemlist.clear();
        fridayItemlist.clear();
        saturdayItemlist.clear();

        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        for (final item in parsed) {
          switch (item['dayID']) {
            case '1':
              mondayItemlist.add(item);
              break;
            case '2':
              tuesdayItemlist.add(item);
              break;
            case '3':
              wednesdayItemlist.add(item);
              break;
            case '4':
              thursdayItemlist.add(item);
              break;
            case '5':
              fridayItemlist.add(item);
              break;
            case '6':
              saturdayItemlist.add(item);
              break;
          }
        }

        return parsed
            .map<TimetableModel>((json) => TimetableModel.fromMap(json))
            .toList();
      } else {
        throw Exception("Failed to load timetable: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching timetable: $e");
    }
  }

  /// Get the list for the selected day
  List<dynamic> getItemListForDay() {
    if (hasbeenpressed1) return mondayItemlist;
    if (hasbeenpressed2) return tuesdayItemlist;
    if (hasbeenpressed3) return wednesdayItemlist;
    if (hasbeenpressed4) return thursdayItemlist;
    if (hasbeenpressed5) return fridayItemlist;
    if (hasbeenpressed6) return saturdayItemlist;
    return [];
  }

  /// Update the selected day
  void updateSelectedDay(int dayIndex) {
    setState(() {
      hasbeenpressed1 = dayIndex == 1;
      hasbeenpressed2 = dayIndex == 2;
      hasbeenpressed3 = dayIndex == 3;
      hasbeenpressed4 = dayIndex == 4;
      hasbeenpressed5 = dayIndex == 5;
      hasbeenpressed6 = dayIndex == 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Time Table",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<TimetableModel>>(
        future: futurePost,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return SingleChildScrollView(
            child: Container(
              color: appcolors.primaryColor,
              child: ClipRRect(
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(40.0),
                //   topRight: Radius.circular(40.0),
                // ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildDaySelector(),
                      const SizedBox(height: 20),
                      _buildTimetableList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Day selector widget
  Widget _buildDaySelector() {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return Container(
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          days.length,
          (index) => InkWell(
            onTap: () => updateSelectedDay(index + 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: (index + 1 == 1 && hasbeenpressed1) ||
                      (index + 1 == 2 && hasbeenpressed2) ||
                      (index + 1 == 3 && hasbeenpressed3) ||
                      (index + 1 == 4 && hasbeenpressed4) ||
                      (index + 1 == 5 && hasbeenpressed5) ||
                      (index + 1 == 6 && hasbeenpressed6)
                  ? appcolors.primaryColor
                  : Colors.transparent,
              child: Text(
                days[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: (index + 1 == 1 && hasbeenpressed1) ||
                          (index + 1 == 2 && hasbeenpressed2) ||
                          (index + 1 == 3 && hasbeenpressed3) ||
                          (index + 1 == 4 && hasbeenpressed4) ||
                          (index + 1 == 5 && hasbeenpressed5) ||
                          (index + 1 == 6 && hasbeenpressed6)
                      ? Colors.white
                      : appcolors.backColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Timetable list widget
  Widget _buildTimetableList() {
    final items = getItemListForDay();

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No timetable available for the selected day."),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          elevation: 1,
          child: ListTile(
            title: Text(
              item['subjectName'] ?? "N/A",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appcolors.primaryColor),
            ),
            subtitle: Text(
              "Lecture: ${item['periodName']} | Time: ${item['periodTime']}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            trailing: Text(
              item['techName'] ?? "N/A",
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
