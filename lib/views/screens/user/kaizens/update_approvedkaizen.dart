// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_submittedkaizens.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:kmsmerino/views/base/custom_snackbar.dart';
import 'package:kmsmerino/views/common/video_compressor.dart';

class UpdateApprovedKaizen extends StatefulWidget {
  final int dataid, subcategoryid;
  final Widget filename;
  const UpdateApprovedKaizen(this.dataid, this.subcategoryid, this.filename, {super.key});

  @override
  State<UpdateApprovedKaizen> createState() => _UpdateApprovedKaizenState();
}

class _UpdateApprovedKaizenState extends State<UpdateApprovedKaizen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String improvement = '';
  File? _image;
  File? _video;
  bool _isPickingImage = false;
  bool _isPickingVideo = false;
  final picker = ImagePicker();

  // Helper function to get tenant base URL
  Future<String> getTenantBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tenantBaseUrl = prefs.getString('tenant_base_url');
    return tenantBaseUrl ?? ApiConfig.baseUrl;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
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
              'Update Kaizen',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
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
                              Icons.update_outlined,
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
                                  'Update Approved Kaizen',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Provide improvement details and upload supporting evidence',
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

                    Text(
                      'After Image (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => getImage(context),
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
                          ? Center(child: CircularProgressIndicator())
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
                                      'Tap to attach after implementation image',
                                      style: TextStyle(
                                        fontSize: 13,
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
                                      child: Image.file(_image!, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => setState(() => _image = null),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // After Video Upload Section
                    Text(
                      'After Video (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => getVideo(context),
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
                          ? Center(child: CircularProgressIndicator())
                          : _video == null
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.video_camera_back_outlined, color: Theme.of(context).primaryColor),
                                    SizedBox(width: 8),
                                    Text(
                                      'Upload After Video',
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
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.movie_creation_outlined, color: Theme.of(context).primaryColor, size: 30),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            basename(_video!.path),
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => setState(() => _video = null),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Improvements*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        validator: (val) => val!.isEmpty ? 'Please Enter Improvements' : null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'Describe the improvements made...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => setState(() => improvement = val),
                      ),
                    ),

                    SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()){
                            if (_video != null) {
                              _video = await VideoCompressor.compressVideoWithLoader(context, _video);
                              if (_video == null) return;
                            }
                            CustomLoader.show(context,
                              progressIndicator: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
                              loaderText: Text("\nProcessing your request...", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none), textAlign: TextAlign.center));

                            final token = await LoggedInUser.getToken();
                            final userid = await LoggedInUser.getUserId();

                            if (!mounted) return;
                            if(_image != null){
                              String ext = extension(_image!.path).toLowerCase();
                              if(ext == '.jpeg' || ext == '.jpg' || ext == '.png'){
                                uploadImage(context, token, userid, improvement, _image, _video);
                              } else {
                                CustomLoader.hide();
                                dialogBoxForFailure(context, 'Invalid Image Type', 'Valid image types are: jpeg, jpg, png');
                              }
                            } else {
                              uploadImage(context, token, userid, improvement, _image, _video);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: Text(
                          'Submit Update',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  void uploadImage(BuildContext context, String token, int user, String improvedata, File? imageFile, File? videoFile) async {
    String baseUrl = await getTenantBaseUrl();
    var uri = Uri.parse("$baseUrl/api/update_approved_kaizen");
    var request = http.MultipartRequest("POST", uri);

    if (imageFile != null) {
      var multipartFile = http.MultipartFile("image", imageFile.readAsBytes().asStream(), imageFile.lengthSync(), filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    if (videoFile != null) {
      var multipartFile = http.MultipartFile("after_video", videoFile.readAsBytes().asStream(), videoFile.lengthSync(), filename: basename(videoFile.path));
      request.files.add(multipartFile);
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['improvement'] = improvedata;
    request.fields['subcategoryid'] = widget.subcategoryid.toString();
    request.fields['id'] = widget.dataid.toString();
    request.fields['user_id'] = user.toString();

    try {
      var respond = await request.send();
      final respStr = await respond.stream.bytesToString();
      CustomLoader.hide();
      if (respond.statusCode == 200) {
        var jsonResponse = json.decode(respStr);
        if (!mounted) return;
        VideoCompressor.cleanCache();
        if (jsonResponse['success'] == true) {
          dialogBoxForSuccess(context, 'Data Updated Successfully', UserSubmittedKaizens());
        } else {
          dialogBoxForFailure(context, 'Update Failed', jsonResponse['message'] ?? 'Data Not Added');
        }
      } else {
        if (!mounted) return;
        VideoCompressor.cleanCache();
        dialogBoxForFailure(context, 'Something Went Wrong', 'Error code: ${respond.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      VideoCompressor.cleanCache();
      CustomLoader.hide();
      dialogBoxForFailure(context, 'Network Error', 'Check your connection');
    }
  }
}
