import 'dart:convert';

// Function to convert JSON string to list of Post objects
List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromMap(x)));

// Post class representing the structure of the data
class Post {
  Post({
    required this.smsid,
    required this.stuid,
    required this.msgdatetime,
    required this.smsContent,
    required this.errormessage,
  });

  String smsid; // SMS ID
  String stuid; // Student ID
  String msgdatetime; // Message Date and Time
  String smsContent; // SMS Content, can contain HTML
  String errormessage; // Error message

  // Factory constructor to create a Post object from a Map
  factory Post.fromMap(Map<String, dynamic> json) => Post(
        smsid: json["smsid"],
        stuid: json["stuid"],
        msgdatetime: json["msgdatetime"],
        smsContent: json["smsContent"], // HTML or plain text content
        errormessage: json["errormessage"],
      );

  // Method to convert Post object back to a Map
  Map<String, dynamic> toMap() => {
        "smsid": smsid,
        "stuid": stuid,
        "msgdatetime": msgdatetime,
        "smsContent": smsContent,
        "errormessage": errormessage,
      };

  // Method to convert Post object to JSON string
  String toJson() => json.encode(toMap());
}
