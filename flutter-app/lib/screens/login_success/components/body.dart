import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/components/default_button.dart';
import 'package:pim/screens/Home/homewithSlider.dart';
import 'package:pim/screens/Welcome/welcome_screen.dart';
import 'package:pim/screens/sign_in/sign_in_screen.dart';
import 'package:pim/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4,
          width: SizeConfig.screenWidth, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          tr("Login Success"),
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: tr("Back to initial screen"),
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
