import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:pim/components/no_account_text.dart';
import 'package:pim/components/socal_card.dart';
import 'package:pim/screens/Home/homewithSlider.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  _loginWithFB() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeWithSidebar()),
        );
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });

        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String autherized = "Not autherized";
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "660021269777-ujn0r91945s3nkhbe9tjvnhobfr6tkp8.apps.googleusercontent.com");
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  //this function will get all the available biometrics inside our device
  //it will return a list of objects, but for our example it will only
  //return the fingerprint biometric
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  //this function will open an authentication dialog
  // and it will check if we are authenticated or not
  // so we will add the major action here like moving to another activity
  // or just display a text that will tell us that we are authenticated
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan your finger print to authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeWithSidebar()),
        );
      }
    });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _checkBiometric();
    _getAvailableBiometrics();
    secureScreen();
    // setupAlan();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
    initTargets();
    showTutorial();
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton2,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("Connect with social"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        tr("you can connect with google."),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton1,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("Connect with social"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        tr("you can connect with facebook."),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyButton3,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("Connect with fingerprint"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        tr("you can connect using your fingerprint."),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton4,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("change language"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        tr("you can can change language to english."),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: keyButton5,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("Change language"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        tr("you can change language to french."),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  setupAlan() {
    AlanVoice.addButton(
        "8d3a4db97ec56c7644c781a91d6886132e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        print("kkkkk");
        break;

      default:
        print("Command was ${response["command"]}");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  tr("title"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: getProportionateScreenWidth(25),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tr("Sign in with your email and password"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      key: keyButton2,
                      press: () {
                        statrSignIn();
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      //key: keyButton3,
                      key: keyButton1,
                      press: () {
                        _loginWithFB();
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/fingerprint.svg",
                      key: keyButton3,
                      press: () {
                        _authenticate();
                      },
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        InkWell(
                          key: keyButton4,
                          child: Image.asset(
                            "assets/icons/uk.png",
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          ),
                          onTap: () => context.locale =
                              EasyLocalization.of(context).supportedLocales[0],
                        ),
                        SizedBox(width: SizeConfig.screenWidth * .20),
                        InkWell(
                          key: keyButton5,
                          child: Image.asset(
                            "assets/icons/fr.png",
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          ),
                          onTap: () => context.locale =
                              EasyLocalization.of(context).supportedLocales[1],
                        ),
                        Spacer(),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void statrSignIn() async {
    await googleSignIn.signOut(); //optional
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print('Sign In Failed ');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeWithSidebar()),
      );
    }
  }
}
