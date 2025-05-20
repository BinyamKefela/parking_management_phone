import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parking_management/logic/authentication.dart';
import 'package:parking_management/screens/login_screen.dart';
import 'package:parking_management/screens/verify_code.dart';
import 'package:parking_management/screens/zone_details.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      padding: EdgeInsets.zero,
                      child: Ink(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sign up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30)),
                          Text("Sign up to get started",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form
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
                            const Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.0.h),
                            // Email
                            FormBuilderTextField(
                              name: "email",
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 224, 233, 243),
                                    ),
                                  ),
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    color:
                                        Colors.grey, // Change label text color
                                    fontSize: 16,
                                  ),
                                  fillColor:
                                      const Color.fromARGB(255, 224, 233, 243),
                                  labelText: "example@gmail.com",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            SizedBox(height: 15.0.h),
                            const Text(
                              "phone number",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.0.h),
                            // Phone (Country Code + Phone)
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FormBuilderDropdown<String>(
                                    name: 'country_code',
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 224, 233, 243),
                                          ),
                                        ),
                                        filled: true,
                                        labelStyle: const TextStyle(
                                          color: Colors
                                              .grey, // Change label text color
                                          fontSize: 16,
                                        ),
                                        fillColor: const Color.fromARGB(
                                            255, 224, 233, 243),
                                        labelText: "code",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never),
                                    initialValue: '+251',
                                    items: [
                                      {'code': '+251', 'name': 'Ethiopia'},
                                      {'code': '+1', 'name': 'USA'},
                                      {'code': '+91', 'name': 'India'},
                                      {'code': '+44', 'name': 'UK'},
                                    ]
                                        .map((country) => DropdownMenuItem(
                                              value: country['code'],
                                              child: Text(country['code']!),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  flex: 7,
                                  child: FormBuilderTextField(
                                    name: 'phone_number',
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 224, 233, 243),
                                        ),
                                      ),
                                      filled: true,
                                      labelStyle: const TextStyle(
                                        color: Colors
                                            .grey, // Change label text color
                                        fontSize: 16,
                                      ),
                                      fillColor: const Color.fromARGB(
                                          255, 224, 233, 243),
                                      labelText: "phone number",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                    ),
                                    validator: FormBuilderValidators.required(),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0.h),
                            const Text(
                              "password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.0.h),
                            // Password
                            FormBuilderTextField(
                              name: "password",
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                                labelText: "password",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                              ]),
                            ),
                            SizedBox(height: 15.0.h),
                            const Text(
                              "confirm password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.0.h),
                            // Confirm Password
                            FormBuilderTextField(
                              name: "confirm_password",
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      )),
                                  labelText: "Confirm Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 224, 233, 243),
                                    ),
                                  ),
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    color:
                                        Colors.grey, // Change label text color
                                    fontSize: 16,
                                  ),
                                  fillColor:
                                      const Color.fromARGB(255, 224, 233, 243),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                              validator: (val) {
                                final pass = _formKey
                                    .currentState?.fields['password']?.value;
                                if (val == null || val.isEmpty)
                                  return 'Confirm your password';
                                if (val != pass)
                                  return 'Passwords do not match';
                                return null;
                              },
                            ),
                            SizedBox(height: 25.0.h),

                            // Submit Button

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

                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Remove extra tap padding
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final data = _formKey.currentState?.value;
                                  final email = _formKey
                                      .currentState?.fields['email']!.value;
                                  final password = _formKey
                                      .currentState?.fields['password']!.value;
                                  try {
                                    final response =
                                        await signUp(email, password);
                                    if (response.statusCode == 201) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   LoginScreen(message:"check your email to verify your account before login")));
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        title: "message",
                                        desc:
                                            json.decode(response.body)['error'],
                                        btnOk: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("ok")),
                                        animType: AnimType.topSlide,
                                      ).show();
                                    }
                                  } catch (exception) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      title: "message",
                                      desc:
                                          "There was an error, please check your internet connection",
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("ok")),
                                      animType: AnimType.topSlide,
                                    ).show();
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                  //Future response = http.
                                  debugPrint("Login data: $data");
                                  // Perform login here
                                } else {
                                  debugPrint("Validation failed");
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background.png'),
                                    fit: BoxFit.fill,
                                    // Use fill to ensure no gaps
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
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
                                          "submit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
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
            ],
          ),
        ));
  }
}
