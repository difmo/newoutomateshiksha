import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'Models/circularmodal.dart';

class circuleropen extends StatefulWidget {
  const circuleropen({super.key, required this.openrequest});
  final circularmodal openrequest;

  @override
  State<circuleropen> createState() => _circuleropenState();
}

class _circuleropenState extends State<circuleropen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Circuler'),
      ),
      body: SfPdfViewer.network(
        widget.openrequest.circularFileName,
        key: _pdfViewerKey,
      ),
    );
  }
}
