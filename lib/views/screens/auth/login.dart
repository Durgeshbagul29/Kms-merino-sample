import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:kmsmerino/models/response_model.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';

import 'package:kmsmerino/utils/common_toast.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/helper/route_helper.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String username = '';
  String password = '';
  String error = '';
  DateTime? _lastPressedAt;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth > 600 ? screenWidth * 0.55 : screenWidth;

    // Light theme color palette
    const Color primaryBlue = Color(0xFF2563EB);
    const Color softGrey = Color(0xFFF8FAFF);
    const Color labelColor = Color(0xFF374151);
    const Color hintColor = Color(0xFF9CA3AF);
    const Color borderColor = Color(0xFFE5E7EB);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final now = DateTime.now();
        final bool isKeyboardVisible =
            MediaQuery.of(context).viewInsets.bottom > 0;

        if (isKeyboardVisible) {
          FocusScope.of(context).unfocus();
          return;
        }

        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          CommonToast.info('Double tap again to exit app', title: 'Exit KMSMerino', duration: const Duration(seconds: 2));
          return;
        }

        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEFF6FF),
                    Color(0xFFF8FAFF),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.07),

                        //  Header Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // Logo with soft glow ring
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: primaryBlue.withValues(alpha: 0.12),
                                    width: 2.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(43),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                "Kaizen Management",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF1E3A5F),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Sign in to your account",
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        //  Login Card
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: cardWidth,
                                margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth > 600 ? 0 : 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withValues(alpha: 0.07),
                                      blurRadius: 40,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 12),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: GetBuilder<AuthController>(
                                  builder: (authController) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth > 600 ? 40 : 24,
                                        vertical: 30,
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            // Section label
                                            const Text(
                                              'Welcome back',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1E3A5F),
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Enter your credentials to continue',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: hintColor,
                                              ),
                                            ),

                                            const SizedBox(height: 22),

                                            //  Username Field
                                            _buildLabel('Username', labelColor),
                                            const SizedBox(height: 7),
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF1E3A5F),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              validator: (val) => val!.isEmpty
                                                  ? 'Please enter username'
                                                  : null,
                                              decoration: _buildInputDecoration(
                                                hintText: 'Enter your username',
                                                prefixIcon: Icons
                                                    .person_outline_rounded,
                                                primaryColor: primaryBlue,
                                                hintColor: hintColor,
                                                borderColor: borderColor,
                                                fillColor: softGrey,
                                              ),
                                              onChanged: (val) {
                                                setState(() => username = val);
                                              },
                                            ),

                                            const SizedBox(height: 18),

                                            //  Password Field
                                            _buildLabel('Password', labelColor),
                                            const SizedBox(height: 7),
                                            TextFormField(
                                              obscureText: _obscureText,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF1E3A5F),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              validator: (val) =>
                                                  val!.length < 6
                                                  ? 'Password must be at least 6 characters'
                                                  : null,
                                              decoration:
                                                  _buildInputDecoration(
                                                    hintText:
                                                        'Enter your password',
                                                    prefixIcon: Icons
                                                        .lock_outline_rounded,
                                                    primaryColor: primaryBlue,
                                                    hintColor: hintColor,
                                                    borderColor: borderColor,
                                                    fillColor: softGrey,
                                                  ).copyWith(
                                                    suffixIcon: GestureDetector(
                                                      onTap: _toggle,
                                                      child: AnimatedSwitcher(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 200,
                                                            ),
                                                        child: Icon(
                                                          _obscureText
                                                              ? Icons
                                                                    .visibility_outlined
                                                              : Icons
                                                                    .visibility_off_outlined,
                                                          key: ValueKey(
                                                            _obscureText,
                                                          ),
                                                          color: _obscureText
                                                              ? hintColor
                                                              : primaryBlue,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              onChanged: (val) {
                                                setState(() => password = val);
                                              },
                                            ),

                                            const SizedBox(height: 26),

                                            //  Login Button
                                            SizedBox(
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    final networkManager =
                                                        NetworkManager.instance;
                                                    final isConnected =
                                                        await networkManager
                                                            .checkConnectivityAndShowError();

                                                    if (!isConnected) return;

                                                    CustomLoader.show(
                                                      context,
                                                      progressIndicator:
                                                          CircularProgressIndicator(
                                                            backgroundColor:
                                                                Theme.of(
                                                                  context,
                                                                ).primaryColor,
                                                          ),
                                                      loaderText: const Text(
                                                        "\nAuthenticating...",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                    debugPrint(
                                                      "in Login function",
                                                    );

                                                    ResponseModel
                                                    responseModel =
                                                        await authController
                                                            .login(
                                                              username,
                                                              password,
                                                            );

                                                    if (responseModel
                                                        .isSuccess) {
                                                      int? roleId =
                                                          await LoggedInUser.getUserRoleId();
                                                      int? status =
                                                          await LoggedInUser.getStatus();

                                                      if (status == 1) {
                                                        if (roleId == null ||
                                                            roleId <= 0) {
                                                          CustomLoader.hide();
                                                          setState(
                                                            () => error =
                                                                "Invalid user role. Please contact administrator.",
                                                          );
                                                          return;
                                                        }

                                                        List<int>
                                                        supportedRoles = [
                                                          1,
                                                          2,
                                                          3,
                                                          4,
                                                          5,
                                                        ];
                                                        if (!supportedRoles
                                                            .contains(roleId)) {
                                                          CustomLoader.hide();
                                                          setState(
                                                            () => error =
                                                                "Unsupported user role ($roleId). Please contact administrator.",
                                                          );
                                                          return;
                                                        }

                                                        CommonToast.success('Logged in successfully. Welcome!', title: 'Login Successful');
                                                        CustomLoader.hide();
                                                        await Future.delayed(
                                                          const Duration(
                                                            milliseconds: 100,
                                                          ),
                                                        );

                                                        if (roleId == 1) {
                                                          Get.offAllNamed(
                                                            RouteHelper
                                                                .adminMain,
                                                          );
                                                        } else if (roleId ==
                                                            2) {
                                                          Get.offAllNamed(
                                                            RouteHelper.hrMain,
                                                          );
                                                        } else if (roleId ==
                                                            3) {
                                                          Get.offAllNamed(
                                                            RouteHelper
                                                                .userMain,
                                                          );
                                                        } else if (roleId ==
                                                            4) {
                                                          Get.offAllNamed(
                                                            RouteHelper
                                                                .directorMain,
                                                          );
                                                        } else if (roleId ==
                                                            5) {
                                                          Get.offAllNamed(
                                                            RouteHelper
                                                                .managerMain,
                                                          );
                                                        }
                                                      } else {
                                                        CustomLoader.hide();
                                                        setState(
                                                          () => error =
                                                              "Account deactivated. Please contact the administrator for assistance.",
                                                        );
                                                      }
                                                    } else {
                                                      CustomLoader.hide();
                                                      String displayError =
                                                          responseModel.message;
                                                      if (displayError
                                                          .toLowerCase()
                                                          .contains(
                                                            'unauthori',
                                                          )) {
                                                        displayError =
                                                            'Account not found or invalid credentials. Please check your username/email and password.';
                                                      }
                                                      setState(
                                                        () => error =
                                                            displayError,
                                                      );
                                                      CommonToast.error(displayError, title: 'Login Failed');
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryBlue,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.4,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //  Error Message
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              transitionBuilder:
                                                  (
                                                    Widget child,
                                                    Animation<double> animation,
                                                  ) {
                                                    return SizeTransition(
                                                      sizeFactor: animation,
                                                      axisAlignment: -1.0,
                                                      child: child,
                                                    );
                                                  },
                                              child: error.isNotEmpty
                                                  ? Column(
                                                      key: ValueKey(error),
                                                      children: [
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 14,
                                                                vertical: 12,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFFFF1F2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            border: Border.all(
                                                              color:
                                                                  const Color(
                                                                    0xFFFECACA,
                                                                  ),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .error_outline_rounded,
                                                                color: Color(
                                                                  0xFFEF4444,
                                                                ),
                                                                size: 18,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  error,
                                                                  style: const TextStyle(
                                                                    color: Color(
                                                                      0xFFDC2626,
                                                                    ),
                                                                    fontSize:
                                                                        12.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.3,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                '© 2025 Kaizen Management System. All rights reserved.',
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'A product by Abracadabra Software Solutions',
                                style: TextStyle(
                                  color: const Color(0xFF2563EB),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required Color primaryColor,
    required Color hintColor,
    required Color borderColor,
    required Color fillColor,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor, fontSize: 13.5),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Icon(
          prefixIcon,
          color: primaryColor.withValues(alpha: 0.7),
          size: 19,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: borderColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: primaryColor, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.6),
      ),
      errorStyle: const TextStyle(fontSize: 11.5, color: Color(0xFFEF4444)),
    );
  }
}
