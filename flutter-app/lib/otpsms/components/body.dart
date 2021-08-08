import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/constants.dart';
import 'package:pim/size_config.dart';

import 'otp_form.dart';

class Body extends StatelessWidget {
  String code;
  String number;
  Body({this.code, this.number});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                tr("PHONE Verification"),
                style: headingStyle,
              ),
              Text(tr("We sent your code to ") + this.number),
              buildTimer(),
              OtpForm(
                number: this.number,
                code: this.code,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // OTP code resend
                },
                child: Text(
                  tr("Resend verify Code"),
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tr("This code will expired in ")),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
