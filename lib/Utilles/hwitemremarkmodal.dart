
import 'dart:convert';

List<hwitemremarkmodal> postFromJson(String str) =>
    List<hwitemremarkmodal>.from(json.decode(str).map((x) => hwitemremarkmodal.fromMap(x)));


class hwitemremarkmodal {
  hwitemremarkmodal({
    required this.CreatedDate,
    required this.HWRemark_text,
    required this.StuHwId,
    required this.StuImgPath,
    required this.pathimg,
  });

  String CreatedDate;
  String HWRemark_text ;
  String StuHwId;
  String StuImgPath;
  String pathimg;

  factory hwitemremarkmodal.fromMap(Map<String, dynamic> json) => hwitemremarkmodal(
    CreatedDate: json["CreatedDate"],
    HWRemark_text: json["HWRemark_text"],
    StuHwId: json["StuHwId"],
    StuImgPath: json["StuImgPath"],
    pathimg: json["pathimg"],
  );
}
