import 'package:flutter/material.dart';
import 'package:pim/size_config.dart';

import 'components/body.dart';

class OtpScreensms extends StatelessWidget {
  static String routeName = "/otp";
  String code;
  String number;
  OtpScreensms({this.code, this.number});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(number: this.number, code: this.code),
    );
  }
}
