// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/auth/authenticate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(""),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.clear();
              // LoggedInUser.setLoggedInStatus(false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>Authenticate()));
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Wrong User',),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
