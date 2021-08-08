import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/components/custom_surfix_icon.dart';
import 'package:pim/components/form_error.dart';
import 'package:pim/helper/keyboard.dart';
import 'package:pim/models/automobiliste.dart';
import 'dart:convert';
import 'package:pim/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pim/screens/Home/homewithSlider.dart';
import 'package:http/http.dart' as http;
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'custom_dialog.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  Utilisateur v;
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  int status;
  var obj;
  bool remember = false;
  final List<String> errors = [];
  SharedPreferences preferences;
  Automobiliste automobiliste;

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

  _makeGetRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idAuto = prefs.getInt('idAuto');
    String url = link + '/voiture/' + idAuto.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String body = response.body;
    List<dynamic> object = json.decode(response.body);
    await preferences.setString("typeVoiture", object[0]['type']);
    await preferences.setString("marque", object[0]['marque']);
    await preferences.setString("model", object[0]['model']);
    await preferences.setInt("annee", object[0]['annee']);
    return object[0]; //['type'];
  }

  _makePostRequest() async {
    preferences = await SharedPreferences.getInstance();
    String url = link + '/loginautomobiliste';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "' + email + '","password": "' + password + '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    status = response.statusCode;
    if (response.statusCode == 200) {
      v = Utilisateur.fromJson(jsonDecode(response.body));
      automobiliste = Automobiliste.fromJson(jsonDecode(response.body));
      await preferences.setInt('idAuto', automobiliste.idAuto);
      await preferences.setString('nom', automobiliste.nom);
      await preferences.setString('prenom', automobiliste.prenom);
      await preferences.setString('email', automobiliste.email);
      await preferences.setString('profession', automobiliste.profession);
      await preferences.setString(
          'lieuCirculation', automobiliste.lieuCirculation);
      await preferences.setString('cin', automobiliste.cin);
      await preferences.setString('photo', automobiliste.photo);
      await preferences.setDouble('revenu', automobiliste.revenu);
      await preferences.setString('dateNaiss',
          DateTime.parse(automobiliste.dateNaiss.toString()).toString());
      await preferences.setInt('score', automobiliste.score);
      _makeGetRequest().then((value) async {});
    } else
      v = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text(tr("Remember me")),
              Spacer(),
              GestureDetector(
                onTap: () => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignForm()))
                },
                child: Text(
                  tr("Forgot Password"),
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: tr("boutton"),
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                await _makePostRequest();
                if (status == 202) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: tr("customBoxTitle"),
                      description: tr("customBoxMessage"),
                      primaryButtonText: tr("bouttondialog"),
                    ),
                  );
                } else if (status == 200) {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setString('email', v.email);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeWithSidebar()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: tr("customBoxTitle"),
                      description: tr("wrong email"),
                      primaryButtonText: tr("bouttondialog"),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          password = value;
          removeError(error: kShortPassError);
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: tr("Password"),
        hintText: tr("Enter your password"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          email = value;
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: tr("Enter your email"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
