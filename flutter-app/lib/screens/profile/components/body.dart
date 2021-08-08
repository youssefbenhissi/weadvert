import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pim/screens/Welcome/welcome_screen.dart';
import 'package:pim/screens/my_account/edit_car.dart';
import 'package:pim/screens/my_account/edit_profile.dart';
import 'package:pim/screens/profile/components/Settigns_Screen.dart';
import 'package:pim/screens/profile/components/FAQ.dart';
import 'package:pim/screens/profile/components/Notification_Settigns.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  // final ams = AdMobService();
  @override
  // void initState() {
  //   Admob.initialize(ams.getAdMobAppId());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // AdmobBanner(
          //   adUnitId: ams.getBannerAdId(),
          //   adSize: AdmobBannerSize.FULL_BANNER,
          // ),
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: tr("My Account"),
            icon: "assets/icons/User Icon.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          ProfileMenu(
            text: tr("My_Car"),
            icon: "assets/icons/car.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditCarPage()),
              );
            },
          ),
          // ProfileMenu(
          //   text: "Notifications",
          //   icon: "assets/icons/Bell.svg",
          //   press: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => NotificationSettingsPage()),
          //     );
          //   },
          // ),
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
                // the new route
                MaterialPageRoute(
                  builder: (BuildContext context) => WelcomeScreen(),
                ),

                // this function should return true when we're done removing routes
                // but because we want to remove all other screens, we make it
                // always return false
                (Route route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
