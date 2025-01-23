
import 'dart:convert';

List<circularmodal> postFromJson(String str) =>
    List<circularmodal>.from(json.decode(str).map((x) => circularmodal.fromMap(x)));


class circularmodal {
  circularmodal({
    required this.CircularTitle,
    required this.CreateDate,
    required this.SmsId,
    required this.errormessage,
    required this.circularFileName,
  });

  String CircularTitle;
  String CreateDate ;
  String SmsId;
  String errormessage;
  String circularFileName;

  factory circularmodal.fromMap(Map<String, dynamic> json) => circularmodal(
    CircularTitle: json["CircularTitle"],
    CreateDate: json["CreateDate"],
    SmsId: json["SmsId"],
    errormessage: json["errormessage"],
    circularFileName: json["circularFileName"],
  );
}
