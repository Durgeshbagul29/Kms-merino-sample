// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path/path.dart';
import 'package:kmsmerino/views/screens/user/accident/user_accident.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

class AddAccident extends StatefulWidget {
  const AddAccident({super.key});

  @override
  State<AddAccident> createState() => _AddAccidentState();
}

class _AddAccidentState extends State<AddAccident>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String incident = '', action = '', analysis = '';
  File? _image;
  final picker = ImagePicker();

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

  Future getImage(BuildContext context) async {
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
        child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Add Accident Report',
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
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.2),
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
                              Icons.warning_amber_rounded,
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
                                  'Accident Report',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Please provide accurate details about the incident',
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
                    // Image upload section
                    Text(
                      'Attach Image (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        getImage(context);
                      },
                      child: Container(
                        height: 180.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _image == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to attach supporting evidence',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.2,
                                            ),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
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
                    ),

                    SizedBox(height: 20),

                    // Incident input field
                    Text(
                      'Incident Details *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      validator: (val) => val!.isEmpty
                          ? 'Please enter incident details'
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Describe the incident...',
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
                      onChanged: (val) {
                        setState(() {
                          incident = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Analysis input field
                    Text(
                      'Root Cause Analysis *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      validator: (val) => val!.isEmpty
                          ? 'Please enter root cause analysis'
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Analyze the root cause...',
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
                      onChanged: (val) {
                        setState(() {
                          analysis = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Action input field
                    Text(
                      'Corrective Action *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      validator: (val) => val!.isEmpty
                          ? 'Please enter corrective action'
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Describe the corrective action...',
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
                      onChanged: (val) {
                        setState(() {
                          action = val;
                        });
                      },
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
                            debugPrint("in add accident function");
                            // login(username,password);

                            final token = await LoggedInUser.getToken();
                            final userid = await LoggedInUser.getUserId();

                            if (_image != null) {
                              // String imagepath = _image.path;
                              // List<String> imgSplit = imagepath.split(".");
                              String ext = extension(_image!.path);
                              debugPrint(ext);

                              if (ext == '.jpeg' ||
                                  ext == '.jpg' ||
                                  ext == '.png') {
                                debugPrint("valid");
                                uploadImage(
                                  context,
                                  token,
                                  userid,
                                  incident,
                                  analysis,
                                  action,
                                  _image,
                                );
                              } else {
                                CustomLoader.hide();
                                debugPrint("Invalid Image Format");
                                dialogBoxForFailure(
                                  context,
                                  'Invalid Image Type',
                                  'Valid image types are: jpeg, jpg, png',
                                );
                              }
                            } else {
                              uploadImage(
                                context,
                                token,
                                userid,
                                incident,
                                analysis,
                                action,
                                _image,
                              );
                            }
                          } else {
                            CustomLoader.hide();
                            // dialogBoxForFailure(context,'Please fill valid details','');
                          }
                        },
                        child: Text(
                          'Submit Report',
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

  Future<void> uploadImage(
    BuildContext context,
    String token,
    int user,
    String incidentdata,
    String analysisdata,
    String actiondata,
    File? imageFile,
  ) async {
    var image = imageFile;
    var uri = Uri.parse("${ApiConfig.baseUrl}/api/add_accident_record");
    var request = http.MultipartRequest("POST", uri);

    if (image != null) {
      var multipartFile = http.MultipartFile(
        "image",
        File(image.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: basename(image.path),
      );
      request.files.add(multipartFile);
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['incident'] = incidentdata;
    request.fields['analysis'] = analysisdata;
    request.fields['action'] = actiondata;
    request.fields['user_id'] = user.toString();

    try {
      var respond = await request.send();
      final respStr = await respond.stream.bytesToString();
      CustomLoader.hide();

      dynamic jsonResponse;
      try {
        jsonResponse = json.decode(respStr);
      } catch (e) {
        debugPrint("Error decoding JSON: $e");
      }

      if (respond.statusCode == 200 &&
          (jsonResponse is! Map || jsonResponse['success'] != false)) {
        debugPrint("Image Uploaded");
        debugPrint(respStr.toString());
        dialogBoxForSuccess(
          context,
          'Data Added Successfully',
          NavigateToUserAccidents(),
        );
      } else {
        debugPrint("Upload Failed: ${respond.statusCode}");
        debugPrint(respStr.toString());
        String errorMessage = 'Submission failed';
        if (jsonResponse is Map) {
          if (jsonResponse['message'] != null &&
              jsonResponse['message'].toString().trim().isNotEmpty) {
            errorMessage = jsonResponse['message'].toString();
          } else if (jsonResponse['error'] != null &&
              jsonResponse['error'].toString().trim().isNotEmpty) {
            errorMessage = jsonResponse['error'].toString();
          } else if (jsonResponse['errors'] != null) {
            if (jsonResponse['errors'] is Map) {
              final errorsMap = jsonResponse['errors'] as Map;
              final firstVal = errorsMap.values.firstOrNull;
              if (firstVal is List && firstVal.isNotEmpty) {
                errorMessage = firstVal.first.toString();
              } else if (firstVal != null) {
                errorMessage = firstVal.toString();
              }
            } else if (jsonResponse['errors'] is List &&
                (jsonResponse['errors'] as List).isNotEmpty) {
              errorMessage = (jsonResponse['errors'] as List).first.toString();
            } else {
              errorMessage = jsonResponse['errors'].toString();
            }
          }
        } else if (respStr.trim().isNotEmpty && respStr.length < 200) {
          errorMessage = respStr.trim();
        }

        String dialogTitle = 'Notice';
        if (errorMessage.toLowerCase().contains('limit')) {
          dialogTitle = 'Limit Reached';
        }

        dialogBoxForFailure(
          context,
          errorMessage,
          '',
          title: dialogTitle,
        );
      }
    } catch (e) {
      CustomLoader.hide();
      debugPrint("Error uploading accident: $e");
      dialogBoxForFailure(
        context,
        'Network Error',
        'Please check your internet connection.',
      );
    }
  }
}

class BackNavigationWidget extends StatelessWidget {
  const BackNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
    return Scaffold();
  }
}

class NavigateToUserAccidents extends StatelessWidget {
  const NavigateToUserAccidents({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserAccidents()),
      );
    });
    return Scaffold();
  }
}
