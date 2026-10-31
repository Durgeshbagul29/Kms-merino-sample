// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:path_provider/path_provider.dart';

class NearmissArchieve extends StatefulWidget {
  const NearmissArchieve({super.key});

  @override
  State<NearmissArchieve> createState() => _NearmissArchieveState();
}

class _NearmissArchieveState extends State<NearmissArchieve>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    // _getDashboardData();
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
        backgroundColor: Theme.of(context).primaryColor, // Dark blue background
        elevation: 0,
        title: Text(
          'Near Miss List',
          style: TextStyle(
            color: Colors.white, // White text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          // SingleChildScrollView(
          //   child:Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height,
          //     decoration: BoxDecoration(color: Colors.white),
          //     child:
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FutureBuilder<dynamic>(
              future: getNearmissFilesData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return errorWidgetDesign(
                      context,
                      snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    // dynamic filesData = snapshot.data;
                    dynamic response = snapshot.data;
                    return response['success'] == true
                        ? response['data'] != null &&
                                  response['data'].length > 0
                              ? ListView.separated(
                                  separatorBuilder: (context, i) =>
                                      Divider(color: Colors.transparent),
                                  itemCount: response['data'].length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
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
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.file_copy,
                                            color: Theme.of(context).primaryColor,
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
                                        trailing:
                                            response['data'][index]["url"] ==
                                                '-'
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.download,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  fileNotFoundDialogBox(
                                                    context,
                                                  );
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.download,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                onPressed: () {
                                                  downloadFile(
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
                return Center(child: AnimatedDotsLoader(text: "Loading", color: Theme.of(context).primaryColor));
                // return connectedToWifi != true ? checkConnectionWidget(context) : snapshot.data == false ? Login() : HomePage();
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
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            "No Data Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "There are no archived files to display",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  Future<void> downloadFile(String uri, String fileName) async {
    setState(() {
      downloading = true;
    });

    CustomLoader.show(
      context,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      loaderText: Text(
        "\nDownloading File...",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );

    String savePath = await getFilePath(fileName);

    Dio dio = Dio();

    dio
        .download(
          uri,
          savePath,
          onReceiveProgress: (rcv, total) {
            debugPrint(
              'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}',
            );

            setState(() {
              progress = ((rcv / total) * 100).toStringAsFixed(0);
            });

            if (progress == '100') {
              setState(() {
                isDownloaded = true;
              });
            } else if (double.parse(progress) < 100) {}
          },
          deleteOnError: true,
        )
        .then((_) {
          setState(() {
            if (progress == '100') {
              isDownloaded = true;
            }

            downloading = false;
            CustomLoader.hide();
            dialogBoxForFileDownloadSuccess(
              context,
              'File Downloaded Successfully',
              savePath,
            );
          });
        })
        .catchError((error) {
          CustomLoader.hide();
          dialogBoxForFailure(
            context,
            'Unable to download file',
            'Please try again',
          );
        });
  }

  Future<String> getFilePath(String uniqueFileName) async {
    String path = '';

    // Directory dir = await getApplicationDocumentsDirectory();
    // Directory? dir = await getExternalStorageDirectory();

    String dir = (await getExternalStorageDirectory())!.path;

    path = '$dir/$uniqueFileName';
    // path = dir.path+'/'+uniqueFileName;
    debugPrint("path is $path");

    return path;
  }

  // List<DataRow> _tableRows(List data) {
  //   List<DataRow> newList = data.map((element) {
  //     return DataRow(
  //       cells: [DataCell(Text(element["filename"] as String)),
  //         DataCell(IconButton(icon: Icon(Icons.download,color: Colors.green,),
  //           onPressed: (){},
  //         ),),
  //       ]
  //     );
  //   }).toList();
  //   return newList;
  // }
}
