import 'package:flutter/material.dart';
import 'package:pim/components/default_button.dart';
import 'package:pim/screens/login_success/login_success_screen.dart';
import 'package:pim/size_config.dart';
import 'package:pim/module/services.dart';
import 'package:pim/screens/complete_profile/complete_profile_screen.dart';
import '../../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pim/screens/sign_in/components/custom_dialog.dart';

class OtpForm extends StatefulWidget {
  String code;
  String number;
  OtpForm({this.code, this.number});
  @override
  _OtpFormState createState() =>
      _OtpFormState(number: this.number, code: this.code);
}

class _OtpFormState extends State<OtpForm> {
  String code;
  String number;
  _OtpFormState({this.code, this.number});
  var _you = "0000";
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                    _you = _you.replaceFirst(RegExp('0'), value, 0);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin3FocusNode);
                    _you = _you.replaceFirst(RegExp('0'), value, 1);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                    focusNode: pin3FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      nextField(value, pin4FocusNode);
                      _you = _you.replaceFirst(RegExp('0'), value, 2);
                    }),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      _you = _you.replaceFirst(RegExp('0'), value, 3);
                      pin4FocusNode.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: tr("Continue"),
            press: () {
              if (_you == code) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSuccessScreen()));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialog(
                    title: tr("sign up failed"),
                    description: tr("Incorrect code"),
                    primaryButtonText: tr("bouttondialog"),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
