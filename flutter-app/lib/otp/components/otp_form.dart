import 'package:flutter/material.dart';
import 'package:pim/components/default_button.dart';
import 'package:pim/size_config.dart';
import 'package:pim/module/services.dart';
import 'package:pim/screens/complete_profile copy/complete_profile_screen.dart';
import '../../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pim/screens/sign_in/components/custom_dialog.dart';

class OtpForm extends StatefulWidget {
  String email;
  OtpForm({this.email});
  @override
  _OtpFormState createState() => _OtpFormState(email: this.email);
}

class _OtpFormState extends State<OtpForm> {
  String email;
  _OtpFormState({this.email});
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
                    //_you[0] = value;
                    //_you = _you + value;
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
                      //print(value);
                      _you = _you.replaceFirst(RegExp('0'), value, 3);
                      pin4FocusNode.unfocus();
                      // Then you need to check is the code is correct or not
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
              print("wwaaaaaa" + _you);
              service().verifyUser(email, _you).then((newSms) {
                if (newSms.statusCode == 202) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: tr("sign up failed"),
                      description: tr("email is already used"),
                      primaryButtonText: tr("bouttondialog"),
                    ),
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompleteProfileScreen(email)));
                }
              });
            },
          )
        ],
      ),
    );
  }
}
