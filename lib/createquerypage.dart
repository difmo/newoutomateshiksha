
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Resource/Colors/app_colors.dart';
// import 'package:newoutomateshiksha/studentChats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utilles/buttons.dart';
import 'Utilles/toasts.dart';


void postquery(String topicname,String topicId,String chatdiscription, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? studentid =prefs.getString('studentid')!;
  String? BranchID =prefs.getString('BranchID')!;
  var data={"ChatTopicId_Fk":topicId,"OtherTopicName":topicname, "ChatQry":chatdiscription,
            "QryCreatedbyId":studentid, "BranchId":BranchID,"Flg":"Stu"};
  var bodyy=jsonEncode(data);
  var response=await post(
      Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/Chattopicqry'),
      body:bodyy,
      headers: {
        "Content-Type":"application/json"
      }
  );

  var dataa=jsonDecode(response.body);
  print(dataa);
  if(response.statusCode==200)
  {
    print(dataa);
    if(response.body.contains('Correct')) {
      toasts().toastsShortone("Query Created Successfully");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }else{
      toasts().toastsShortone("Query Creation Failed");
      Navigator.of(context).pop();
    }
  }else
  {
    toasts().toastsShortone("Server Error....");
    Navigator.of(context).pop();
  }
}


class createquerypage extends StatefulWidget {
  const createquerypage({Key? key}) : super(key: key);

  @override
  State<createquerypage> createState() => _createquerypageState();
}

class _createquerypageState extends State<createquerypage> {
  List categoryClassItemlist = [];
  TextEditingController studescriptionController = TextEditingController();

  Future getAllClassCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? BranchID =prefs.getString('BranchID')!;
    var baseUrl = "http://shikshaappservice.outomate.com/ShikshaAppService.svc/GetChatTopic/TopicFor/Stu/brid/"+BranchID;

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      //Navigator.of(context).pop();
      var jsonData = json.decode(response.body);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh$jsonData");
      var dataa=jsonData;
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
        title: Text("Create Query",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.whiteColor),),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body:Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(15,50,15,50),
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text("Generate Query",style:TextStyle(fontWeight: FontWeight.bold,color:appcolors.backColor,fontSize: 20),),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10,10, 0),
                      child:  DropdownButtonFormField(
                        hint: Text('Select Topic'),
                        items: categoryClassItemlist.map((item) {
                          return DropdownMenuItem(
                            value: item['ChatTopicName'].toString(),
                            child: Text(item['ChatTopicName'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            itemName = newVal;
                            for(int i=0;i<categoryClassItemlist.length;i++){
                              if(categoryClassItemlist[i]['ChatTopicName']=="$newVal"){
                                itemId=categoryClassItemlist[i]['ChatTopicId'];
                              }
                            }

                          });
                        },
                        value: itemName,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0,10, 50),
                      child: TextField(
                        controller: studescriptionController,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Description',
                          hintText: 'Enter Description',
                        ),
                      ),
                    ),
                    InkWell(
                      child: buttons(title: 'CREATE', onPress: () {},width: 200,),
                      onTap: () {
                        setState(() {
                          print("gggggggggggggg${itemName}");
                          print("gggggggggggggg${studescriptionController.text.toString()}");
                          if (itemName == null || studescriptionController.text.toString().isEmpty == true) {
                            toasts().toastsShortone("Please fill the Proper Information..");
                          } else {
                            showDialog<void>(
                              context: context, barrierDismissible: false, builder: (BuildContext context) {
                                return Center(child: CircularProgressIndicator());},);
                            postquery(itemName.toString(),itemId.toString(), studescriptionController.text.toString(), context);
                          }
                        });
                      }
                    ),
                    SizedBox(height: 120,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
