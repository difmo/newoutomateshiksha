import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'Utilles/toasts.dart';


Future uploadhomework(List imgpath,BuildContext context) async {
  var Imagesbase64set = <Map>[];
  for(int i=0;i<imgpath.length;i++){
    Imagesbase64set.add({'stuhwimg': "${imgpath[i]}"});
  }
  print("hhhhhhhhhh${Imagesbase64set}");
  var data={
    "StudentidPk":"23120",
    "Clientid":"2333",
    "Branchid":"28",
    "homework_idpk":"7394",
    "classid":"2222",
    "subjectid":"944",
    "Finaldaytimetable_idfk":"29943",
     "Stream64":Imagesbase64set};
    var bodyy=jsonEncode(data);
    var response=await post(
      Uri.parse('http://shikshaappservice.outomate.com/ShikshaAppService.svc/Stu_HWSubmission'),
      body:bodyy,
      headers: {"Content-Type":"application/json"});
  if(response.statusCode==200)
  {
    if(response.body.contains('Correct')) {
      toasts().toastsShortone("Homework Uploaded Successfully");
      //Navigator.of(context).pop();
    }else{
      toasts().toastsShortone("Homework Uploaded Failed");
      //Navigator.of(context).pop();
    }
  }else
  {
    toasts().toastsShortone("Server Error....");
    //Navigator.of(context).pop();
  }
}




class MultipleImageSelector extends StatefulWidget {
  const MultipleImageSelector({super.key});

  @override
  State<MultipleImageSelector> createState() => _MultipleImageSelectorState();
}

class _MultipleImageSelectorState extends State<MultipleImageSelector> {
  List<File> selectedImages = [];
  List<String> Imagespath = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    // display image selected from gallery
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Images Select'),
        backgroundColor: Colors.green,
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text('Select Image from Gallery and Camera'),
              onPressed: () {
                getImages();
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "GFG",
                textScaleFactor: 3,
                style: TextStyle(color: Colors.green),
              ),
            ),
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
                    return Center(
                        child: kIsWeb
                            ? Image.network(selectedImages[index].path)
                            : Image.file(selectedImages[index]));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
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
        uploadhomework(Imagespath,context);
      },
    );
  }
  basesixfour(String imagepath) async {
    File imagefile = File(imagepath); //convert Path to File
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes); //convert bytes to base64 string
    Imagespath.add(base64string);
    //print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiii${Imagespath}");
  }
}