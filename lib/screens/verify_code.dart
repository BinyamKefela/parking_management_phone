import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parking_management/screens/components/authentication_widget.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendCooldown = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCooldown() {
    _resendCooldown = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCooldown--;
        });
      }
    });
  }

  void _submitCode() {
    final code = _controllers.map((e) => e.text).join();
    if (code.length == 4) {
      debugPrint("Verification Code Entered: $code");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code Submitted: $code")),
      );
    }
  }

  Widget _buildDigitBox(int index) {
    return SizedBox(
      width: 55.w,
      height: 60.h,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color.fromARGB(255, 224, 233, 243),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
              _submitCode();
            }
          } else if (index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);
    return AuthenticationMasterPage(
      title: "verification",
      subTitle: "we have sent  verification code to example@gmail.com",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Email Verification",
            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0.h),

          // Code input boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, _buildDigitBox),
          ),
          SizedBox(height: 25.0.h),

          // Resend code
          TextButton(
            onPressed: _resendCooldown == 0
                ? () {
                    debugPrint("Resend Code Clicked");
                    _startResendCooldown();
                  }
                : null,
            child: Text(
              _resendCooldown == 0
                  ? "Resend Code"
                  : "Resend in $_resendCooldown sec",
              style: TextStyle(
                color: _resendCooldown == 0 ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15.0.h),

          // Submit button (optional if user waits for auto-submit)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(66, 122, 154, 1),
              padding: EdgeInsets.symmetric(vertical: 14.0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: _submitCode,
            child: const Text("Verify",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 25.0.h),
        ],
      ),
    );
  }
}
