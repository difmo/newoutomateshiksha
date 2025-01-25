import 'package:flutter/cupertino.dart';

class space extends StatelessWidget {
  const space({
    super.key,
    this.height = 10,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: height,
      ),
    );
  }
}
