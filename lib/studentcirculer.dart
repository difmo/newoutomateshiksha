import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Models/circularmodal.dart';
import 'Resource/Colors/app_colors.dart';
import 'Utilles/toasts.dart';
import 'circuleropen.dart';

/// Fetch circular data from API
Future<List<circularmodal>> fetchCirculars(
    String brid, String sessionid, String stuid) async {
  // try {
  final baseUrl =
      'https://shikshaappservice.kalln.com/api/Home/GetCircular/brid/$brid/sessionid/$sessionid/stuid/$stuid';
  print("Fetching circulars from URL: $baseUrl");

  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<circularmodal>((json) => circularmodal.fromMap(json))
        .toList();
  } else {
    throw Exception('Failed to load circulars: ${response.statusCode}');
  }
  // } catch (e) {
  //   throw Exception('Error fetching circulars: $e');
  // }
}

class StudentCircular extends StatefulWidget {
  const StudentCircular({super.key});

  @override
  State<StudentCircular> createState() => _StudentCircularState();
}

class _StudentCircularState extends State<StudentCircular> {
  String? brid;
  String? sessionid;
  String? stuid;

  late Future<List<circularmodal>> futureCirculars;

  @override
  void initState() {
    super.initState();
    loadPreferencesAndFetchCirculars();
  }

  /// Load SharedPreferences and initiate API call
  Future<void> loadPreferencesAndFetchCirculars() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      brid = prefs.getString('BranchID');
      sessionid = prefs.getString('F_SessionId');
      stuid = prefs.getString('studentid');

      if (brid == null || sessionid == null || stuid == null) {
        showErrorSnackBar("Error: Missing required data in SharedPreferences.");
        return;
      }

      setState(() {
        futureCirculars = fetchCirculars(brid!, sessionid!, stuid!);
      });
    } catch (e) {
      showErrorSnackBar("Error loading preferences: $e");
    }
  }

  /// Display error message in SnackBar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circulars'),
        backgroundColor: appcolors.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: appcolors.primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: Container(
            color: appcolors.whiteColor,
            child: FutureBuilder<List<circularmodal>>(
              future: futureCirculars,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Circulars Found",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) =>
                        buildCircularCard(index, snapshot),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a single card for a circular
  Widget buildCircularCard(
      int index, AsyncSnapshot<List<circularmodal>> snapshot) {
    final circular = snapshot.data![index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      shadowColor: appcolors.primaryColor,
      elevation: 2,
      child: ListTile(
        onTap: () {
          if (circular.circularTitle == null) {
            toasts().toastsShortone("No Records Found");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => circuleropen(openrequest: circular),
              ),
            );
          }
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: appcolors.primaryColor,
          child: const CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              'https://images.idgesg.net/images/article/2019/04/pdf-editor-primary-100794256-large.jpg?auto=webp&quality=85,70',
            ),
          ),
        ),
        title: Text(
          circular.circularTitle ?? "No Title",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          circular.createDate ?? "Unknown Date",
          style:
              const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
        ),
      ),
    );
  }
}
