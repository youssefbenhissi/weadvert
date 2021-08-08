import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pim/components/custom_surfix_icon.dart';
import 'package:pim/components/default_button.dart';
import 'package:pim/components/form_error.dart';
import 'package:pim/otpsms/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  String email;
  CompleteProfileForm({this.email});
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  SharedPreferences preferences;
  final _formKey = GlobalKey<FormState>();
  TwilioFlutter twilioFlutter;
  final List<String> errors = [];
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  DateTime dateNaiss;
  String profession;
  String ppp;

  _makePostRequest() async {
    String url = link + '/automobiliste';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"nom": "' +
        firstName +
        '", "prenom": "' +
        lastName +
        '", "email": "' +
        widget.email +
        '", "profession": "' +
        profession +
        '", "numerotelephone": "' +
        phoneNumber +
        '", "lieuCirculation": "' +
        address +
        '", "revenu": 0, "score": 0, "dateNaiss": "' +
        dateNaiss.toString().substring(0, dateNaiss.toString().length - 1) +
        '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
  }

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACfbd03ebad1bc7be3f64db3401386c998',
        authToken: '26a0feeb287bf748f967e107af3250d2',
        twilioNumber: '+16123459488');
    super.initState();
  }

  void sendSms(String phone, String code) async {
    twilioFlutter.sendSMS(
        toNumber: phone,
        messageBody: 'Please enter this code to verify your number:' + code);
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController controller = TextEditingController();
    String initialCountry = 'TN';
    PhoneNumber number = PhoneNumber(isoCode: 'TN');

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              ppp = number.phoneNumber;
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller,
            formatInput: false,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(),
            onSaved: (PhoneNumber number) {
              phoneNumber = number.toString();
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildWorkFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          Container(
            height: 150,
            padding: EdgeInsets.only(bottom: 20.0),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                dateNaiss = newDateTime;
              },
            ),
          ),
          DefaultButton(
            text: tr("continue"),
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                preferences = await SharedPreferences.getInstance();
                await preferences.setString('nom', lastName);
                await preferences.setString('prenom', firstName);
                await preferences.setString('profession', profession);
                await preferences.setString('lieuCirculation', address);

                _makePostRequest();
                int min = 0;
                int max = 9999;
                var randomizer = new Random();
                var rNum = min + randomizer.nextInt(max - min);
                sendSms(ppp, rNum.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OtpScreensms(code: rNum.toString(), number: ppp)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: tr("Address"),
        hintText: tr("Enter your phone address"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: tr("last_name"),
        hintText: tr("Enter your last name"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildWorkFormField() {
    return TextFormField(
      onSaved: (newValue) => profession = newValue,
      decoration: InputDecoration(
        labelText: "Profession",
        hintText: tr("Enter your profession"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/suitcase.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: tr("first_name"),
        hintText: tr("Enter your first name"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
