import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
//import 'package:pim/menu_frame.dart';
import 'package:pim/screens/offres_cote_automobiliste/pages/slider.dart';
import 'package:pim/screens/onboarding_screen.dart';
import 'package:pim/screens/Welcome/welcome_screen.dart';
import 'package:pim/services/admob_service.dart';
import 'package:pim/utilities/Theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Welcome/welcome_screen.dart';
import 'screens/sign_up/signupwithsms.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart';

int initScreen;

const list = [
  Locale('en', 'US'),
  Locale('fr', 'FR'),
];
SharedPreferences preferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
  //Firebase.initializeApp();
  //WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');

  if (initScreen == null) {
    await preferences.setInt('initScreen', 1);
    print(initScreen);
    runApp(EasyLocalization(
        path: 'assets/languages',
        supportedLocales: list,
        saveLocale: true,
        child: MyApp()));
  } else {
    print(initScreen);
    runApp(EasyLocalization(
        path: 'assets/languages',
        supportedLocales: list,
        saveLocale: true,
        child: MyApp2()));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initappcenter();
  }

  Future<void> initappcenter() async {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;

    var app_secret = ios ? "iOSGuid" : "8faf89a1-1712-46d7-a681-278230ccd5ef";
    await AppCenter.start(
        app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => MyThemes.themes[1],
        themedWidgetBuilder: (context, theme) {
          return GetMaterialApp(
            title: 'Flutter Onboarding UI',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: OnboardingScreen(),
          );
        });
  }
}

class MyApp2 extends StatefulWidget {
  //static SharedPreferences preferences;
  //MyApp2()
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  Future<void> initappcenter() async {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;

    var app_secret = ios ? "iOSGuid" : "8faf89a1-1712-46d7-a681-278230ccd5ef";
    await AppCenter.start(
        app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
  }

  @override
  void initState() {
    super.initState();
    initappcenter();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => MyThemes.themes[1],
        themedWidgetBuilder: (context, theme) {
          return GetMaterialApp(
            title: 'Flutter Onboarding UI',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: theme,
            // home: MyHomeScreen(),
            home: WelcomeScreen(),
            //home: DemoPage(),
            //home: Bankcard(),
          );
        });
  }
}
