import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class checkinternet extends StatefulWidget {
  const checkinternet({super.key});

  @override
  State<checkinternet> createState() => _checkinternetState();
}

class _checkinternetState extends State<checkinternet> {
  @override
  void initState() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
          Navigator.pop(context);
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
          Navigator.pop(context);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    internetconnection!.cancel();
    super.dispose();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //<-- SEE HERE
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
                size: 100,
              ),
              Text("Check Your Internet Connection",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff12263b),
                      fontWeight: FontWeight.bold)),
            ],
          )),
        ),
      ),
    );
  }
}
