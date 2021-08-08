import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  Color yellow = Color(0xffFDC054);
  Color mediumYellow = Color(0xffFDB846);
  Color darkYellow = Color(0xffE99E22);
  Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
  Color darkGrey = Color(0xff202020);

  bool myOrders = true;
  bool reminders = true;
  bool newOffers = true;
  bool feedbackReviews = true;
  bool updates = true;

  Widget platformSwitch(bool val) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        onChanged: (value) {
          setState(() {
            val = value;
          });
        },
        value: true,
        activeColor: yellow,
      );
    } else {
      return Switch(
        onChanged: (value) {
          setState(() {
            val = value;
          });
        },
        value: val,
        activeColor: yellow,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.black,
        // ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: Text(
          tr("Settings"),
          style: TextStyle(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                      //color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Notification'),
                      trailing: platformSwitch(myOrders),
                    ),
                    ListTile(
                      title: Text(tr("Reminders")),
                      trailing: platformSwitch(reminders),
                    ),
                    ListTile(
                      title: Text(tr("New Offers")),
                      trailing: platformSwitch(newOffers),
                    ),
                    // ListTile(
                    //     title: Text('Feedbacks and Reviews'),
                    //     trailing: platformSwitch(
                    //       feedbackReviews,
                    //     )),
                    ListTile(
                      title: Text(tr("Updates")),
                      trailing: platformSwitch(updates),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
