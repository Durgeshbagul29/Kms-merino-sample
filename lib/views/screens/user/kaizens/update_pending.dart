// ignore_for_file: prefer_const_constructors, prefer_final_fields

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
import 'package:photo_view/photo_view.dart';

class UpdatePendingKaizen extends StatefulWidget {
  final int dataid, support, subcategoryid;
  final String problem, description, solution, beforeimg;
  final Widget filename;
  const UpdatePendingKaizen(
    this.dataid,
    this.support,
    this.subcategoryid,
    this.problem,
    this.description,
    this.solution,
    this.beforeimg,
    this.filename, {
    super.key,
  });

  @override
  State<UpdatePendingKaizen> createState() => _UpdatePendingKaizenState();
}

class _UpdatePendingKaizenState extends State<UpdatePendingKaizen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String problem = '', description = '', solution = '', support = 'self';
  int groupG = 1;
  // File _image = File('assets/placeholder.jpg');
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    if (widget.support == 0) {
      support = 'self';
      groupG = 1;
    } else {
      support = 'support';
      groupG = 2;
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future getImage(BuildContext context) async {
    // PickedFile image = await picker.getImage(source: ImageSource.gallery);
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
              'Update Pending Kaizen',
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
                              Icons.edit_outlined,
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
                                  'Update Kaizen',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Modify your submitted kaizen suggestion',
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

                    // Before Image section
                    widget.beforeimg != '-'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Before Image',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  dialogTriggerForImgView(
                                    context,
                                    widget.beforeimg,
                                  );
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
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          widget.beforeimg,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 180,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  height: 180,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    height: 180,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                        : SizedBox(height: 1),

                    // New Image upload section
                    Text(
                      'Replace Image (Optional)',
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
                                      'Upload New Image',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to replace current image',
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
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
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
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
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        initialValue: widget.problem,
                        onChanged: (val) {
                          setState(() {
                            problem = val;
                          });
                        },
                      ),
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
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
                          hintText:
                              'Provide detailed description of the problem...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
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
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        initialValue: widget.description,
                        onChanged: (val) {
                          setState(() {
                            description = val;
                          });
                        },
                      ),
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
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
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
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
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        initialValue: widget.solution,
                        onChanged: (val) {
                          setState(() {
                            solution = val;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // Support selection
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
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
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
                      child: RadioGroup<int>(
                        groupValue: groupG,
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              groupG = value;
                              support = value == 1 ? 'self' : 'support';
                            });
                          }
                        },
                        child: Column(
                          children: [
                            RadioListTile(
                              value: 1,
                              title: Text(
                                'Self Submission',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'I will implement this kaizen myself',
                              ),
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[200],
                            ),
                            RadioListTile(
                              value: 2,
                              title: Text(
                                'With Support',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'I need support to implement this kaizen',
                              ),
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
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
                            debugPrint("in update function");

                            final token = await LoggedInUser.getToken();
                            final userid = await LoggedInUser.getUserId();

                            if (_image != null) {
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
                                  (problem.isEmpty) ? widget.problem : problem,
                                  (description.isEmpty)
                                      ? widget.description
                                      : description,
                                  (solution.isEmpty)
                                      ? widget.solution
                                      : solution,
                                  support,
                                  widget.subcategoryid,
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
                                (problem.isEmpty) ? widget.problem : problem,
                                (description.isEmpty)
                                    ? widget.description
                                    : description,
                                (solution.isEmpty) ? widget.solution : solution,
                                support,
                                widget.subcategoryid,
                                _image,
                              );
                            }
                          } else {
                            CustomLoader.hide();
                          }
                        },
                        child: Text(
                          'Update Kaizen',
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

  void dialogTriggerForImgView(BuildContext context, String imgurl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              // Centered image viewer
              Center(
                child: Container(
                  constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: PhotoView(
                    imageProvider: NetworkImage(imgurl),
                    backgroundDecoration: BoxDecoration(color: Colors.black),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    errorBuilder: (context, error, stackTrace) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Image could not be loaded',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned close button at top right corner
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadImage(
    BuildContext context,
    String token,
    int user,
    String problemdata,
    String descdata,
    String soldata,
    String supportdata,
    int subcategoryid,
    File? imageFile,
  ) async {
    var image = imageFile;

    var uri = Uri.parse(ApiConfig.updatePendingKaizenUrl);

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

    request.fields['problem'] = problemdata;
    request.fields['description'] = descdata;
    request.fields['solution'] = soldata;
    request.fields['support'] = supportdata;
    request.fields['subcategoryid'] = subcategoryid.toString();
    request.fields['id'] = widget.dataid.toString();
    request.fields['user_id'] = user.toString();

    var respond = await request.send();
    final respStr = await respond.stream.bytesToString();
    if (respond.statusCode == 200) {
      CustomLoader.hide();
      debugPrint("Image Uploaded");
      debugPrint(respStr.toString());
      dialogBoxForSuccess(
        context,
        'Data Updated Successfully',
        UserSubmittedKaizens(),
      );
    } else {
      CustomLoader.hide();
      debugPrint("Upload Failed");
      debugPrint(respStr.toString());
      CustomLoader.hide();
      dialogBoxForFailure(context, 'Something Went Wrong', 'Data Not Added');
    }
  }
}
