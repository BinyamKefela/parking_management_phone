import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:parking_management/screens/forgot_password.dart';
import 'package:parking_management/screens/map_screen.dart';
import 'package:parking_management/screens/zone_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'register_screen.dart'; // Ensure this import matches your file structure

class LoginScreen extends StatefulWidget {
  String? message;
  LoginScreen({super.key, this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);

    return Scaffold(
        backgroundColor: const Color.fromRGBO(66, 122, 154, 1),
        body: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit
                        .cover, // Changed from fill to cover for better aspect ratio
                    alignment: Alignment.center,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      Text("sign in to your account!",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
              ),

              // Form Card
              Expanded(
                child: Card(
                  elevation: 20,
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30.0.w),
                    child: SafeArea(
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(widget.message ?? ""),
                            SizedBox(height: 20.0.h),
                            const Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),

                            // Email
                            FormBuilderTextField(
                              name: "email",
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 224, 233, 243),
                                  ),
                                ),
                                filled: true,
                                labelStyle: const TextStyle(
                                  color: Colors.grey, // Change label text color
                                  fontSize: 16,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 224, 233, 243),
                                labelText: "Email",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.h)),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            SizedBox(height: 15.0.h),
                            const Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),

                            // Password
                            FormBuilderTextField(
                              name: "password",
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 224, 233, 243),
                                  ),
                                ),
                                filled: true,
                                labelStyle: const TextStyle(
                                  color: Colors.grey, // Change label text color
                                  fontSize: 16,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 224, 233, 243),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: "Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    )),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.h)),
                              ),
                              validator: FormBuilderValidators.required(),
                            ),
                            SizedBox(height: 15.0.h),

                            // Remember me and forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      onChanged: (val) => setState(
                                          () => rememberMe = val ?? false),
                                    ),
                                    const Text("Remember Me"),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordScreen()));
                                  },
                                  child: const Text("Forgot Password?"),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0.h),

                            // Login Button
                            // Login Button - Corrected Version
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Make button transparent
                                shadowColor:
                                    Colors.transparent, // Remove default shadow
                                padding:
                                    EdgeInsets.zero, // Remove default padding
                                minimumSize: Size(double.infinity,
                                    50.h), // Full width and responsive height
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0)),
                                ),
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Remove extra tap padding
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final data = _formKey.currentState!.value;
                                  String email = _formKey
                                      .currentState!.fields['email']!.value;
                                  String password = _formKey
                                      .currentState!.fields['password']!.value;
                                  try {
                                    final response = await http.post(
                                        Uri.parse(dotenv.env['backend_url']!
                                                .toString() +
                                            r"/api/token"),
                                        body: {
                                          'email': email,
                                          'password': password
                                        });
                                    if (response.statusCode == 200) {
                                      print(response.body);
                                      final responseData =
                                          json.decode(response.body);
                                      final access_token =
                                          responseData['access'];
                                      final refresh_token =
                                          responseData['refresh'];

                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool("is_logged_in", true);
                                      await prefs.setString(
                                          'access_token', access_token);
                                      await prefs.setString(
                                          'refresh_token', refresh_token);

                                      print("after login " +
                                          prefs.getString('access_token')!);

                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MapScreen()));
                                    } else {
                                      final responseData =
                                          json.decode(response.body);
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.topSlide,
                                              title: "login failed",
                                              desc: "invalid credentials",
                                              btnCancel: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("cancel")))
                                          .show();
                                    }
                                  } catch (exception) {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.topSlide,
                                            title: "unknown error",
                                            desc: exception.toString(),
                                            btnOkText: "ok",
                                            btnCancelText: "no",
                                            btnCancel: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("cancel")))
                                        .show();
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }

                                  debugPrint("Login data: $data");
                                  // Perform login here
                                } else {
                                  debugPrint("Validation failed");
                                }
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background.png'),
                                    fit: BoxFit
                                        .fill, // Use fill to ensure no gaps
                                  ),
                                ),
                                child: _isLoading
                                    ? Container(
                                        constraints:
                                            BoxConstraints(minHeight: 50.h),
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : Container(
                                        constraints: BoxConstraints(
                                          minHeight: 50.h, // Responsive height
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                              ),
                            ),

                            SizedBox(height: 25.0.h),

                            // Sign up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don’t have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
