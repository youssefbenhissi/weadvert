import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pim/screens/profile/components/Language_Screen.dart';
import 'package:pim/utilities/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      setSelectedTheme();
    }
  }

  Color yellow = Color(0xffFDC054);

  // Widget _renderContainer(Color color) => Container(
  //       height: 56,
  //       width: 56,
  //       margin: EdgeInsets.symmetric(vertical: 8.0),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //         color: color,
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    var isdarkTheme = Theme.of(context).brightness == Brightness.dark;
    //print(isdarkTheme);

    return Scaffold(
        appBar: AppBar(
          title: Text('settings Screen'),
          actions: <Widget>[],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: ListTile(
                title: Text('Light/Dark Theme'),
                trailing: platformSwitch(isdarkTheme),
              ),
            ),
            Expanded(flex: 2, child: LanguageView())
          ],
        ));
  }

  Widget platformSwitch(bool val) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        onChanged: (value) {
          try {
            if (val)
              DynamicTheme.of(context)
                  .setThemeData(MyThemes.getThemeFromIndex(1));
            else
              DynamicTheme.of(context)
                  .setThemeData(MyThemes.getThemeFromIndex(0));
          } catch (e) {
            print(e.toString());
          }
        },
        value: val,
        activeColor: yellow,
      );
    } else {
      return Switch(
        onChanged: (value) {
          try {
            if (val)
              DynamicTheme.of(context)
                  .setThemeData(MyThemes.getThemeFromIndex(1));
            else
              DynamicTheme.of(context)
                  .setThemeData(MyThemes.getThemeFromIndex(0));
          } catch (e) {
            print(e.toString());
          }
        },
        value: val,
        activeColor: yellow,
      );
    }
  }

  // void changeColor(String val) async {
  //   final pref = await SharedPreferences.getInstance();
  //   await pref.setString("ui_theme", val);
  //   DynamicTheme.of(context).setThemeData(MyThemes.getThemeFromIndex(val));
  // }

  Future<void> setSelectedTheme() async {
    final pref = await SharedPreferences.getInstance();
    final val = pref.getInt("ui_theme");
    DynamicTheme.of(context).setThemeData(MyThemes.getThemeFromIndex(val));
  }
}
