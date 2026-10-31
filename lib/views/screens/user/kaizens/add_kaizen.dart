// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_viewkaizen.dart';
import 'package:path/path.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';
import 'package:kmsmerino/views/base/custom_snackbar.dart';
import 'package:kmsmerino/views/common/video_compressor.dart';

class AddKaizen extends StatefulWidget {
  final String type;
  const AddKaizen(this.type, {super.key});

  @override
  State<AddKaizen> createState() => _AddKaizenState();
}

class _AddKaizenState extends State<AddKaizen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String problem = '', description = '', solution = '', support = 'self', kaizenCost = '';
  int groupG = 1;
  File? _image;
  File? _video;
  bool _isPickingImage = false;
  bool _isPickingVideo = false;
  bool _isSubmitting = false;
  final picker = ImagePicker();

  // Helper function to get tenant base URL
  Future<String> getTenantBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tenantBaseUrl = prefs.getString('tenant_base_url');
    return tenantBaseUrl ?? ApiConfig.baseUrl;
  }

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
    setState(() {
      _isPickingImage = true;
    });
    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future getVideo(BuildContext context) async {
    setState(() {
      _isPickingVideo = true;
    });
    try {
      XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        File file = File(video.path);
        if (!await VideoCompressor.isSizeValid(file)) {
          showCustomSnackBar('Video size exceeds 50MB limit', isError: true);
          return;
        }
        setState(() {
          _video = file;
        });
      }
    } finally {
      setState(() {
        _isPickingVideo = false;
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
              'Add ${widget.type} Kaizen',
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
                    // Header section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                              Icons.auto_graph_outlined,
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
                                  '${widget.type} Kaizen',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Submit your improvement suggestions',
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
                      'Before Image (Optional)',
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
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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
                        child: _isPickingImage
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : _image == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                                      if (_isSubmitting)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
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
                                                color: Colors.black.withValues(alpha: 0.2),
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

                    SizedBox(height: 24),

                    // Before Video upload section
                    Text(
                      'Before Video (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        getVideo(context);
                      },
                      child: Container(
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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
                        child: _isPickingVideo
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Selecting video...',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _video == null
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.video_camera_back_outlined,
                                            size: 24,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Upload Video',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 120,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.movie_creation_outlined,
                                              color: Theme.of(context).primaryColor,
                                              size: 32,
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                basename(_video!.path),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_isSubmitting)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Uploading...',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.2),
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
                                              size: 18,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              setState(() {
                                                _video = null;
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

                    // Problem input field
                    Text(
                      'Problem Statement *',
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
                      minLines: 3,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Problem';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Describe the problem...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          problem = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Description input field
                    Text(
                      'Problem Description *',
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
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Provide detailed description...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Solution input field
                    Text(
                      'Proposed Solution *',
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
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Solution';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Describe your proposed solution...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          solution = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Cost Saving input field
                    Text(
                      'How much save annually?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the estimated annual savings';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Enter annual savings...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          kaizenCost = val;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // Submission Type selection
                    Text(
                      'Submission Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          width: 1,
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
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: groupG,
                            title: Text(
                              'Self Submission',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('I will implement this kaizen myself'),
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (val) {
                              setState(() {
                                groupG = 1;
                                support = 'self';
                              });
                            },
                          ),
                          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                          RadioListTile(
                            value: 2,
                            groupValue: groupG,
                            title: Text(
                              'With Support',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text('I need support to implement this kaizen'),
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (val) {
                              setState(() {
                                groupG = 2;
                                support = 'support';
                              });
                            },
                          ),
                        ],
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
                            final networkManager = NetworkManager.instance;
                            final isConnected = await networkManager.checkConnectivityAndShowError();
                            if (!isConnected) return;

                            if (_video != null) {
                              _video = await VideoCompressor.compressVideoWithLoader(context, _video);
                              if (_video == null) return;
                            }

                            setState(() => _isSubmitting = true);
                            CustomLoader.show(
                              context,
                              progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                              loaderText: Text("\nProcessing your request...", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none), textAlign: TextAlign.center),
                            );

                            final token = await LoggedInUser.getToken();
                            final userid = await LoggedInUser.getUserId();

                            if (_image != null) {
                              String ext = extension(_image!.path).toLowerCase();
                              if (ext == '.jpeg' || ext == '.jpg' || ext == '.png') {
                                uploadImage(context, token, userid, problem, description, solution, support, _image, _video, kaizenCost);
                              } else {
                                CustomLoader.hide();
                                setState(() => _isSubmitting = false);
                                dialogBoxForFailure(context, 'Invalid Image Type', 'Valid image types are: jpeg, jpg, png');
                              }
                            } else {
                              uploadImage(context, token, userid, problem, description, solution, support, _image, _video, kaizenCost);
                            }
                          }
                        },
                        child: Text(
                          'Submit Kaizen',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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

  void uploadImage(
    BuildContext context,
    String token,
    int user,
    String problemdata,
    String descdata,
    String soldata,
    String supportdata,
    File? imageFile,
    File? videoFile,
    String costdata,
  ) async {
    String baseUrl = await getTenantBaseUrl();
    var uri = Uri.parse("$baseUrl/api/add_kaizen_record");
    var request = http.MultipartRequest("POST", uri);

    if (imageFile != null) {
      try {
        var multipartFile = http.MultipartFile(
          "image",
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      } catch (e) {
        debugPrint('ERROR adding image: $e');
      }
    }

    if (videoFile != null) {
      try {
        var multipartFile = http.MultipartFile(
          "before_video",
          videoFile.readAsBytes().asStream(),
          videoFile.lengthSync(),
          filename: basename(videoFile.path),
        );
        request.files.add(multipartFile);
      } catch (e) {
        debugPrint('ERROR adding before video: $e');
      }
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['problem'] = problemdata;
    request.fields['description'] = descdata;
    request.fields['solution'] = soldata;
    request.fields['support'] = supportdata;
    request.fields['type'] = widget.type;
    request.fields['cost_savings'] = costdata;
    request.fields['user_id'] = user.toString();

    try {
      var respond = await request.send();
      final respStr = await respond.stream.bytesToString();
      debugPrint("add_kaizen_record statusCode: ${respond.statusCode}");
      debugPrint("add_kaizen_record response: $respStr");

      setState(() => _isSubmitting = false);
      CustomLoader.hide();

      dynamic jsonResponse;
      try {
        jsonResponse = json.decode(respStr);
      } catch (e) {
        debugPrint("Error decoding response JSON: $e");
      }

      if (respond.statusCode == 200 && jsonResponse is Map && jsonResponse['success'] == true) {
        final data = jsonResponse['data'];
        if (data is Map && data['is_duplicate'] == true) {
          _showDuplicateDialog(
            context,
            data['similar_kaizens'] as List? ?? [],
            problemdata,
            descdata,
            soldata,
            supportdata,
            imageFile,
            videoFile,
            costdata,
          );
        } else {
          VideoCompressor.cleanCache();
          dialogBoxForSuccess(context, 'Data Added Successfully', UserViewKaizens(widget.type));
        }
      } else {
        VideoCompressor.cleanCache();
        String errorMessage = 'Submission failed';
        if (jsonResponse is Map) {
          if (jsonResponse['message'] != null && jsonResponse['message'].toString().trim().isNotEmpty) {
            errorMessage = jsonResponse['message'].toString();
          } else if (jsonResponse['error'] != null && jsonResponse['error'].toString().trim().isNotEmpty) {
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
            } else if (jsonResponse['errors'] is List && (jsonResponse['errors'] as List).isNotEmpty) {
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
      debugPrint("Error submitting kaizen: $e");
      setState(() => _isSubmitting = false);
      CustomLoader.hide();
      dialogBoxForFailure(context, 'Network Error', 'Check your connection');
    }
  }

  void _showDuplicateDialog(
    BuildContext context,
    List similarKaizens,
    String problemdata,
    String descdata,
    String soldata,
    String supportdata,
    File? imageFile,
    File? videoFile,
    String costdata,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 20,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.80,
            ),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 42,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Title
                Text(
                  'Duplicate Kaizen Detected',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Subtitle
                Text(
                  'A similar kaizen already exists. Please review before submitting.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Similar kaizens list (scrollable)
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: similarKaizens.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final kaizen = similarKaizens[index];
                      final similarity = kaizen['similarity'] ?? '';
                      final status = kaizen['status'] ?? '';
                      final problem = kaizen['problem'] ?? '';
                      final description = kaizen['description'] ?? '';
                      final kaizenCode = kaizen['kaizen_code'] ?? '';

                      Color statusColor = Colors.grey;
                      if (status.toString().toLowerCase() == 'approved') {
                        statusColor = Colors.green;
                      } else if (status.toString().toLowerCase() == 'pending') {
                        statusColor = Colors.orange;
                      } else if (status.toString().toLowerCase() == 'rejected') {
                        statusColor = Colors.red;
                      }

                      return Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Code + similarity row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    kaizenCode,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$similarity match',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Problem
                            Text(
                              problem,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),

                            // Description
                            if (description.isNotEmpty)
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            SizedBox(height: 8),

                            // Status badge
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: statusColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Submit Anyway button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _forceSubmitKaizen(
                            context,
                            problemdata,
                            descdata,
                            soldata,
                            supportdata,
                            imageFile,
                            videoFile,
                            costdata,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Submit Anyway',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _forceSubmitKaizen(
    BuildContext context,
    String problemdata,
    String descdata,
    String soldata,
    String supportdata,
    File? imageFile,
    File? videoFile,
    String costdata,
  ) async {
    setState(() => _isSubmitting = true);
    CustomLoader.show(
      context,
      progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      loaderText: Text("\nSubmitting kaizen...", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none), textAlign: TextAlign.center),
    );

    final token = await LoggedInUser.getToken();
    final userid = await LoggedInUser.getUserId();
    String baseUrl = await getTenantBaseUrl();

    var uri = Uri.parse("$baseUrl/api/add_kaizen_record");
    var request = http.MultipartRequest("POST", uri);

    if (imageFile != null) {
      try {
        var multipartFile = http.MultipartFile("image", imageFile.readAsBytes().asStream(), imageFile.lengthSync(), filename: basename(imageFile.path));
        request.files.add(multipartFile);
      } catch (e) {
        debugPrint('Error attaching image: $e');
      }
    }
    if (videoFile != null) {
      try {
        var multipartFile = http.MultipartFile("before_video", videoFile.readAsBytes().asStream(), videoFile.lengthSync(), filename: basename(videoFile.path));
        request.files.add(multipartFile);
      } catch (e) {
        debugPrint('Error attaching video: $e');
      }
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['problem'] = problemdata;
    request.fields['description'] = descdata;
    request.fields['solution'] = soldata;
    request.fields['support'] = supportdata;
    request.fields['type'] = widget.type;
    request.fields['cost_savings'] = costdata;
    request.fields['user_id'] = userid.toString();
    request.fields['force_submit'] = 'true';

    try {
      var respond = await request.send();
      final respStr = await respond.stream.bytesToString();
      debugPrint("forceSubmit statusCode: ${respond.statusCode}");
      debugPrint("forceSubmit response: $respStr");

      setState(() => _isSubmitting = false);
      CustomLoader.hide();

      dynamic jsonResponse;
      try {
        jsonResponse = json.decode(respStr);
      } catch (e) {
        debugPrint("Error decoding response JSON: $e");
      }

      if (respond.statusCode == 200 && jsonResponse is Map && jsonResponse['success'] == true) {
        VideoCompressor.cleanCache();
        dialogBoxForSuccess(context, 'Data Added Successfully', UserViewKaizens(widget.type));
      } else {
        VideoCompressor.cleanCache();
        String errorMessage = 'Submission failed';
        if (jsonResponse is Map) {
          if (jsonResponse['message'] != null && jsonResponse['message'].toString().trim().isNotEmpty) {
            errorMessage = jsonResponse['message'].toString();
          } else if (jsonResponse['error'] != null && jsonResponse['error'].toString().trim().isNotEmpty) {
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
            } else if (jsonResponse['errors'] is List && (jsonResponse['errors'] as List).isNotEmpty) {
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
      debugPrint("Error force submitting kaizen: $e");
      VideoCompressor.cleanCache();
      setState(() => _isSubmitting = false);
      CustomLoader.hide();
      dialogBoxForFailure(
        context,
        'Network Error',
        'Failed to connect to server. Please check your internet connection.',
      );
    }
  }
}
