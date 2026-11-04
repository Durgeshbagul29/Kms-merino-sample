import 'dart:convert';
// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/views/screens/admin/notifications/notitication.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path/path.dart';


class AddBroadcast extends StatefulWidget {

  const AddBroadcast({super.key});

  @override
  State<AddBroadcast> createState() => _AddBroadcastState();
}

class _AddBroadcastState extends State<AddBroadcast> with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  String title='',message='';
  // File _image = File('assets/placeholder.jpg');
  File? _image;
  final picker = ImagePicker();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future getImage(BuildContext context) async {
      // PickedFile image = await picker.getImage(source: ImageSource.gallery);
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1920,
        maxHeight: 1920,
      );
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
            onPressed: () => Navigator.of(context).pop()),
        ),
        body:
          Container(
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
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create a new broadcast message for all users',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
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
                        ? Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to browse your device',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      getImage(context);
                                    },
                                    child: Text(
                                      'Choose Image',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: 180.0,
                                    child: (_image != null)
                                        ? Image.file(
                                            _image!,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            "assets/placeholder.jpg",
                                            fit: BoxFit.contain,
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
                      validator: (val) => val!.isEmpty ? 'Please enter title' : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        labelText: 'Enter broadcast title',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
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
                          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          title = val;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),

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
                      validator: (val) => val!.isEmpty ? 'Please enter message' : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        labelText: 'Enter broadcast message',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
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
                          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          message = val;
                        });
                      },
                    ),

                    SizedBox(height: 30.0),

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
                            CustomLoader.show(context,
                                progressIndicator: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
                                loaderText: Text("\nSending broadcast...", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none), textAlign: TextAlign.center));
                            
                            final token = await LoggedInUser.getToken();
                            final adminid = await LoggedInUser.getUserId();

                            if(_image != null){
                              String ext = extension(_image!.path);
                              debugPrint(ext);

                              if(ext == '.jpeg' || ext == '.jpg' || ext == '.png'){
                                debugPrint("valid");
                                uploadImage(context,token,adminid,title,message,_image);
                              }else{
                                CustomLoader.hide();
                                debugPrint("Invalid Image Format");
                                dialogBoxForFailure(context,'Invalid Image Type','Valid image types are: jpeg, jpg, png');
                              }
                            }else{
                              uploadImage(context,token,adminid,title,message,_image);
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              size: 18,
                              color: Colors.white,
                            ),
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
                  ],
                ),
              ),
            ),
          ),

      ),
    );
  }

  Future<void> uploadImage(BuildContext context, String token, int admin, String title, String msg, File? imageFile) async {
    try {
      var image = imageFile;
      var uri = Uri.parse(ApiConfig.addBroadcastUrl);
      var request = http.MultipartRequest("POST", uri);

      if (image != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          "image",
          image.path,
          filename: basename(image.path),
        );
        request.files.add(multipartFile);
      }

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['title'] = title;
      request.fields['message'] = msg;
      request.fields['admin_id'] = admin.toString();

      var respond = await request.send().timeout(const Duration(seconds: 45));
      final respStr = await respond.stream.bytesToString();
      CustomLoader.hide();

      if (respond.statusCode == 200) {
        debugPrint("Image Uploaded");
        debugPrint(respStr.toString());
        dynamic decoded;
        try {
          decoded = json.decode(respStr);
        } catch (_) {}

        if (decoded is Map && decoded['success'] == false) {
          String msg = decoded['message']?.toString() ?? 'Failed to add broadcast';
          if (context.mounted) {
            dialogBoxForFailure(context, msg, '', title: 'Broadcast Notice');
          }
        } else {
          if (context.mounted) {
            dialogBoxForSuccess(context, 'Data Added Successfully', AdminNotification());
          }
        }
      } else {
        debugPrint("Upload Failed: ${respond.statusCode}");
        debugPrint(respStr.toString());
        String failureTitle = 'Notice';
        String failureMessage = 'Server returned status ${respond.statusCode}';
        try {
          final decoded = json.decode(respStr);
          if (decoded is Map) {
            if (decoded['message'] != null && decoded['message'].toString().trim().isNotEmpty) {
              failureMessage = decoded['message'].toString().trim();
            } else if (decoded['data'] != null && decoded['data']['error'] != null) {
              failureMessage = decoded['data']['error'].toString().trim();
            }
          }
        } catch (_) {}

        if (failureMessage.toLowerCase().contains('limit')) {
          failureTitle = 'Broadcast Limit';
        }

        if (context.mounted) {
          dialogBoxForFailure(context, failureMessage, '', title: failureTitle);
        }
      }
    } catch (e) {
      CustomLoader.hide();
      debugPrint("Upload Exception: $e");
      if (context.mounted) {
        dialogBoxForFailure(
          context,
          'Upload Failed',
          'Could not upload broadcast. Please check image size or internet connection.',
        );
      }
    }
  }
}
