
import 'dart:convert';

List<timetablemodal> postFromJson(String str) =>
    List<timetablemodal>.from(json.decode(str).map((x) => timetablemodal.fromMap(x)));


class timetablemodal {
  timetablemodal({
    required this.DayID,
    required this.PeriodName,
    required this.SubjectName,
    required this.TechName,
    required this.PeriodTime,
  });

  String DayID;
  String PeriodName ;
  String SubjectName;
  String TechName;
  String PeriodTime;

  factory timetablemodal.fromMap(Map<String, dynamic> json) => timetablemodal(
    DayID: json["DayID"],
    PeriodName: json["PeriodName"],
    SubjectName: json["SubjectName"],
    TechName: json["TechName"],
    PeriodTime: json["PeriodTime"],
  );
}
