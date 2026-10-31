// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';

class ChangePassword extends StatefulWidget {
  final String username;
  final int dataid, roleid;
  final Widget filename;
  const ChangePassword(this.username, this.dataid, this.roleid, this.filename,
      {super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true, _obscureText1 = true;
  String password = '', cpassword = '';
  String? _passwordError;
  String? _cPasswordError;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.forward();
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return PopScope(
        canPop: true,
        child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Change Password',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.lock,
                            size: 35,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enter your new password below',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Form Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username Field
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor),
                              ),
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 15),
                              border: InputBorder.none,
                            ),
                            initialValue: widget.username,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // New Password Field
                        Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _passwordError != null
                                  ? Colors.red
                                  : Colors.grey[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                setState(() => _passwordError = 'Password is required');
                                return '';
                              } else if (val.length < 8) {
                                setState(() => _passwordError = 'Password must be at least 8 characters');
                                return '';
                              }
                              setState(() => _passwordError = null);
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              hintText: 'Enter new password',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 15),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor),
                              ),
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility_outlined,
                                        color: Colors.grey[600])
                                    : Icon(Icons.visibility_off_outlined,
                                        color: Theme.of(context).primaryColor),
                                onPressed: _toggle,
                                padding: EdgeInsets.all(12),
                              ),
                              border: InputBorder.none,
                              errorStyle: TextStyle(height: 0, fontSize: 0),
                            ),
                            obscureText: _obscureText,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                                _passwordError = null;
                              });
                            },
                          ),
                        ),
                        if (_passwordError != null) ...[  
                          SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              _passwordError!,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 20),
                        
                        // Confirm Password Field
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _cPasswordError != null
                                  ? Colors.red
                                  : Colors.grey[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                setState(() => _cPasswordError = 'Confirm password is required');
                                return '';
                              } else if (val.length < 8) {
                                setState(() => _cPasswordError = 'Password must be at least 8 characters');
                                return '';
                              } else if (val != password) {
                                setState(() => _cPasswordError = 'Passwords do not match');
                                return '';
                              }
                              setState(() => _cPasswordError = null);
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              hintText: 'Confirm new password',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 15),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor),
                              ),
                              suffixIcon: IconButton(
                                icon: _obscureText1
                                    ? Icon(Icons.visibility_outlined,
                                        color: Colors.grey[600])
                                    : Icon(Icons.visibility_off_outlined,
                                        color: Theme.of(context).primaryColor),
                                onPressed: _toggle1,
                                padding: EdgeInsets.all(12),
                              ),
                              border: InputBorder.none,
                              errorStyle: TextStyle(height: 0, fontSize: 0),
                            ),
                            obscureText: _obscureText1,
                            onChanged: (val) {
                              setState(() {
                                cpassword = val;
                                _cPasswordError = null;
                              });
                            },
                          ),
                        ),
                        if (_cPasswordError != null) ...[  
                          SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              _cPasswordError!,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 30),
                        
                        // Change Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              CustomLoader.show(context,
                                  progressIndicator: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  loaderText: Text(
                                    "\nProcessing Your Request...",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none),
                                    textAlign: TextAlign.center,
                                  ));
                              if (_formKey.currentState!.validate()) {
                                if (kDebugMode) {
                                  debugPrint("in change_password function");
                                }
                                
                                final token = await LoggedInUser.getToken();

                                final response = await post(
                                  Uri.parse(
                                      "${ApiConfig.baseUrl}/api/change_password"),
                                  headers: {
                                    "Accept": "application/json",
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  },
                                  body: json.encode({
                                    'userid': widget.dataid,
                                    'password': password,
                                    'cpassword': cpassword,
                                  }),
                                );
                                if (kDebugMode) {
                                  debugPrint(response.body.toString());
                                }

                                var responsebody = json.decode(response.body);
                                if (kDebugMode) {
                                  debugPrint("\n Response from api:\n$responsebody");
                                }
                                if (responsebody['success'] == true) {
                                  CustomLoader.hide();
                                  dialogBoxForSuccess(context,
                                      'Password Changed Successfully',
                                      widget.filename);
                                  if (kDebugMode) {
                                    debugPrint("password changed");
                                  }
                                } else {
                                  CustomLoader.hide();
                                  dialogBoxForFailure(context,
                                      'Something Went Wrong', 'Please Try Again');
                                  if (kDebugMode) {
                                    debugPrint("password not changed");
                                  }
                                }
                              } else {
                                CustomLoader.hide();
                              }
                            },
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
