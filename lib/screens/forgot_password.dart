import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:parking_management/screens/components/authentication_widget.dart';
import 'package:parking_management/screens/verify_code.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);
    return AuthenticationMasterPage(
      title: "forgot password",
      subTitle: "enter your email to get verification code",
      child: FormBuilder(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text(
              "forgot password",
              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0.h),

            // Email
            FormBuilderTextField(
              name: "email",
              decoration: InputDecoration(
                labelText: "example@gmail.com",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.h)),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            SizedBox(height: 25.0.h),

            // Login Button

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(66, 122, 154, 1),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  final data = _formKey.currentState!.value;
                  final email = _formKey.currentState!.fields['email']!.value;
                  try{
                  final response = await http.post(
                      Uri.parse(dotenv.env['backend_url'].toString() +
                          r'/send_password_reset_email_phone'),
                      body: {"email": email});
                  if (response.statusCode == 200) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationScreen()));
                  } else {
                    AwesomeDialog(
                      context: context,
                      title: "error",
                      dialogType: DialogType.error,
                      desc:
                          json.decode(response.body)['error'],
                      animType: AnimType.topSlide,
                      btnOk: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("ok")),
                    ).show();
                  }
                  }
                  catch(exception){
                    AwesomeDialog(
                      context: context,
                      title: "error",
                      dialogType: DialogType.error,
                      desc:
                          "There was an unexpected error, please check your internet connection.",
                      animType: AnimType.topSlide,
                      btnOk: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("ok")),
                    ).show();

                  }
                  // Perform login here
                } else {
                  debugPrint("Validation failed");
                }
              },
              child: const Text("send code",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            SizedBox(height: 25.0.h),
          ])),
    );
  }
}
