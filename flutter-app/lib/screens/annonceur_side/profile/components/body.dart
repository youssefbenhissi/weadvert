import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/screens/Welcome/welcome_screen.dart';
import 'package:pim/screens/profile/components/Settigns_Screen.dart';
import 'package:pim/screens/profile/components/FAQ.dart';
import 'profile_buisness.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: tr("My profile"),
            icon: "assets/icons/User Icon.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileThreePage()),
              );
            },
          ),
          ProfileMenu(
            text: tr("Languages and Theme"),
            icon: "assets/icons/Settings.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ProfileMenu(
            text: tr("Help Center"),
            icon: "assets/icons/Question mark.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqPage()),
              );
            },
          ),
          ProfileMenu(
            text: tr("logout"),
            icon: "assets/icons/Log out.svg",
            press: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => WelcomeScreen(),
                ),
                (Route route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
