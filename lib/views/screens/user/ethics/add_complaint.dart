// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/user/user_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

class AddComplaint extends StatefulWidget {
  const AddComplaint({super.key});

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String complaint = '';
  TextEditingController _complaint = TextEditingController();

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
        child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Add Complaint',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Header section with icon and title
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.report_problem_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Report a Complaint',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Please provide detailed information about your complaint',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Complaint input field
                    Text(
                      'Complaint Details *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _complaint,
                      validator: (val) =>
                          val!.isEmpty ? 'Please Enter Complaint' : null,
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 6,
                      onChanged: (String value) {
                        complaint = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Describe your complaint in detail...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        errorMaxLines: 3,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Check network connectivity before proceeding
                            final networkManager = NetworkManager.instance;
                            final isConnected = await networkManager.checkConnectivityAndShowError();

                            if (!isConnected) {
                              return; // Don't proceed with submission if offline
                            }

                            CustomLoader.show(
                              context,
                              progressIndicator: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              loaderText: Text(
                                "\nProcessing your request...",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                            debugPrint("in add_complaint form function");

                            if (complaint.isEmpty) {
                              CustomLoader.hide();
                              dialogBoxForFailure(
                                context,
                                'Please Fill All Fields',
                                '',
                              );
                            } else {
                              final token = await LoggedInUser.getToken();
                              final adminid = await LoggedInUser.getUserId();

                              final response = await post(
                                Uri.parse(
                                  "${ApiConfig.baseUrl}/api/add_user_complaint",
                                ),
                                headers: {
                                  "Accept": "application/json",
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $token',
                                },
                                body: json.encode({
                                  'userid': adminid,
                                  'complaint': complaint,
                                }),
                              );
                              debugPrint(response.body.toString());

                              var responsebody = json.decode(response.body);
                              debugPrint(
                                "\n Response from api:\n$responsebody",
                              );
                              if (responsebody['success'] == true) {
                                CustomLoader.hide();
                                dialogBoxForSuccess(
                                  context,
                                  'Complaint Added Successfully',
                                  UserBottomNavigation(initialIndex: 1),
                                );
                                debugPrint("complaint added");
                              } else {
                                CustomLoader.hide();
                                dialogBoxForFailure(
                                  context,
                                  'Something Went Wrong',
                                  'Please Try Again',
                                );
                                debugPrint("complaint not added");
                              }
                            }
                          } else {
                            CustomLoader.hide();
                          }
                        },
                        child: Text(
                          'Submit Complaint',
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
          ),
        ),
      ),
    );
  }
}
