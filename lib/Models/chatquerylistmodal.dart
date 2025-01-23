
import 'dart:convert';

List<chatquerylistmodal> postFromJson(String str) =>
    List<chatquerylistmodal>.from(json.decode(str).map((x) => chatquerylistmodal.fromMap(x)));


class chatquerylistmodal {
  chatquerylistmodal({
    required this.QryNo,
    required this.ChatTopicName,
    required this.QryCreatedbyId,
    required this.ChatQry,
    required this.Createdate,
  });

  String QryNo;
  String ChatTopicName ;
  String QryCreatedbyId;
  String ChatQry;
  String Createdate;

  factory chatquerylistmodal.fromMap(Map<String, dynamic> json) => chatquerylistmodal(
    QryNo: json["QryNo"],
    ChatTopicName: json["ChatTopicName"],
    QryCreatedbyId: json["QryCreatedbyId"],
    ChatQry: json["ChatQry"],
    Createdate: json["Createdate"],
  );
}
