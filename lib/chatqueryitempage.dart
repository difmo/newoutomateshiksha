import 'package:flutter/material.dart';
import 'Resource/Colors/app_colors.dart';
import 'Models/chatquerylistmodal.dart';
import 'Utilles/textfields.dart';

class chatqueryitempage extends StatefulWidget {
  const chatqueryitempage({super.key, required this.openrequest});
  final chatquerylistmodal openrequest;

  @override
  State<chatqueryitempage> createState() => _chatqueryitempageState();
}

class _chatqueryitempageState extends State<chatqueryitempage> {
  TextEditingController s1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Query Chats",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: appcolors.whiteColor),
        ),
        backgroundColor: appcolors.primaryColor,
        iconTheme: IconThemeData(color: appcolors.whiteColor),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            child: Container(
                color: appcolors.whiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: appcolors.primaryColor,
                                    child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/512/6728/6728469.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 25,
                                          child: Expanded(
                                            child: Text(
                                              "Aditya Narayan",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color:
                                                      appcolors.primaryColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                      SizedBox(
                                          height: 20,
                                          child: Expanded(
                                            child: Text(
                                              "online",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                      //Text("Create Date : ${snapshot.data![index].Createdate}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: CupertinoColors.systemGrey2)),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  child: Icon(
                                Icons.more_vert,
                                color: appcolors.primaryColor,
                              )),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: appcolors.primaryColor,
                      ),
                      Container(
                        height: 432,
                      ),
                      Container(
                        height: 65,
                        color: appcolors.primaryColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  color: appcolors.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: edittextsone(
                                      label: '',
                                      hint: 'Enter Texts',
                                      maxlength: 1000,
                                      controllers: s1,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.10,
                                child: Icon(
                                  Icons.send,
                                  color: appcolors.whiteColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
