import 'dart:convert';

// Function to parse JSON string into a list of ClassworkModel objects
List<ClassworkModel> classworkFromJson(String str) => List<ClassworkModel>.from(
    json.decode(str).map((x) => ClassworkModel.fromMap(x)));

// Model class for Classwork
class ClassworkModel {
  ClassworkModel({
    this.subjectMasterID,
    this.subjectName,
    this.classNm,
    this.datebyStudy,
    this.contytypID,
    this.videoLink,
    this.filename,
    this.topicName,
    this.contName,
    this.fullpath,
    this.errorMessage,
  });

  String? subjectMasterID;
  String? subjectName;
  String? classNm;
  String? datebyStudy;
  String? contytypID;
  String? videoLink;
  String? filename;
  String? topicName;
  String? contName;
  String? fullpath;
  String? errorMessage;

  // Factory constructor to create an instance from JSON Map
  factory ClassworkModel.fromMap(Map<String, dynamic> json) => ClassworkModel(
        subjectMasterID: json["subjectMasterID"],
        subjectName: json["subjectName"],
        classNm: json["classNm"],
        datebyStudy: json["datebyStudy"],
        contytypID: json["contytypID"],
        videoLink: json["videoLink"],
        filename: json["filename"],
        topicName: json["topicName"],
        contName: json["contName"],
        fullpath: json["fullpath"],
        errorMessage: json["errormessage"],
      );

  // Method to convert an instance to JSON Map
  Map<String, dynamic> toMap() => {
        "subjectMasterID": subjectMasterID,
        "subjectName": subjectName,
        "classNm": classNm,
        "datebyStudy": datebyStudy,
        "contytypID": contytypID,
        "videoLink": videoLink,
        "filename": filename,
        "topicName": topicName,
        "contName": contName,
        "fullpath": fullpath,
        "errormessage": errorMessage,
      };
}
