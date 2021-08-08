import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  String email;
  OtpScreen({this.email});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("OTP Verification")),
      ),
      body: Body(email: this.email),
    );
  }
}
