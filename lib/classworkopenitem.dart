import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'Models/classworkmodal.dart';

class classworkopenitem extends StatefulWidget {
  const classworkopenitem({super.key, required this.openrequest});

  final classworkmodal openrequest;

  @override
  State<classworkopenitem> createState() => _classworkopenitemState();
}

class _classworkopenitemState extends State<classworkopenitem> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print("hhhhhhhhhhhh ${widget.openrequest.fullpath}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Class Work'),
      ),
      body: Column(
        children: [
          if (widget.openrequest.ContName == "File")
            Expanded(
                child: SfPdfViewer.network(
                  '${widget.openrequest.fullpath}',
                  key: _pdfViewerKey,
                )),
          if (widget.openrequest.ContName == "Image")
          Expanded(
              child: InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri.uri("${widget.openrequest.fullpath}" as Uri)),
          )),
            if (widget.openrequest.ContName == "Video Link")
          Expanded(
              child: InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri.uri("${widget.openrequest.VideoLink}" as Uri)),
          )),
        ],
      ),
    );
  }
}