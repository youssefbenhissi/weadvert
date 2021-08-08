import 'package:flutter/material.dart';

import 'package:pim/size_config.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const kCardInfoBG = Color(0XFF686868);
const kBlack = Color(0xFF21202A);
const kBlackAccent = Color(0xFF3A3A3A);
const kSilver = Color(0xFFF6F6F6);
const kOrange = Color(0xFFFA5805);
const kBackgroundColor = Color(0XFFE5E5E5);
const kRatingStarColor = Color(0XFFF4D150);
var kPageTitleStyle = GoogleFonts.questrial(
  fontSize: 23.0,
  fontWeight: FontWeight.w500,
  color: kBlack,
  wordSpacing: 2.5,
);
var kTitleStyle = GoogleFonts.questrial(
  fontSize: 16.0,
  color: kBlack,
  fontWeight: FontWeight.w400,
);
var kSubtitleStyle = GoogleFonts.questrial(
  fontSize: 14.0,
  color: kBlack,
);
const kPrimaryColor = Color(0xFF0898E7);
const kPrimaryLightColor = Color(0xFFF3FDFF);
const kIconColor = Color(0xFF5E5E5E);

const kTextMediumColor = Color(0xFF53627C);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const link = "http://192.168.1.118:3305";
const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const kDefaultPadding = 20.0;

final kDefualtShadow = BoxShadow(
  offset: Offset(5, 5),
  blurRadius: 10,
  color: Color(0xFFE9E9E9).withOpacity(0.56),
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}

const primaryBlue = Color(0xFF0898E7);
const secondaryBlue = Color(0xFFF3FDFF);
const silver = Color(0xE29E19);
