
import 'dart:convert';

List<feemodal> postFromJson(String str) =>
    List<feemodal>.from(json.decode(str).map((x) => feemodal.fromMap(x)));


class feemodal {
  feemodal({
    required this.DueAmt,
    required this.Fee_elementName,
    required this.Feeamt,
    required this.Feermk,
    required this.feeduedt,
    required this.Concessamt,
    required this.FeeGenID,
    required this.FeeReceiptTermID,
  });

  String DueAmt;
  String Fee_elementName ;
  String Feeamt;
  String Feermk;
  String feeduedt;
  String Concessamt;
  String FeeGenID;
  String FeeReceiptTermID;

  factory feemodal.fromMap(Map<String, dynamic> json) => feemodal(
    DueAmt: json["DueAmt"],
    Fee_elementName: json["Fee_elementName"],
    Feeamt: json["Feeamt"],
    Feermk: json["Feermk"],
    feeduedt: json["feeduedt"],
    Concessamt: json["Concessamt"],
    FeeGenID: json["FeeGenID"],
    FeeReceiptTermID: json["FeeReceiptTermID"],
  );
}
