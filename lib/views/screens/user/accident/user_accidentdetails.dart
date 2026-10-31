// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

import '../../../common/accident/accident_details_content.dart';

class UserAccidentDetails extends StatefulWidget {
  final int id;
  final Widget filename; // Kept for compatibility with other parts of the app
  const UserAccidentDetails(this.id, this.filename, {super.key});
  @override
  State<UserAccidentDetails> createState() => _BNDetailsState();
}

class _BNDetailsState extends State<UserAccidentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Accident Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<dynamic>(
        future: getUserAccidentDetails(widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return errorWidgetDesign(context, snapshot.error.toString());
          }

          if (snapshot.hasData) {
            final responseFrmUrl = snapshot.data;
            if (responseFrmUrl['success'] == true &&
                responseFrmUrl['data'] != null) {
              return AccidentDetailsContent(
                responseFrmUrl: responseFrmUrl,
                context: context,
              );
            } else {
              return errorWidgetDesign(
                context,
                responseFrmUrl['message'] ?? 'Failed to load data',
              );
            }
          }

          return errorWidgetDesign(context, 'No data received');
        },
      ),
    );
  }
}
