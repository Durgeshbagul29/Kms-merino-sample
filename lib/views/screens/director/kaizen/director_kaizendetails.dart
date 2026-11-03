import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/common/kaizen/common_kaizen_details.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/base/error_message.dart';

class DirectorKaizenDetails extends StatefulWidget {
  final int id;
  final Widget filename;
  const DirectorKaizenDetails(this.id, this.filename, {super.key});
  @override
  State<DirectorKaizenDetails> createState() => _BNDetailsState();
}

class _BNDetailsState extends State<DirectorKaizenDetails>
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
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Kaizen Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
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
        ),
        body: FutureBuilder<dynamic>(
          future: () async {
            final directorId = await LoggedInUser.getUserId();
            return getDirectorKaizenDetails(widget.id, directorId);
          }(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                return CommonKaizenDetails(
                  kaizenData: snapshot.data,
                  title: 'Kaizen Details',
                );
              }
            }
            return Center(child: GFLoader());
          },
        ),
      ),
    );
  }
}
