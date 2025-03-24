import 'dart:convert';

List<ChatQueryListModel> postFromJson(String str) =>
    List<ChatQueryListModel>.from(
        json.decode(str).map((x) => ChatQueryListModel.fromMap(x)));

class ChatQueryListModel {
  ChatQueryListModel({
    required this.qryNo,
    required this.chatTopicName,
    required this.qryCreatedById,
    required this.chatQry,
    required this.createDate,
  });

  String qryNo;
  String chatTopicName;
  String qryCreatedById;
  String chatQry;
  String createDate;

  factory ChatQueryListModel.fromMap(Map<String, dynamic> json) =>
      ChatQueryListModel(
        qryNo: json["qryNo"] ?? "",
        chatTopicName: json["chatTopicName"] ?? "",
        qryCreatedById: json["qryCreatedbyId"] ?? "",
        chatQry: json["chatQry"] ?? "",
        createDate: json["createdate"] ?? "",
      );
}
