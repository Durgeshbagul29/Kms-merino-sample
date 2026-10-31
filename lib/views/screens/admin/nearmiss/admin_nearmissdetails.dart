// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import '../../../common/nearmiss/nearmiss_details_content.dart';

class AdminNearmissDetails extends StatefulWidget {
  final int id;
  const AdminNearmissDetails(this.id, {super.key});
  @override
  State<AdminNearmissDetails> createState() => _BNDetailsState();
}

class _BNDetailsState extends State<AdminNearmissDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Nearmiss Details',
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
        future: getAdminNearmissDetails(widget.id),
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
              return NearmissDetailsContent(
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
