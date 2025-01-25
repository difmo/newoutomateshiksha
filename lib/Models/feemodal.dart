import 'dart:convert';

List<FeeModel> feeModelFromJson(String str) =>
    List<FeeModel>.from(json.decode(str).map((x) => FeeModel.fromMap(x)));

class FeeModel {
  FeeModel({
    this.feeReceiptTermID,
    this.stuname,
    this.feetermName,
    this.feeElementName,
    this.feeamt,
    this.concessamt,
    this.payfee,
    this.distprecent,
    this.specldist,
    this.feeduedt,
    this.feermk,
    this.errormessage,
    this.dueAmt,
    this.feeGenID,
  });

  String? feeReceiptTermID;
  String? stuname;
  String? feetermName;
  String? feeElementName;
  String? feeamt;
  String? concessamt;
  String? payfee;
  String? distprecent;
  String? specldist;
  String? feeduedt;
  String? feermk;
  String? errormessage;
  String? dueAmt;
  String? feeGenID;

  factory FeeModel.fromMap(Map<String, dynamic> json) => FeeModel(
        feeReceiptTermID: json["feeReceiptTermID"],
        stuname: json["stuname"],
        feetermName: json["feetermName"],
        feeElementName: json["fee_elementName"],
        feeamt: json["feeamt"],
        concessamt: json["concessamt"],
        payfee: json["payfee"],
        distprecent: json["distprecent"],
        specldist: json["specldist"],
        feeduedt: json["feeduedt"],
        feermk: json["feermk"],
        errormessage: json["errormessage"],
        dueAmt: json["dueAmt"],
        feeGenID: json["feeGenID"],
      );
}
