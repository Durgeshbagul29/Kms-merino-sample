// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/screens/hr/hr_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/hr/hr_functions.dart';

class AddNewUser extends StatefulWidget {
  // List<String> depts;

  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true, _obscureText1 = true;
  String password = '', cpassword = '';
  String username = '',
      empname = '',
      email = '',
      dept = '',
      dept1 = '',
      mobile = '',
      type = 'User';
  int groupG = 1;
  int selectedDeptId = 0; // Store selected department ID

  // Controllers for form fields to prevent cursor jumping
  late TextEditingController _usernameController;
  late TextEditingController _empnameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  List<Map<String, dynamic>> departments = []; // Store departments from API
  List<String> deptNames = [
    'Select Department',
  ]; // Store department names for dropdown

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);

    // Initialize controllers with current values
    _usernameController = TextEditingController(text: username);
    _empnameController = TextEditingController(text: empname);
    _emailController = TextEditingController(text: email);
    _mobileController = TextEditingController(text: mobile);

    super.initState();
    dept = deptNames[0];
    _loadDepartments();
    // getDepts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _empnameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Method to reset all form fields
  void _resetForm() {
    setState(() {
      username = '';
      empname = '';
      email = '';
      dept = deptNames[0];
      dept1 = '';
      mobile = '';
      password = '';
      cpassword = '';
      selectedDeptId = 0;
      groupG = 1;
      type = 'User';
      _obscureText = true;
      _obscureText1 = true;
    });

    // Clear all text controllers
    _usernameController.clear();
    _empnameController.clear();
    _emailController.clear();
    _mobileController.clear();
  }

  // Future<String> getDepts() async {
  //   final token = await LoggedInUser.getToken();
  //   final response= await get(
  //     Uri.parse("${ApiConfig.baseUrl}/api/get_depts"),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       'Authorization' : 'Bearer '+token,
  //     },
  //   );
  //   var responsebody = json.decode(response.body);

  //   setState(() {
  //     //deptList.add({'id':50,'name':'Select Department'});
  //     // deptList.add('Select Department');
  //     deptList = responsebody['data'];
  //    // dept = 'Select Department';
  //     dept = responsebody['data'][0]['name'];
  //     // dept = responsebody['data'][0]['name'];
  //     // responsebody['data'].forEach((element) {
  //     //   deptList.add(element['name']);
  //     // });
  //     // dept = deptList[0];
  //   });

  //   debugPrint(responsebody['data']);

  //   return "Sucess";
  // }

  // List<DropdownMenuItem<String>> getDropDownMenuItems() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String d in widget.depts) {
  //   //   items.add(DropdownMenuItem(value: d, child: Text(d)));
  //   }
  //   return items;
  // }

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

  void changedDropDownItem(String? selectedValue) {
    setState(() {
      dept = selectedValue ?? '';
      dept1 = selectedValue ?? '';

      // Find the corresponding department ID
      if (selectedValue != null && selectedValue != 'Select Department') {
        try {
          Map<String, dynamic> selectedDept = departments.firstWhere(
            (d) => d['name'] == selectedValue,
          );
          selectedDeptId = selectedDept['id'];
        } catch (e) {
          selectedDeptId = 0;
          debugPrint('Department not found: $selectedValue');
        }
      } else {
        selectedDeptId = 0;
      }
    });
  }

  Future<void> _loadDepartments() async {
    try {
      List<Map<String, dynamic>> depts = await getAllDepartments();
      debugPrint('Loaded departments: $depts'); // Debug line
      setState(() {
        departments = depts;
        deptNames = ['Select Department'];
        for (var dept in departments) {
          deptNames.add(dept['name']);
        }
        debugPrint('Department names: $deptNames'); // Debug line
      });
    } catch (e) {
      debugPrint('Error loading departments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Add New Member',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        //   onPressed: () => Navigator.pop(context)),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header section with icon and title
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fill in the details below to create a new account',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Member Type Selection
                Text(
                  'Member Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade50,
                  ),
                  child: RadioGroup<int>(
                    groupValue: groupG,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          groupG = value;
                          type = value == 1
                              ? 'User'
                              : (value == 2 ? 'Admin' : 'Manager');
                        });
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RadioListTile<int>(
                                value: 1,
                                title: Text(
                                  'User',
                                  style: TextStyle(
                                    color: groupG == 1
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.blue.shade100,
                            ),
                            Expanded(
                              child: RadioListTile<int>(
                                value: 2,
                                title: Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: groupG == 2
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RadioListTile<int>(
                                value: 4,
                                title: Text(
                                  'Manager',
                                  style: TextStyle(
                                    color: groupG == 4
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Form fields
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Username*',
                  hintText: 'Enter username',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    RegExp nameRegex = RegExp(r'^[a-zA-Z0-9]*$');
                    if (value!.isEmpty) {
                      return "UserName can't be empty.";
                    } else if (value.length < 2) {
                      return "UserName must be more than one character.";
                    } else if (!nameRegex.hasMatch(value)) {
                      return "Please Enter Characters and Numbers Only";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (val) {
                    setState(() {
                      username = val;
                      _usernameController.text = val;
                    });
                  },
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: _empnameController,
                  labelText: 'Employee Name*',
                  hintText: 'Enter employee name',
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Employee Name can't be empty.";
                    } else if (value.length < 2) {
                      return "Employee Name must be more than one character.";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onChanged: (val) {
                    setState(() {
                      empname = val;
                      _empnameController.text = val;
                    });
                  },
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter email address',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value);
                      if (!emailValid) {
                        return "Please enter valid email";
                      } else {
                        return null;
                      }
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                      _emailController.text = val;
                    });
                  },
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: _mobileController,
                  labelText: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length != 10) {
                      return "Mobile number must have 10 digits.";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    setState(() {
                      mobile = val;
                      _mobileController.text = val;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Department Dropdown
                Text(
                  'Department*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: dept.isEmpty ? 'Select Department' : dept,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red.shade300,
                        width: 2,
                      ),
                    ),
                  ),
                  items: deptNames.map<DropdownMenuItem<String>>((
                    String items,
                  ) {
                    return DropdownMenuItem<String>(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontFamily: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.fontFamily,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    changedDropDownItem(newValue);
                  },
                  validator: (value) {
                    if (value == null || value == 'Select Department') {
                      return 'Please select a department';
                    }
                    return null;
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).primaryColor,
                  ),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontFamily,
                  ),
                  dropdownColor: Colors.white,
                ),
                SizedBox(height: 16),

                _buildPasswordField(
                  labelText: 'Password*',
                  hintText: 'Enter password',
                  obscureText: _obscureText,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password is required';
                    } else if (val.length < 6) {
                      return 'Enter password of atleast 6 characters';
                    }
                    return null;
                  },
                  onToggle: _toggle,
                  onChanged: (val) => setState(() => password = val),
                ),
                SizedBox(height: 16),

                _buildPasswordField(
                  labelText: 'Confirm Password*',
                  hintText: 'Re-enter password',
                  obscureText: _obscureText1,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Confirm Password is required';
                    } else if (val.length < 6) {
                      return 'Enter password of atleast 6 characters';
                    }
                    return null;
                  },
                  onToggle: _toggle1,
                  onChanged: (val) => setState(() => cpassword = val),
                ),
                SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        CustomLoader.show(
                          context,
                          progressIndicator: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          loaderText: Text(
                            "\nAdding new user/admin...",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                        debugPrint("in change_password function");

                        debugPrint("department: $dept");
                        debugPrint("dept1: $dept1");
                        debugPrint("type: $type");
                        // login(username,password);

                        final token = await LoggedInUser.getToken();
                        final hrId = await LoggedInUser.getUserId();

                        if (password == cpassword) {
                          // Debug information
                          debugPrint('=== DEBUG INFO ===');
                          debugPrint('Selected Department: $dept');
                          debugPrint('Selected Department ID: $selectedDeptId');
                          debugPrint(
                            'Department List Length: ${departments.length}',
                          );
                          debugPrint('Department Names: $deptNames');
                          debugPrint('==================');

                          final response = await post(
                            Uri.parse("${ApiConfig.baseUrl}/api/add_new_useroradmin"),
                            headers: {
                              "Accept": "application/json",
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              'user': type,
                              'username': username,
                              'empname': empname,
                              'mobile': mobile,
                              'email': email,
                              'password': password,
                              'cpassword': cpassword,
                              'department_id': selectedDeptId == 0
                                  ? ''
                                  : selectedDeptId.toString(),
                              'hr_id': hrId,
                            }),
                          );
                          debugPrint(response.body.toString());

                          var responsebody = json.decode(response.body);
                          // var responsebody = response.body;
                          debugPrint(
                            "\n Response from api:\n$responsebody",
                          );
                          if (responsebody['success'] == true) {
                            CustomLoader.hide();
                            // Show success dialog and then pop back to HR bottom navigation
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 20,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: EdgeInsets.all(25),
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
                                        // Success icon
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.withValues(alpha: 0.15,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // Title
                                        Text(
                                          "Success!",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        // Content
                                        Text(
                                          '$type Added Successfully',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 25),
                                        // OK Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Close the dialog and navigate to HR dashboard
                                              Navigator.pop(
                                                context,
                                              ); // Close dialog
                                              // Reset the form before navigating away
                                              _resetForm();
                                              // Navigate back to the HR bottom navigation to show the bottom bar
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    // Get HR name from logged-in user
                                                    return FutureBuilder<
                                                      String
                                                    >(
                                                      future:
                                                          LoggedInUser.getName(),
                                                      builder: (context, snapshot) {
                                                        // String hrName =
                                                        //     snapshot.data ??
                                                        //     "HR";
                                                        return HrBottomNavigation();
                                                      },
                                                    );
                                                  },
                                                ),
                                                (Route<dynamic> route) =>
                                                    false, // Remove all previous routes
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            debugPrint("user/admin added successfully");
                          } else {
                            CustomLoader.hide();

                            // Extract error message from API response
                            String errorMessage = 'Something went wrong';
                            String errorDetails = '';

                            if (responsebody['message'] != null) {
                              errorMessage = responsebody['message'];
                            }

                            // Check for validation errors in data field
                            if (responsebody['data'] != null) {
                              if (responsebody['data'] is Map) {
                                Map<String, dynamic> errorData =
                                    responsebody['data'];
                                List<String> errorMessages = [];

                                errorData.forEach((field, errors) {
                                  if (errors is List) {
                                    errorMessages.addAll(
                                      errors
                                          .map((error) => '$field: $error')
                                          .toList(),
                                    );
                                  } else if (errors is String) {
                                    errorMessages.add('$field: $errors');
                                  }
                                });

                                if (errorMessages.isNotEmpty) {
                                  errorDetails = errorMessages.join('\n');
                                }
                              }
                            }

                            dialogBoxForFailure(
                              context,
                              errorMessage,
                              errorDetails.isEmpty
                                  ? 'Please check your input and try again.'
                                  : errorDetails,
                            );
                            debugPrint(
                              "API returned error: ${responsebody.toString()}",
                            );
                          }
                        } else {
                          CustomLoader.hide();
                          dialogBoxForFailure(
                            context,
                            'Password and Confirm Password Must Be Same',
                            '',
                          );
                        }
                      } else {
                        CustomLoader.hide();
                        // dialogBoxForFailure(context,'Please fill valid details','');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Add $type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade300, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Helper method to build password fields
  Widget _buildPasswordField({
    required String labelText,
    required String hintText,
    required bool obscureText,
    required String? Function(String?) validator,
    required Function() onToggle,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onToggle,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade300, width: 2),
            ),
          ),
          obscureText: obscureText,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
