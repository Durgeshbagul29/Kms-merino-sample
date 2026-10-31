// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/common/kaizen/common_kaizen_details.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

class UserKaizenDetails extends StatefulWidget {
  final int id;
  final Widget filename; // Kept for compatibility
  const UserKaizenDetails(this.id, this.filename, {super.key});
  @override
  State<UserKaizenDetails> createState() => _BNDetailsState();
}

class _BNDetailsState extends State<UserKaizenDetails> {
  late Future<dynamic> _kaizenDetailsFuture;

  @override
  void initState() {
    super.initState();
    _kaizenDetailsFuture = getUserKaizenDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Kaizen Details',
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            tooltip: 'Export to PDF',
            onPressed: () async {
              final networkManager = NetworkManager.instance;
              final isConnected = await networkManager.checkConnectivityAndShowError();
              if (!isConnected) return;
              generateKaizenPDF(context, widget.id);
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<dynamic>(
        future: _kaizenDetailsFuture,
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
            return CommonKaizenDetails(
              kaizenData: snapshot.data,
              title: 'Kaizen Details',
              roleId: 2, // User role ID
              kaizenId: widget.id,
              filename: widget.filename,
            );
          }

          return errorWidgetDesign(context, 'No data received');
        },
      ),
    );
  }
}
