import 'dart:convert';

// Function to parse JSON string into a list of timetablemodal objects
List<TimetableModel> timetableFromJson(String str) => List<TimetableModel>.from(
    json.decode(str).map((x) => TimetableModel.fromMap(x)));

// Model class for Timetable
class TimetableModel {
  TimetableModel({
    required this.tT_PK,
    required this.teacherID,
    required this.periodName,
    required this.classNm,
    required this.subjectMstID,
    required this.subjectName,
    required this.clsstrucId,
    required this.branchId,
    required this.fkgpclsId,
    required this.dShrtNm,
    required this.dayID,
    required this.periodTime,
    required this.techName,
    required this.mobNo,
    required this.errorMessage,
  });

  String tT_PK;
  String teacherID;
  String periodName;
  String classNm;
  String subjectMstID;
  String subjectName;
  String clsstrucId;
  String branchId;
  String fkgpclsId;
  String dShrtNm;
  String dayID;
  String periodTime;
  String techName;
  String mobNo;
  String errorMessage;

  // Factory constructor to create an instance from JSON Map
  factory TimetableModel.fromMap(Map<String, dynamic> json) => TimetableModel(
        tT_PK: json["tT_PK"],
        teacherID: json["teacherID"],
        periodName: json["periodName"],
        classNm: json["classNm"],
        subjectMstID: json["subjectMstID"],
        subjectName: json["subjectName"],
        clsstrucId: json["clsstrucId"],
        branchId: json["branchid"],
        fkgpclsId: json["fkgpclsid"],
        dShrtNm: json["dShrtNm"],
        dayID: json["dayID"],
        periodTime: json["periodTime"],
        techName: json["techName"],
        mobNo: json["mobNo"],
        errorMessage: json["errormessage"],
      );

  // Method to convert an instance to JSON Map
  Map<String, dynamic> toMap() => {
        "tT_PK": tT_PK,
        "teacherID": teacherID,
        "periodName": periodName,
        "classNm": classNm,
        "subjectMstID": subjectMstID,
        "subjectName": subjectName,
        "clsstrucId": clsstrucId,
        "branchid": branchId,
        "fkgpclsid": fkgpclsId,
        "dShrtNm": dShrtNm,
        "dayID": dayID,
        "periodTime": periodTime,
        "techName": techName,
        "mobNo": mobNo,
        "errormessage": errorMessage,
      };
}
