import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// import 'package:newoutomateshiksha/Utilles/spac.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/homeworkmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/buttons.dart';
import 'Utilles/toasts.dart';
import 'homeworkitemremarks.dart';
import 'homeworkitemsubmit.dart';
import 'homeworkopenitem.dart';

Future<List<homeworkmodal>> homeworkfunction(String adate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid = prefs.getString('studentid')!;
  String? BranchID = prefs.getString('BranchID')!;
  final response = await http.get(Uri.parse(
      'http://shikshaappservice.outomate.com/ShikshaAppService.svc/stu_homework/stuid/' +
          studentid +
          '/brid/' +
          BranchID +
          '/hwdate/$adate'));
  print("ffffffffffff$studentid");
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed
        .map<homeworkmodal>((json) => homeworkmodal.fromMap(json))
        .toList();
  } else {
    throw Exception('Failed to load notice');
  }
}

class studenthomework extends StatefulWidget {
  const studenthomework({Key? key}) : super(key: key);

  @override
  State<studenthomework> createState() => _studenthomeworkState();
}

class _studenthomeworkState extends State<studenthomework> {
  DateTime selectedDate = DateTime.now();
  String fdate = DateFormat('EEEE-dd MMMM yyyy').format(DateTime.now());
  String adate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late Future<List<homeworkmodal>> homeworkmodalfunction;
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
    homeworkmodalfunction = homeworkfunction(adate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990, 1),
      lastDate: DateTime(2030, 12),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    setState(() {
      DateFormat formatter1 = DateFormat('EEEE-dd MMMM yyyy');
      DateFormat formatter2 = DateFormat('dd-MM-yyyy');
      fdate = formatter1.format(selectedDate);
      adate = formatter2.format(selectedDate);
      homeworkmodalfunction = homeworkfunction(adate);
    });
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: Container(
            color: appcolors.whiteColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15, 30, 10, 10),
                  child: Text(
                    "Today Home Work",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.fromLTRB(10,10,10,10),
                  color: CupertinoColors.systemGrey4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                        color: CupertinoColors.systemGrey4,
                        child: Text(
                          "$fdate",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          color: appcolors.primaryColor,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: appcolors.whiteColor,
                              ),
                              Text("Select Date",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: appcolors.whiteColor)),
                            ],
                          ),
                        ),
                        onTap: () {
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
                  padding: EdgeInsets.fromLTRB(1, 10, 1, 10),
                  child: FutureBuilder<List<homeworkmodal>>(
                    future: homeworkmodalfunction,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => getRow(index, snapshot),
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

  Widget getRow(int index, var snapshot) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 1),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 2,
      child: Container(
        height: 80,
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Text(
                        "${snapshot.data![index].subjectmst_name}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                if (snapshot.data![index].subjectmst_name ==
                                    null) {
                                  toasts().toastsShortone("No Records Found");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              homeworkopenitem(
                                                  openrequest:
                                                      snapshot.data![index])));
                                }
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                                if (snapshot.data![index].subjectmst_name ==
                                    null) {
                                  toasts().toastsShortone("No Records Found");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              homeworkitemsubmit(
                                                  openrequest:
                                                      snapshot.data![index])));
                                }
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                                if (snapshot.data![index].subjectmst_name ==
                                    null) {
                                  toasts().toastsShortone("No Records Found");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              homeworkitemremarks(
                                                  openrequest:
                                                      snapshot.data![index])));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Text(
                "DOS : ${snapshot.data![index].stu_dos}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: CupertinoColors.systemGrey2),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
