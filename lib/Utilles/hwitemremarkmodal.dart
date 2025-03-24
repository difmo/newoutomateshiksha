import 'dart:convert';

List<hwitemremarkmodal> postFromJson(String str) =>
    List<hwitemremarkmodal>.from(
        json.decode(str).map((x) => hwitemremarkmodal.fromMap(x)));

class hwitemremarkmodal {
  final String pathimg;
  final String stuImgPath;
  final String stuHwId;
  final String? hwRemark_text; // Make nullable
  final String? createdDate; // Make nullable
  final String errormessage;

  hwitemremarkmodal({
    required this.pathimg,
    required this.stuImgPath,
    required this.stuHwId,
    this.hwRemark_text, // Allow null
    this.createdDate, // Allow null
    required this.errormessage,
  });

  factory hwitemremarkmodal.fromMap(Map<String, dynamic> json) {
    return hwitemremarkmodal(
      pathimg: json["pathimg"] ?? "", // ✅ If null, set empty string
      stuImgPath: json["stuImgPath"] ?? "",
      stuHwId: json["stuHwId"] ?? "",
      hwRemark_text:
          json["hwRemark_text"] ?? "No Remark Available", // ✅ Fix null issue
      createdDate:
          json["createdDate"]?.toString() ?? "Unknown Date", // ✅ Fix null issue
      errormessage: json["errormessage"] ?? "Unknown error",
    );
  }
}

// class hwitemremarkmodal {
//   hwitemremarkmodal({
//     this.CreatedDate,
//     this.HWRemark_text,
//     required this.StuHwId,
//     required this.StuImgPath,
//     required this.pathimg,
//     required this.errormessage,
//   });

//   String? CreatedDate;
//   final String? HWRemark_text;
//   String StuHwId;
//   String StuImgPath;
//   String pathimg;
//   String errormessage;
//   factory hwitemremarkmodal.fromMap(Map<String, dynamic> json) =>
//       hwitemremarkmodal(
//         CreatedDate: json["createdDate"]?.toString() ??
//             "Unknown Date", // ✅ Fix null issue
//         HWRemark_text: json["HWRemark_text"],
//         StuHwId: json["StuHwId"],
//         StuImgPath: json["StuImgPath"],
//         pathimg: json["pathimg"],
//         errormessage: json["errormessage"] ?? "Unknown error",
//       );
// }
