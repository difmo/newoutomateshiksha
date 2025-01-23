
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'Resource/Colors/app_colors.dart';


class rateuspage extends StatefulWidget {
  const rateuspage({Key? key}) : super(key: key);

  @override
  State<rateuspage> createState() => _rateuspageState();
}

class _rateuspageState extends State<rateuspage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: Text("Please Rate Us",style:TextStyle(fontWeight: FontWeight.bold,color: appcolors.whiteColor)),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Column(
        children: [
          Expanded(child:InAppWebView(
              // initialUrlRequest:URLRequest(url: Uri.parse("https://play.google.com/store/apps/details?id=com.saptrishi.outomateshiksha&hl=en_IN&gl=US"))
          ),
          ),
        ],
      ),
    );
  }
}
