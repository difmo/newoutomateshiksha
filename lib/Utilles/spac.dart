

import 'package:flutter/cupertino.dart';

class space  extends StatelessWidget {
  const space ({Key? key,
     this.height=10,
  }) : super(key: key);

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
