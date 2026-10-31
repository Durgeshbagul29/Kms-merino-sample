// ignore_for_file: prefer_const_constructors

// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:path_provider/path_provider.dart';

class AccidentArchieve extends StatefulWidget {
  const AccidentArchieve({super.key});

  @override
  State<AccidentArchieve> createState() => _AccidentArchieveState();
}

class _AccidentArchieveState extends State<AccidentArchieve>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    // _getDashboardData();
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // // final iOS = IOSInitializationSettings();
    // final initSettings = InitializationSettings(android: android);

    // flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
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
        child: dashboardWidget()
    );
  }

  Widget dashboardWidget(){
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Dark blue background
        elevation: 0,
        title: Text(
          'Accident List',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FutureBuilder<dynamic>(
                future: getAccidentFilesData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  if(snapshot.connectionState==ConnectionState.done){
                    if(snapshot.hasError){
                      debugPrint(snapshot.error.toString());
                      return errorWidgetDesign(context,snapshot.error.toString());
                    }else if(snapshot.hasData){

                      // dynamic filesData = snapshot.data;
                      dynamic response = snapshot.data;
                      return response['success']==true ?
                      response['data']!=null && response['data'].length > 0 ?

                      ListView.builder(
                        itemCount: response['data'].length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
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
                              trailing: response['data'][index]["url"] == '-'
                                ? IconButton(
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      fileNotFoundDialogBox(context);
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.download,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      downloadFile(
                                        response['data'][index]["url"].toString(),
                                        response['data'][index]["filename"].toString()
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
                    child: AnimatedDotsLoader(text: "Loading", color: Theme.of(context).primaryColor));
                  // return connectedToWifi != true ? checkConnectionWidget(context) : snapshot.data == false ? Login() : HomePage();
                },
                ),
          ));
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  
  Future<void> downloadFile(String uri, String fileName) async {

    // Map<String, dynamic> result = {
    //   'isSuccess': false,
    //   'filePath': null,
    //   'error': null,
    // };
    
    setState(() {
      downloading = true;
    });

    CustomLoader.show(context,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor),
      loaderText:Text("\nDownloading File...",style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.center,));

    String savePath = await getFilePath(fileName);

    Dio dio = Dio();

    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        debugPrint('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

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
    ).then((_) async{
      setState(() {
        if (progress == '100') {
          isDownloaded = true;
        }

        downloading = false;
        CustomLoader.hide();
        dialogBoxForFileDownloadSuccess(context,'File Downloaded Successfully',savePath); 
      });

      // result['isSuccess'] = true;
      // result['filePath'] = savePath;
      // await _showNotification(result);
    }).catchError((error) async{

        // result['error'] = error.toString();
        CustomLoader.hide();
        dialogBoxForFailure(context,'Unable to download file','Please try again');
        // await _showNotification(result);
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

  // Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
  //   final android = AndroidNotificationDetails(
  //     'channel id',
  //     'channel name',
  //     priority: Priority.high,
  //     importance: Importance.max
  //   );
  //   // final iOS = IOSNotificationDetails();
  //   final platform = NotificationDetails(android: android);
  //   final json = jsonEncode(downloadStatus);
  //   final isSuccess = downloadStatus['isSuccess'];

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // notification id
  //     isSuccess ? 'Success' : 'Failure',
  //     isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
  //     platform,
  //     payload: json
  //   );
  // }

  // void _onSelectNotification(String json) {
  //   final obj = jsonDecode(json);

  //   if (obj['isSuccess']) {
  //     OpenFile.open(obj['filePath']);
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('${obj['error']}'),
  //       ),
  //     );
  //   }
  // }

    // List<DataRow> _tableRows(List data) {
  //   List<DataRow> newList = data.map((element) {
  //     return DataRow(
  //       cells: [DataCell(Text(element["filename"] as String)),
  //         DataCell(IconButton(icon: Icon(Icons.download,color: Colors.green,),
  //           onPressed: () async {
  //             //on click
  //             //url_launcher
  //             //response->download()
  //             downloadFile(element["url"].toString(),element["filename"].toString());
  //           },
  //         ),),
  //       ]
  //     );
  //   }).toList();
  //   return newList;
  // }

  // downloadFile(uri, fileName) async{

  //   String path = (await getExternalStorageDirectory())!.path;

  //   // Directory dir = await getApplicationDocumentsDirectory();
  //   final downloaderUtils = DownloaderUtils(
  //                 progressCallback: (current, total) {
  //                   final progress = (current / total) * 100;
  //                   debugPrint('Downloading: $progress');
  //                 },
  //                 file: File(path+'/'+fileName),
  //                 progress: ProgressImplementation(),
  //                 onDone: () => debugPrint('Download done'),
  //                 deleteOnCancel: true,
  //               );
                
  // final core = await Flowder.download(
  //                   uri,
  //                   downloaderUtils);
  // }

}
