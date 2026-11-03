// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path/path.dart';

class ManagerAddBroadcast extends StatefulWidget {
  const ManagerAddBroadcast({super.key});

  @override
  State<ManagerAddBroadcast> createState() => _ManagerAddBroadcastState();
}

class _ManagerAddBroadcastState extends State<ManagerAddBroadcast>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String title = '', message = '';
  File? _image;
  final picker = ImagePicker();
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

  Future getImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            'Create Broadcast',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  // Header Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
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
                            Icons.campaign,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Create a new broadcast message for your team',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  // Image Upload Section
                  Text(
                    'Image (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 10),

                  _image == null
                      ? GestureDetector(
                          onTap: getImage,
                          child: Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40,
                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tap to browse your device',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: 180.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  SizedBox(height: 25),

                  // Title Field
                  Text(
                    'Title*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a title' : null,
                    decoration: _inputDecoration(context, 'Enter broadcast title'),
                    onChanged: (val) => setState(() => title = val),
                  ),

                  SizedBox(height: 20),

                  // Message Field
                  Text(
                    'Message*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a message' : null,
                    decoration: _inputDecoration(context, 'Enter broadcast message'),
                    onChanged: (val) => setState(() => message = val),
                  ),

                  SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          CustomLoader.show(
                            context,
                            progressIndicator: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            loaderText: Text(
                              '\nSending broadcast...',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );

                          final token = await LoggedInUser.getToken();
                          final managerId = await LoggedInUser.getUserId();

                          if (_image != null) {
                            String ext = extension(_image!.path).toLowerCase();
                            if (ext == '.jpeg' ||
                                ext == '.jpg' ||
                                ext == '.png') {
                              _uploadBroadcast(
                                context,
                                token,
                                managerId,
                                title,
                                message,
                                _image,
                              );
                            } else {
                              CustomLoader.hide();
                              dialogBoxForFailure(
                                context,
                                'Invalid Image Type',
                                'Valid types are: jpeg, jpg, png',
                              );
                            }
                          } else {
                            _uploadBroadcast(
                              context,
                              token,
                              managerId,
                              title,
                              message,
                              null,
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Send Broadcast',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      labelText: hint,
      labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1),
      ),
    );
  }

  Future<void> _uploadBroadcast(
    BuildContext context,
    String token,
    int managerId,
    String title,
    String msg,
    File? imageFile,
  ) async {
    var uri = Uri.parse(ApiConfig.addManagerBroadcastUrl);
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['message'] = msg;
    request.fields['manager_id'] = managerId.toString();

    if (imageFile != null) {
      var multipartFile = http.MultipartFile(
        'image',
        File(imageFile.path).readAsBytes().asStream(),
        File(imageFile.path).lengthSync(),
        filename: basename(imageFile.path),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      CustomLoader.hide();
      if (response.statusCode == 200) {
        debugPrint('Broadcast sent: $respStr');
        // Return true to signal the list should refresh
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Broadcast sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        debugPrint('Broadcast failed: $respStr');
        dialogBoxForFailure(context, 'Something Went Wrong', 'Data Not Added');
      }
    } catch (e) {
      CustomLoader.hide();
      debugPrint('Error sending broadcast: $e');
      dialogBoxForFailure(context, 'Error', e.toString());
    }
  }
}
