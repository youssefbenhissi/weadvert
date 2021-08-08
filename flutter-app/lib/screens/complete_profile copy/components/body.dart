import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pim/constants.dart';
import 'package:pim/size_config.dart';

import 'complete_profile_form.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  String email;
  Body(this.email);
  //SharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController controller = TextEditingController();
    String initialCountry = 'TN';
    PhoneNumber number = PhoneNumber(isoCode: 'TN');
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(tr("Complete Profile"), style: headingStyle),
                Text(
                  tr("Complete your details"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompleteProfileForm(email: this.email),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  tr("By continuing"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
