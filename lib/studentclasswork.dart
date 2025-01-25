import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/classworkmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/toasts.dart';
import 'classworkopenitem.dart';

Future<List<ClassworkModel>> fetchClasswork(String adate) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? classId = prefs.getString('clsstrucidFK');
    String? branchId = prefs.getString('BranchID');

    if (classId == null || branchId == null) {
      throw Exception("Missing class ID or branch ID in SharedPreferences.");
    }

    final baseUrl =
        'https://shikshaappservice.kalln.com/api/Home/stu_classwork/Classid/$classId/brid/$branchId/cwdate/$adate';
    print("Fetching classwork from URL: $baseUrl");

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ClassworkModel>((json) => ClassworkModel.fromMap(json))
          .toList();
    } else {
      throw Exception("Failed to load classwork: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error fetching classwork: $e");
  }
}

class StudentClasswork extends StatefulWidget {
  const StudentClasswork({super.key});

  @override
  State<StudentClasswork> createState() => _StudentClassworkState();
}

class _StudentClassworkState extends State<StudentClasswork> {
  DateTime selectedDate = DateTime.now();
  late Future<List<ClassworkModel>> classworkFuture;

  String fdate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
  String adate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String yturl =
      "https://www.howtogeek.com/wp-content/uploads/2019/10/youtube-logo.jpg?height=200p&trim=2,2,2,2";
  String docurl =
      "https://png.pngtree.com/png-vector/20190413/ourlarge/pngtree-vector-doc-icon-png-image_944072.jpg";
  String pdfurl =
      "https://images.news18.com/ibnlive/uploads/2020/08/1596522361_pdf.jpg";
  String imgurl =
      "https://img.freepik.com/premium-vector/gallery-icon-picture-landscape-vector-sign-symbol_660702-224.jpg";

  @override
  void initState() {
    super.initState();
    classworkFuture = fetchClasswork(adate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fdate = DateFormat('EEEE, dd MMMM yyyy').format(selectedDate);
        adate = DateFormat('yyyy-MM-dd').format(selectedDate);
        classworkFuture = fetchClasswork(adate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Classwork",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildDateSelector(),
                Expanded(
                  child: FutureBuilder<List<ClassworkModel>>(
                    future: classworkFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No classwork found for the selected date.",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => _buildClassworkCard(
                            snapshot.data![index],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Date selector widget
  Widget _buildDateSelector() {
    return Container(
      color: CupertinoColors.systemGrey4,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              fdate,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: () => selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: appcolors.primaryColor,
              child: Row(
                children: const [
                  Icon(Icons.calendar_month_outlined, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "Select Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Classwork card widget
  Widget _buildClassworkCard(ClassworkModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      elevation: 2,
      child: ListTile(
        onTap: () {
          if (item.subjectName == null) {
            toasts().toastsShortone("No Records Found");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => classworkopenitem(openrequest: item),
              ),
            );
          }
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: appcolors.primaryColor,
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: _getImageForContentType(item.contName),
          ),
        ),
        title: Text(
          item.subjectName ?? "Unknown Subject",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          item.topicName ?? "No Topic Available",
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Helper method to get the appropriate image based on content type
  ImageProvider _getImageForContentType(String? contentType) {
    if (contentType == 'Image') {
      return NetworkImage(imgurl);
    } else if (contentType == 'File') {
      return NetworkImage(pdfurl);
    } else if (contentType == 'Video Link') {
      return NetworkImage(yturl);
    } else {
      return NetworkImage(docurl);
    }
  }
}
