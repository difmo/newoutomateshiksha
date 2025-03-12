import 'dart:convert';

List<homeworkmodal> postFromJson(String str) => List<homeworkmodal>.from(
    json.decode(str).map((x) => homeworkmodal.fromMap(x)));

class homeworkmodal {
  homeworkmodal({
    required this.subjectId,
    required this.subjectName,
    required this.dateOfHomework,
    required this.dateOfSubmission,
    required this.homeworkPath,
    required this.classId,
    required this.className,
    required this.studentId,
    required this.studentName,
    required this.clientId,
    required this.finalTimeTableId,
    required this.homeworkId,
    required this.errorMessage,
    required this.homeworkUrl,
  });
  String subjectId;
  String subjectName;
  String dateOfHomework;
  String dateOfSubmission;
  String homeworkPath;
  String classId;
  String className;
  String studentId;
  String studentName;
  String clientId;
  String finalTimeTableId;
  String homeworkId;
  String errorMessage;
  String homeworkUrl;

  factory homeworkmodal.fromMap(Map<String, dynamic> json) => homeworkmodal(
        subjectId: json["subjectmst_id"],
        subjectName: json["subjectmst_name"],
        dateOfHomework: json["stu_doh"],
        dateOfSubmission: json["stu_dos"],
        homeworkPath: json["stu_hwpath"],
        classId: json["stu_classid"],
        className: json["stu_classnm"],
        studentId: json["stu_id"],
        studentName: json["stu_name"],
        clientId: json["stu_clientid"],
        finalTimeTableId: json["finalDayTimeTable_Id_fk"],
        homeworkId: json["homework_id"],
        errorMessage: json["errormessage"],
        homeworkUrl: json["stu_HWpath1"],
      );
  Map<String, dynamic> toMap() => {
        "subjectmst_id": subjectId,
        "subjectmst_name": subjectName,
        "stu_doh": dateOfHomework,
        "stu_dos": dateOfSubmission,
        "stu_hwpath": homeworkPath,
        "stu_classid": classId,
        "stu_classnm": className,
        "stu_id": studentId,
        "stu_name": studentName,
        "stu_clientid": clientId,
        "finalDayTimeTable_Id_fk": finalTimeTableId,
        "homework_id": homeworkId,
        "errormessage": errorMessage,
        "stu_HWpath1": homeworkUrl,
      };
}
