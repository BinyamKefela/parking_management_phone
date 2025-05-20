import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AuthenticationMasterPage extends StatelessWidget {
  final Widget child;
  final String title;
  final String subTitle;

  const AuthenticationMasterPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);

    return  Scaffold(
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
                     Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title,
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 30)),
                          Text(subTitle,
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 15)),
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
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));

  }
}
