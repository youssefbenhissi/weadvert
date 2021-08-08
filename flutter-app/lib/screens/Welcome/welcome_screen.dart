import 'package:flutter/material.dart';
import 'package:pim/Screens/Welcome/components/body.dart';
import 'package:pim/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var data = EasyLocalizationProvider.of(context).data;
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
    // return EasyLocalizationProvider(
    //   data: data,
    //   child: MaterialApp(
    //     home: Scaffold(
    //       body: Body(),
    //     ),
    //   ),
    // );
  }
}
