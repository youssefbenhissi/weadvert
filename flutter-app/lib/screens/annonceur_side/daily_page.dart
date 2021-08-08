import 'package:pim/theme/colors.dart';
import 'package:flutter/material.dart';
import 'current_users.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:easy_localization/easy_localization.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Stack(children: [
      CurrentUsersPositions(PopupSnap.markerTop),
      Column(children: [
        Container(
          decoration: BoxDecoration(color: white, boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.01),
              spreadRadius: 10,
              blurRadius: 3,
            ),
          ]),
          child: 
          Padding(
            padding: const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("suivi_auto"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ]),
    ]);
  }
}
