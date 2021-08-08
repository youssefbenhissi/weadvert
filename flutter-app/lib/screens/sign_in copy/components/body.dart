import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:pim/components/no_account_text.dart';
import 'package:pim/components/socal_card.dart';
import 'package:pim/constants.dart';
import 'package:pim/screens/sign_up copy/sign_up_screen.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  tr("title"),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tr("Sign in with your"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                // SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        InkWell(
                          child: Image.asset(
                            "assets/icons/uk.png",
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          ),
                          onTap: () => context.locale =
                              EasyLocalization.of(context).supportedLocales[0],
                        ),
                        SizedBox(width: SizeConfig.screenWidth * .20),
                        InkWell(
                          child: Image.asset(
                            "assets/icons/fr.png",
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          ),
                          onTap: () => context.locale =
                              EasyLocalization.of(context).supportedLocales[1],
                        ),
                        Spacer(),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr("Don’t have an account? "),
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          ),
          child: Text(
            tr("Sign Up"),
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
