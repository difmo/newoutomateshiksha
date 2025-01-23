
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class calender extends StatefulWidget{

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
    }
    final DateFormat formatter = DateFormat('EEEE-dd MMMM yyyy');
    final String formatted = formatter.format(selectedDate);
    print("aaaaaaaa$formatted");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selctdate', formatted);

  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}