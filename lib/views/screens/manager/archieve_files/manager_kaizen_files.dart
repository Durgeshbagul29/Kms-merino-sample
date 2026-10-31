// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerKaizenArchieve extends StatefulWidget {
  const ManagerKaizenArchieve({super.key});

  @override
  State<ManagerKaizenArchieve> createState() => _ManagerKaizenArchieveState();
}

class _ManagerKaizenArchieveState extends State<ManagerKaizenArchieve>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'Kaizen List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FutureBuilder<dynamic>(
          future: getManagerKaizenFilesData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? response['data'] != null && response['data'].length > 0
                        ? ListView.builder(
                            itemCount: response['data'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.list_alt,
                                      color: Colors.green,
                                    ),
                                  ),
                                  title: Text(
                                    response['data'][index]["filename"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: response['data'][index]["url"] == '-'
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.download,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            _showFileNotFoundDialog(context);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.download,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            _downloadFile(
                                              response['data'][index]["url"]
                                                  .toString(),
                                              response['data'][index]["filename"]
                                                  .toString(),
                                            );
                                          },
                                        ),
                                ),
                              );
                            },
                          )
                        : _buildNoDataWidget()
                    : _buildNoDataWidget();
              }
            }
            return Center(
              child: AnimatedDotsLoader(
                  text: "Loading", color: Theme.of(context).primaryColor),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 60,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          Text(
            "No Data Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "There are no archived files to display",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  void _showFileNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("File Not Found"),
          content: Text("The requested file is not available for download."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _downloadFile(String url, String filename) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch file')),
      );
    }
  }
}
