import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/feemodal.dart';
import 'Resource/Colors/app_colors.dart';

class studentfees extends StatefulWidget {
  const studentfees({super.key});

  @override
  State<studentfees> createState() => _studentfeesState();
}

class _studentfeesState extends State<studentfees> {
  int selectedIndex = 0; // Stores the selected tab index

  List<String> tabLabels = [
    "Regular Fees",
    "Additional Fees",
    "Admission Fees"
  ];

  List regularItemlist = [];
  List additionalItemlist = [];
  List admissionItemlist = [];

  late Future<List<FeeModel>> futurePost;
  String errorMessage = ''; // To hold the error message

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  Future<List<FeeModel>> fetchPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stucode = prefs.getString('clientid')!;
    String? brid = prefs.getString('BranchID')!;
    String? fsecid = prefs.getString('F_SessionId')!;
    print("clientid :: $stucode");
    print("BranchId :: $brid");

    String baseUrl = 'https://shikshaappservice.kalln.com/api/Home/stu_Fee/';
    String url = '$baseUrl' + 'stucode/00154/brid/$brid/fsecid/$fsecid';

    // Print the base URL and the full URL
    print('Base URL: $baseUrl');
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Print the response body
      print('Response: ${response.body}');

      regularItemlist.clear();
      additionalItemlist.clear();
      admissionItemlist.clear();

      var parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      // Check if the error message exists in the response
      if (parsed.isNotEmpty && parsed[0]['errormessage'] != "Correct") {
        setState(() {
          errorMessage = parsed[0]['errormessage'];
        });
        return []; // Return an empty list as the fee data is not found
      }
      // If no error, process the fee data
      for (int i = 0; i < parsed.length; i++) {
        if (parsed[i]['feermk'] == 'Regular Fees') {
          regularItemlist.add(parsed[i]);
        }
        if (parsed[i]['feermk'] == 'Additional Fees') {
          additionalItemlist.add(parsed[i]);
        }
        if (parsed[i]['feermk'] == 'Admission Fees') {
          admissionItemlist.add(parsed[i]);
        }
      }

      return parsed.map<FeeModel>((json) => FeeModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load fee');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fees",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: Container(
            color: appcolors.whiteColor,
            child: Column(
              children: [
                // Error message display
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 8), // Margin for spacing
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(30),
                    selectedBorderColor: appcolors.primaryColor,
                    fillColor: appcolors.primaryColor.withOpacity(0.2),
                    color: appcolors.backColor,
                    selectedColor: appcolors.primaryColor,
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    isSelected:
                        List.generate(3, (index) => index == selectedIndex),
                    onPressed: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    children: tabLabels
                        .map((label) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Text(
                                label,
                                style: TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.8, // 70% of screen height
                  child: FutureBuilder(
                    future: fetchPost(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        int type = selectedIndex == 0
                            ? regularItemlist.length
                            : selectedIndex == 1
                                ? additionalItemlist.length
                                : selectedIndex == 2
                                    ? admissionItemlist.length
                                    : 0;

                        return ListView.builder(
                          itemCount: type,
                          itemBuilder: (BuildContext context, int index) {
                            return getRow(index, snapshot);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
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

  Widget getRow(int index, var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 1, 10, 0),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 1,
      child: SizedBox(
        height: 110,
        child: ListTile(
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 2),
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(6, 5, 6, 2),
                      color: Colors.black12,
                      child: Text(
                        "Receipt No - XXXX${selectedIndex == 0 ? regularItemlist[index]['feeGenID'] : selectedIndex == 1 ? additionalItemlist[index]['feeGenID'] : admissionItemlist[index]['feeGenID']}",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "FeeMonth - ${selectedIndex == 0 ? regularItemlist[index]['fee_elementName'] : selectedIndex == 1 ? additionalItemlist[index]['fee_elementName'] : admissionItemlist[index]['fee_elementName']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: appcolors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DueAmount : ${selectedIndex == 0 ? regularItemlist[index]['dueAmt'] : selectedIndex == 1 ? additionalItemlist[index]['dueAmt'] : admissionItemlist[index]['dueAmt']}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: appcolors.backColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "FeeAmount : ${selectedIndex == 0 ? regularItemlist[index]['feeamt'] : selectedIndex == 1 ? additionalItemlist[index]['feeamt'] : admissionItemlist[index]['feeamt']}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: appcolors.backColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  // padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Due Date - ${selectedIndex == 0 ? regularItemlist[index]['feeduedt'] : selectedIndex == 1 ? additionalItemlist[index]['feeduedt'] : admissionItemlist[index]['feeduedt']}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: appcolors.backColor),
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
