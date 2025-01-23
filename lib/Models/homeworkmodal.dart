

import 'dart:convert';

List<homeworkmodal> postFromJson(String str) =>
    List<homeworkmodal>.from(json.decode(str).map((x) => homeworkmodal.fromMap(x)));


class homeworkmodal {
  homeworkmodal({
    required this.FinalDayTimeTable_Id_fk,
    required this.homework_id,
    required this.stu_HWpath,
    required this.stu_doh,
    required this.stu_dos,
    required this.subjectmst_name,
    required this.stu_clientid,
    required this.stu_classid,
    required this.subjectmst_id,
  });

  String FinalDayTimeTable_Id_fk;
  String homework_id ;
  String stu_HWpath;
  String stu_doh;
  String stu_dos;
  String subjectmst_name;
  String stu_clientid;
  String stu_classid;
  String subjectmst_id;

  factory homeworkmodal.fromMap(Map<String, dynamic> json) => homeworkmodal(
    FinalDayTimeTable_Id_fk: json["FinalDayTimeTable_Id_fk"],
    homework_id: json["homework_id"],
    stu_HWpath: json["stu_HWpath"],
    stu_doh: json["stu_doh"],
    stu_dos: json["stu_dos"],
    subjectmst_name: json["subjectmst_name"],
    stu_clientid: json["stu_clientid"],
    stu_classid: json["stu_classid"],
    subjectmst_id: json["subjectmst_id"],
  );
}
