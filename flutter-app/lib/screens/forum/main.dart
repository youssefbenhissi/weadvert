import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/screens/forum/commons/const.dart';
import 'package:pim/screens/forum/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'threadMain.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  MyProfileData myData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;
    if (prefs.get('myThumbnail') == null) {
      myThumbnail = prefs.get('photo');
    } else {
      myThumbnail = prefs.get('photo');
    }

    if (prefs.get('nom') == null || prefs.get('prenom') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('myName', tempName);
      myName = tempName;
    } else {
      myName = prefs.get('nom') + " " + prefs.get('prenom');
    }

    setState(() {
      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: myName,
        myLikeList: prefs.getStringList('likeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Notre Forum')),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(controller: _tabController, children: [
            ThreadMain(
              myData: myData,
              updateMyData: updateMyData,
            ),
            UserProfile(
              myData: myData,
              updateMyData: updateMyData,
            ),
          ]),
          Utils.loadingCircle(_isLoading),
        ],
      ),
    );
  }
}
