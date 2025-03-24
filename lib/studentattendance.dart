import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'Resource/Colors/app_colors.dart';

class studentattendance extends StatefulWidget {
  const studentattendance({
    super.key,
  });

  @override
  State<studentattendance> createState() => _studentattendanceState();
}

class _studentattendanceState extends State<studentattendance> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List toHighlight = [];
  String apitime = "00:00 AM - 00:00 PM";

  Future getAllSectionCategory() async {
    // Future.delayed(Duration.zero, () {
    //   show(context);
    // });
//    06-APR-2023
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ClsStruId = prefs.getString('clsstrucidFK')!;
    String? BranchId = prefs.getString('BranchID')!;
    String? StuId = prefs.getString('studentid')!;
    String? Attandate = getCurrentDate()!;

    var baseUrl =
        "https://shikshaappservice.kalln.com/api/Home/GetClassAtten/ClsStruId/$ClsStruId/BranchId/$BranchId/Attan_date/${Attandate!}/StuId/$StuId";
//     var baseUrl =
// //    06-APR-2023
//         "https://shikshaappservice.kalln.com/api/Home/GetClassAtten/ClsStruId/2482/BranchId/36/Attan_date/2025-01-24/StuId/26433";
    print("ssssssssssss:$baseUrl");
    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      var jsonData = json.decode(response.body);
      print(jsonData.toString());
      setState(() {
        toHighlight = jsonData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSectionCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: appcolors.primaryColor,
      appBar: AppBar(
        title: Text(
          "Student Attendance",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(40.0),
          //   topRight: Radius.circular(40.0),
          // ),
          child: Container(
            color: appcolors.whiteColor,
            child: Column(
              children: [
                // TableCalendar(
                //   firstDay: DateTime(2022),
                //   lastDay: DateTime(2024),
                //   focusedDay: _focusedDay,
                //   calendarFormat: _calendarFormat,
                //   startingDayOfWeek: StartingDayOfWeek.monday,
                //   rowHeight: 40,
                //   daysOfWeekHeight: 60,
                //   headerStyle: HeaderStyle(
                //     titleCentered: true,
                //     titleTextStyle: const TextStyle(
                //         color: appcolors.backColor,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20),
                //     formatButtonVisible: false,
                //     leftChevronIcon: const Icon(
                //       Icons.arrow_back_ios,
                //       color: appcolors.primaryColor,
                //     ),
                //     rightChevronIcon: const Icon(
                //       Icons.arrow_forward_ios,
                //       color: appcolors.primaryColor,
                //     ),
                //   ),
                //   calendarBuilders: CalendarBuilders(
                //     dowBuilder: (context, day) {
                //       if (day.weekday == DateTime.sunday) {
                //         final text = DateFormat.E().format(day);
                //         return Center(
                //           child: Text(
                //             text,
                //             style: TextStyle(
                //                 color: Colors.orange,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //         );
                //       }
                //       return null;
                //     },
                //     defaultBuilder: (context, day, focusedDay) {
                //       for (int i = 0; i < toHighlight.length; i++) {
                //         String date = toHighlight[i]['Attan_date'].toString();
                //         String status =
                //             toHighlight[i]['Attan_Status'].toString();

                //         String newdate = dateConverter(date);
                //         String dateWithT = newdate;
                //         DateTime dateTimee = DateTime.parse(dateWithT);

                //         if (day.day == dateTimee.day &&
                //             day.month == dateTimee.month &&
                //             day.year == dateTimee.year) {
                //           if (status == "P") {
                //             return Container(
                //               decoration: const BoxDecoration(
                //                   /* color: Colors.green,
                //                   shape: BoxShape.circle,*/
                //                   ),
                //               child: Center(
                //                 child: Text(
                //                   '${day.day}',
                //                   style: const TextStyle(
                //                       color: Colors.green,
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 18),
                //                 ),
                //               ),
                //             );
                //           } else {
                //             if (status == "A") {
                //               return Container(
                //                 decoration: const BoxDecoration(),
                //                 child: Center(
                //                   child: Text(
                //                     '${day.day}',
                //                     style: const TextStyle(
                //                         color: Colors.red,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 18),
                //                   ),
                //                 ),
                //               );
                //             } else {
                //               return Container(
                //                 decoration: const BoxDecoration(),
                //                 child: Center(
                //                   child: Text(
                //                     '${day.day}',
                //                     style: const TextStyle(
                //                         color: Colors.orange,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 18),
                //                   ),
                //                 ),
                //               );
                //             }
                //           }
                //         }
                //       }

                //       return null;
                //     },
                //   ),
                //   daysOfWeekStyle: const DaysOfWeekStyle(
                //     weekdayStyle: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: appcolors.primaryColor),
                //     weekendStyle: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: appcolors.primaryColor),
                //   ),
                //   calendarStyle: const CalendarStyle(
                //     weekendTextStyle: TextStyle(
                //         fontWeight: FontWeight.bold, color: Colors.orange),
                //     defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
                //     todayDecoration: BoxDecoration(
                //       color: appcolors.primaryColor,
                //       shape: BoxShape.circle,
                //     ),
                //     selectedDecoration: BoxDecoration(
                //       color: Colors.black26,
                //       shape: BoxShape.circle,
                //     ),
                //   ),
                //   weekendDays: [DateTime.sunday],
                //   onDaySelected: (selectedDay, focusedDay) {
                //     if (!isSameDay(_selectedDay, selectedDay)) {
                //       setState(() {
                //         _selectedDay = selectedDay;
                //         _focusedDay = focusedDay;
                //         String date = "01-04-2023";
                //         int ldata = 0;
                //         String newdate = dateConverter(date);
                //         String dateWithT = newdate;
                //         DateTime dateTime = DateTime.parse(dateWithT);
                //         String sdate = "${_selectedDay!.day}";
                //         String smonth = "${_selectedDay!.month}";
                //         String syear = "${_selectedDay!.year}";
                //         if (_selectedDay?.day.toString().length == 1) {
                //           sdate = "0$sdate";
                //         }
                //         if (_selectedDay?.month.toString().length == 1) {
                //           smonth = "0$smonth";
                //         }
                //         String sfuldate = "$sdate-$smonth-$syear";
                //         for (int i = 0; i < toHighlight.length; i++) {
                //           ldata++;
                //           String apidate =
                //               toHighlight[i]['Attan_date'].toString();
                //           String status =
                //               toHighlight[i]['Attan_Status'].toString();
                //           // if(sfuldate==apidate && status=="P"){
                //           if (sfuldate == apidate && status == "P") {
                //             print(
                //                 'lllllllllllll$ldata sdsASs${toHighlight.length}');
                //             if (ldata == toHighlight.length) {
                //               setState(() {
                //                 apitime = '00:00 AM - 00:00 PM';
                //                 print("parsentTiming$apitime");
                //               });
                //               break;
                //             } else {
                //               setState(() {
                //                 apitime =
                //                     toHighlight[i]['Attan_time'].toString();
                //                 print("parsentTiming$apitime");
                //               });
                //               break;
                //             }
                //           }
                //           if (ldata == toHighlight.length) {
                //             setState(() {
                //               apitime = '00:00 AM - 00:00 PM';
                //               print("parsentTiming$apitime");
                //             });
                //             break;
                //           }
                //         }
                //       });
                //     }
                //   },
                //   selectedDayPredicate: (day) {
                //     return isSameDay(_selectedDay, day);
                //   },
                //   onFormatChanged: (format) {
                //     if (_calendarFormat != format) {
                //       setState(() {
                //         _calendarFormat = format;
                //       });
                //     }
                //   },
                //   onPageChanged: (focusedDay) {
                //     _focusedDay = focusedDay;
                //   },
                // ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                      color: appcolors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: appcolors.primaryColor,
                            child: Text('IN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: appcolors.whiteColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: CupertinoColors.systemGrey5,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(apitime,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appcolors.primaryColor)),
                              ),
                            ),
                          ),
                          Container(
                            color: appcolors.primaryColor,
                            child: Text('OUT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: appcolors.whiteColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        margin: EdgeInsets.fromLTRB(50, 2, 0, 2),
                        child: PhysicalModel(
                          color: Colors.red,
                          elevation: 2,
                          shadowColor: appcolors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  child: Text(
                                    "Total Absent",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appcolors.whiteColor,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Text(
                                  "00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: appcolors.whiteColor,
                                      fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: EdgeInsets.fromLTRB(0, 2, 50, 2),
                        child: PhysicalModel(
                          color: Colors.green,
                          elevation: 2,
                          shadowColor: appcolors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  child: Text(
                                    "Total Present",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appcolors.whiteColor,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Text(
                                  "00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: appcolors.whiteColor,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  getCurrentDate() {
    return DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  String dateConverter(String date) {
    // Input date Format
    final format = DateFormat("dd-MM-yyyy");
    DateTime gettingDate = format.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // Output Date Format
    final String formatted = formatter.format(gettingDate);
    return formatted;
  }

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
