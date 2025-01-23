import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromMap(x)));

class Post {
  Post({
    required this.Stuid,
    required this.smsid,
    required this.errormessage,
    required this.msgdatetime,
    required this.SmsContent,
  });

  String Stuid;
  String smsid ;
  String errormessage;
  String msgdatetime;
  String SmsContent;

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    Stuid: json["Stuid"],
    smsid: json["smsid"],
    errormessage: json["errormessage"],
    msgdatetime: json["msgdatetime"],
    SmsContent: json["SmsContent"],
  );
}
