import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/homeworkmodal.dart';
import 'Utilles/buttons.dart';
import 'Utilles/toasts.dart';

Future uploadhomework(List imgpath, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stuid = prefs.getString('studentid')!;
  String? clientid = prefs.getString('clienteid')!;
  String? branchid = prefs.getString('BranchID')!;
  String? hwid = prefs.getString('hwid')!;
  String? classstruid = prefs.getString('ClassID')!;
  String? subid = prefs.getString('subid')!;
  String? finatimetableid = prefs.getString('FinalDayTTid')!;

  var Imagesbase64set = <Map>[];
  for (int i = 0; i < imgpath.length; i++) {
    Imagesbase64set.add({'stuhwimg': "${imgpath[i]}"});
  }
  print("hhhhhhhhhh$Imagesbase64set");
  var data = {
    "StudentidPk": stuid,
    "Clientid": clientid,
    "Branchid": branchid,
    "homework_idpk": hwid,
    "classid": classstruid,
    "subjectid": subid,
    "Finaldaytimetable_idfk": finatimetableid,
    "Stream64": Imagesbase64set
  };
  var bodyy = jsonEncode(data);
  var response = await post(
      Uri.parse(
          'https://shikshaappservice.kalln.com/api/Home/Stu_HWSubmission'),
      body: bodyy,
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    if (response.body.contains('Correct')) {
      toasts().toastsShortone("Homework Uploaded Successfully");
      Navigator.of(context).pop();
    } else {
      toasts().toastsShortone("Homework Uploaded Failed");
      Navigator.of(context).pop();
    }
  } else {
    toasts().toastsShortone("Server Error....");
    Navigator.of(context).pop();
  }
}

class homeworkitemsubmit extends StatefulWidget {
  const homeworkitemsubmit({super.key, required this.openrequest});
  final homeworkmodal openrequest;

  @override
  State<homeworkitemsubmit> createState() => _homeworkitemsubmitState();
}

class _homeworkitemsubmitState extends State<homeworkitemsubmit> {
  bool scroll = false;
  List<File> selectedImages = [];
  List<String> Imagespath = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    gethomeworkid();
    getImages();
  }

  gethomeworkid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FinalDayTTid', widget.openrequest.FinalDayTimeTable_Id_fk);
    prefs.setString('hwid', widget.openrequest.homework_id);
    prefs.setString('clienteid', widget.openrequest.stu_clientid);
    prefs.setString('ClasiD', widget.openrequest.stu_classid);
    prefs.setString('subid', widget.openrequest.subjectmst_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Homework'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: 300.0,
                child: selectedImages.isEmpty
                    ? const Center(child: Text('Sorry nothing selected!!'))
                    : GridView.builder(
                        itemCount: selectedImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: kIsWeb
                                    ? SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                          child: Image.network(
                                            selectedImages[index].path,
                                            fit: BoxFit.fill,
                                          ),
                                        ))
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                            child: Image.file(
                                          selectedImages[index],
                                          fit: BoxFit.fill,
                                        )))),
                          );
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: InkWell(
                child: buttons(
                  title: 'SUBMIT',
                  onPress: () {},
                  width: 150,
                  height: 50,
                ),
                onTap: () {
                  uploadhomework(Imagespath, context);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            print("ssssssssssssssss${xfilePick[i].path}");
            basesixfour(xfilePick[i].path);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  basesixfour(String imagepath) async {
    File imagefile = File(imagepath); //convert Path to File
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string
    Imagespath.add(base64string);
    //print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiii${Imagespath}");
  }
}
