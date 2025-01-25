import 'dart:convert';

List<circularmodal> postFromJson(String str) => List<circularmodal>.from(
    json.decode(str).map((x) => circularmodal.fromMap(x)));

class circularmodal {
  circularmodal({
    required this.circularTitle,
    required this.createDate,
    required this.smsId,
    required this.branch_Id,
    required this.circularFileName,
    required this.errormessage,
  });

  String circularTitle;
  String createDate;
  String smsId;
  String branch_Id;
  String errormessage;
  String circularFileName;

  factory circularmodal.fromMap(Map<String, dynamic> json) => circularmodal(
        smsId: json["smsId"],
        circularTitle: json["circularTitle"],
        createDate: json["createDate"],
        branch_Id: json["branch_Id"],
        circularFileName: json["circularFileName"],
        errormessage: json["errormessage"],
      );
}
