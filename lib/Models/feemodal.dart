import 'dart:convert';

List<FeeModel> feeModelFromJson(String str) =>
    List<FeeModel>.from(json.decode(str).map((x) => FeeModel.fromMap(x)));

String feeModelToJson(List<FeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeeModel {
  FeeModel({
    required this.feeReceiptTermID,
    required this.stuName,
    required this.feeTermName,
    required this.feeElementName,
    required this.feeAmt,
    required this.concessAmt,
    required this.payFee,
    required this.discountPercent,
    required this.specialDist,
    required this.feeDueDt,
    required this.feeRemark,
    required this.errorMessage,
    required this.dueAmt,
    required this.feeGenID,
  });

  final String feeReceiptTermID;
  final String stuName;
  final String feeTermName;
  final String feeElementName;
  final double feeAmt;
  final double concessAmt;
  final double payFee;
  final double discountPercent;
  final String specialDist;
  final DateTime feeDueDt;
  final String feeRemark;
  final String errorMessage;
  final double dueAmt;
  final String feeGenID;

  factory FeeModel.fromMap(Map<String, dynamic> json) => FeeModel(
        feeReceiptTermID: json["feeReceiptTermID"] ?? "",
        stuName: json["stuname"] ?? "",
        feeTermName: json["feetermName"] ?? "",
        feeElementName: json["fee_elementName"] ?? "",
        feeAmt: double.tryParse(json["feeamt"] ?? "0") ?? 0.0,
        concessAmt: double.tryParse(json["concessamt"] ?? "0") ?? 0.0,
        payFee: double.tryParse(json["payfee"] ?? "0") ?? 0.0,
        discountPercent: double.tryParse(json["distprecent"] ?? "0") ?? 0.0,
        specialDist: json["specldist"] ?? "NA",
        feeDueDt: DateTime.tryParse(json["feeduedt"] ?? "") ?? DateTime(1970),
        feeRemark: json["feermk"] ?? "",
        errorMessage: json["errormessage"] ?? "",
        dueAmt: double.tryParse(json["dueAmt"] ?? "0") ?? 0.0,
        feeGenID: json["feeGenID"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "feeReceiptTermID": feeReceiptTermID,
        "stuname": stuName,
        "feetermName": feeTermName,
        "fee_elementName": feeElementName,
        "feeamt": feeAmt.toString(),
        "concessamt": concessAmt.toString(),
        "payfee": payFee.toString(),
        "distprecent": discountPercent.toString(),
        "specldist": specialDist,
        "feeduedt": feeDueDt.toIso8601String(),
        "feermk": feeRemark,
        "errormessage": errorMessage,
        "dueAmt": dueAmt.toString(),
        "feeGenID": feeGenID,
      };
}
