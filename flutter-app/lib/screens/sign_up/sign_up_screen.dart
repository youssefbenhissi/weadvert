import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("Sign Up")),
      ),
      body: Body(),
    );
  }
}
