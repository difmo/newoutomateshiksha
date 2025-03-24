import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/hwitemremarkmodal.dart';

class openhwremarkitem extends StatefulWidget {
  const openhwremarkitem({super.key, required this.openrequest});
  final hwitemremarkmodal openrequest;

  @override
  State<openhwremarkitem> createState() => _openhwremarkitemState();
}

class _openhwremarkitemState extends State<openhwremarkitem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detailed Remarks'),
        ),
        body: Container(
          color: CupertinoColors.systemGrey4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.openrequest.pathimg,
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    color: appcolors.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(
                        child: Expanded(
                            child: Text(
                          widget.openrequest.hwRemark_text??'',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
