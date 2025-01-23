import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'Models/homeworkmodal.dart';

class homeworkopenitem extends StatefulWidget {
  const homeworkopenitem({super.key, required this.openrequest});

  final homeworkmodal openrequest;

  @override
  State<homeworkopenitem> createState() => _homeworkopenitemState();
}

class _homeworkopenitemState extends State<homeworkopenitem> {
  @override
  void initState() {
    super.initState();
    print("hhhhhhhhhhhh ${widget.openrequest.stu_HWpath}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Home Work'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
                initialUrlRequest: URLRequest(
                    // url: Uri.parse("${widget.openrequest.stu_HWpath}"))
            ),
          ),
          )
        ],
      ),
    );
  }
}
