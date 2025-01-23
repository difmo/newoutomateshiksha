
import 'dart:convert';

List<classworkmodal> postFromJson(String str) =>
    List<classworkmodal>.from(json.decode(str).map((x) => classworkmodal.fromMap(x)));


class classworkmodal {
  classworkmodal({
    required this.ContName,
    required this.SubjectName,
    required this.TopicName,
    required this.VideoLink,
    required this.fullpath,
  });

  String ContName;
  String SubjectName ;
  String TopicName;
  String VideoLink;
  String fullpath;

  factory classworkmodal.fromMap(Map<String, dynamic> json) => classworkmodal(
    ContName: json["ContName"],
    SubjectName: json["SubjectName"],
    TopicName: json["TopicName"],
    VideoLink: json["VideoLink"],
    fullpath: json["fullpath"],
  );
}
