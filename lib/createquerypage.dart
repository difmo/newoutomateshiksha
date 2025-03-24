import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Resource/Colors/app_colors.dart';
// import 'package:newoutomateshiksha/studentChats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilles/buttons.dart';
import 'Utilles/toasts.dart';

void postquery(String topicname, String topicId, String chatdiscription,
    BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid = prefs.getString('studentid')!;
  String? branchId = prefs.getString('BranchID')!;

  print("student :: $studentid");
  print("branchid :: $branchId");
  print("topic:: $topicId");
  print("topicname:: $topicname");
  print("orhertopicname:: $topicname");
  print("topicname:: $topicname");
  print("chatqry ::$chatdiscription");
  print("qryCreatedbyId: $studentid");
  print("branchId: $branchId");
  print("flg: Stu");
  print("qryStatus : string");
  print("topicqryid: string");
  print("chatTopicName: string");
  print("empname: string");
  print("studentname: string");
  print("classNm: string");
  print("createdate: string");
  var data = {
    "chatTopicId_Fk": topicId,
    "topicName": topicname,
    "otherTopicName": topicname,
    "chatQry": chatdiscription,
    "qryNo": "string",
    "qryCreatedbyId": studentid,
    "branchId": branchId,
    "flg": "Stu",
    "qryStatus": "string",
    "topicqryid": "string",
    "chatTopicName": "string",
    "empname": "string",
    "studentname": "string",
    "classNm": "string",
    "createdate": "string",
    "loopValue": "0",
    "fwdEmpId": "26546",
    "errormessage": "string",
    "qryResp": [
      {
        "chat_ResQryText": "string",
        "respQryno": "string",
        "respDate": "string",
        "qryRespBy": "string",
        "respFlg": "string",
        "errormessage": "string"
      }
    ]
  };

  print(" Datas :: $data");
  var bodyy = jsonEncode(data);

  var response = await post(
    Uri.parse('https://shikshaappservice.kalln.com/api/Home/Chattopicqry'),
    body: bodyy,
    headers: {"Content-Type": "application/json"},
  );

  var dataa = jsonDecode(response.body);
  print("ChatResponse :: $dataa");

  if (response.statusCode == 200) {
    if (response.body.contains('Correct')) {
      toasts().toastsShortone("Query Created Successfully");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      toasts().toastsShortone("Query Creation Failed");
      Navigator.of(context).pop();
    }
  } else {
    toasts().toastsShortone("Server Error....");
    Navigator.of(context).pop();
  }
}

class createquerypage extends StatefulWidget {
  const createquerypage({super.key});

  @override
  State<createquerypage> createState() => _createquerypageState();
}

class _createquerypageState extends State<createquerypage> {
  List categoryClassItemlist = [];
  TextEditingController studescriptionController = TextEditingController();

  Future getAllClassCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? branchId = prefs.getString('BranchID')!;
    var baseUrl =
        "https://shikshaappservice.kalln.com/api/Home/GetChatTopic/TopicFor/Stu/brid/$branchId";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      //Navigator.of(context).pop();
      var jsonData = json.decode(response.body);
      print("hhhhhhhhhhhh$jsonData");
      var dataa = jsonData;
      setState(() {
        categoryClassItemlist = dataa;
        //  print("ssss--${categoryItemlist[0]['ClassName']}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllClassCategory();
  }

  var itemName;
  var itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Query",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            // child: Card(
            // margin: EdgeInsets.fromLTRB(15, 50, 15, 50),
            // color: Colors.white,
            // shadowColor: Colors.black,
            // elevation: 10,
            child: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Generate Query",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appcolors.backColor,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Select Topic',
                    labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: appcolors.primaryColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: appcolors.primaryColor, width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  ),
                  dropdownColor: Colors.white,
                  items: categoryClassItemlist.map((item) {
                    return DropdownMenuItem(
                      value: item['chatTopicName'].toString(),
                      child: Text(
                        item['chatTopicName'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      itemName = newVal;
                      for (var item in categoryClassItemlist) {
                        if (item['chatTopicName'] == newVal) {
                          itemId = item['chatTopicId'];
                          print(itemId);
                          break;
                        }
                      }
                    });
                  },
                  value: itemName,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
                child: TextField(
                  // controller: studescriptionController,
                  maxLines: 3, // Allows multiline input
                  decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Enter your message',
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Always keeps the label on top
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                      borderSide:
                          BorderSide(color: appcolors.primaryColor, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: appcolors.primaryColor, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 16), // Increases text size
                ),
              ),
              InkWell(
                borderRadius:
                    BorderRadius.circular(30), // Smooth rounded corners
                onTap: () {
                  setState(() {
                    print("gggggggggggggg$itemName");
                    print(
                        "gggggggggggggg${studescriptionController.text.toString()}");
                    if (itemName == null ||
                        studescriptionController.text.trim().isEmpty) {
                      toasts().toastsShortone(
                          "Please fill the Proper Information..");
                    } else {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                      postquery(itemName.toString(), itemId.toString(),
                          studescriptionController.text.toString(), context);
                    }
                  });
                },
                child: Container(
                  height: 50,
                  width: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appcolors.primaryColor,
                        appcolors.primaryColor
                      ], // Gradient effect
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 120),
            ])),
          ),
        ),
      ),
      // ),
    );
  }
}
