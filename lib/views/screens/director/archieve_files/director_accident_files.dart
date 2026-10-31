// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/base/textfeild_designs.dart';
import 'package:kmsmerino/views/screens/director/archieve_files/director_archive_screen.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';

class DirectorAccidentArchieve extends StatefulWidget {
  const DirectorAccidentArchieve({super.key});

  @override
  State<DirectorAccidentArchieve> createState() => _DirectorAccidentArchieveState();
}

class _DirectorAccidentArchieveState extends State<DirectorAccidentArchieve>
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
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Accident Archives'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DirectorArchiveScreen()),
          ),
        ),
      ),
      body: PaddingWidget(
        FutureBuilder<dynamic>(
          future: getDirectorAccidents(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? response['data'] != null
                        ? response['data'].length != 0
                            ? ListView.builder(
                                itemCount: response['data'].length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GFCard(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 4,
                                    ),
                                    margin: EdgeInsets.only(bottom: 10),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            headingText(
                                              response['data'][index]['username'],
                                            ),
                                            Spacer(),
                                            subHeadingText(
                                              response['data'][index]["sys_date"],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Divider(
                                          height: 2,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(height: 5),
                                        descText(
                                          response['data'][index]["incident"],
                                        ),
                                        SizedBox(height: 5),
                                        statusText(
                                          'Closed',
                                          GFColors.SUCCESS,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : dataNotAvailableWidgetDesign(context)
                        : dataNotAvailableWidgetDesign(context)
                    : dataNotAvailableWidgetDesign(context);
              }
            }
            return Center(
              child: GFLoader(),
            );
          },
        ),
      ),
    );
  }
}