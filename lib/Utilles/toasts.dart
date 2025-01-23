

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class toasts{

  void toastsShortone(String printvalue){
    Fluttertoast.showToast(
        msg: printvalue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  void toastsLongone(String printvalue){
    Fluttertoast.showToast(
        msg: printvalue,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }



}