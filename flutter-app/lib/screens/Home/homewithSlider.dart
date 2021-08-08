import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/screens/Home/homepage.dart';
import 'package:pim/screens/Welcome/welcome_screen.dart';
import 'package:pim/screens/annonceur_side/popup/hero_dialog_route.dart';
import 'package:pim/screens/forum/main.dart';
import 'package:pim/screens/offres_cote_automobiliste/root_app.dart';
import 'package:pim/screens/profile/components/Chat_Screen.dart';
import 'package:pim/screens/profile/components/current_offre.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:pim/screens/profile/components/profile.dart';
import 'package:pim/screens/profile/profile_screen.dart';
import 'package:pim/models/automobiliste.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '10_connection_lost.dart';

class HomeWithSidebar extends StatefulWidget {
  Widget child = HomePage();
  HomeWithSidebar({this.child});
  @override
  _HomeWithSidebarState createState() => _HomeWithSidebarState();
}

class _HomeWithSidebarState extends State<HomeWithSidebar>
    with TickerProviderStateMixin {
  String nom;
  bool sideBarActive = false;
  String email, picture;
  Automobiliste automobiliste = Automobiliste();
  Future data;
  AnimationController rotationController;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.automobiliste.idAuto = prefs.getInt("idAuto");
    this.automobiliste.nom = prefs.getString('nom');
    this.automobiliste.prenom = prefs.getString('prenom');
    this.automobiliste.email = prefs.getString('email');
    this.automobiliste.photo = prefs.getString('photo');
    this.automobiliste.profession = prefs.getString('profession');
    this.automobiliste.lieuCirculation = prefs.getString('lieuCirculation');
    this.automobiliste.dateNaiss = DateTime.parse(prefs.getString('dateNaiss'));
    this.automobiliste.score = prefs.getInt('score');
  }

  void youssef() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email');
  }

  ConnectivityResult previous;
  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  bool dialogshown = false;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogshown = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConnectionLostScreen()));
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }

      _previousResult = connresult;
    });

    rotationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    data = getStringValuesSF();
  }

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(60)),
                              color: Theme.of(context).primaryColor),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      image: DecorationImage(
                                          image: this.automobiliste.photo ==
                                                  null
                                              ? Image.asset(
                                                      "assets/images/avatar1.png")
                                                  .image
                                              : Image.network(link +
                                                      '/file/' +
                                                      this.automobiliste.photo)
                                                  .image,
                                          fit: BoxFit.contain)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      this.automobiliste.nom +
                                          " " +
                                          this.automobiliste.prenom,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      this.automobiliste.email,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => closeSideBar,
                            child: navigatorTitle(tr("Home"), false),
                          ),

                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeWithSidebar(child:Profile(this.automobiliste)))),
                            child: navigatorTitle(tr("Profile"), false),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeWithSidebar(child:CurrentOffre()))),
                            child:
                                navigatorTitle(tr("Current Position"), false),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeWithSidebar(child:RootApp()))),
                            child: navigatorTitle(tr("Tous les offres"), false),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .push(HeroDialogRoute(builder: (context) {
                              return HomeWithSidebar(child:MyHomePage());
                            })),
                            child: navigatorTitle(tr("discussion Form"), false),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeWithSidebar(child:ProfileScreen()))),
                            child: navigatorTitle(tr("Settings"), false),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeWithSidebar(child:ChatScreen(
                                          email: "iheb@gmail.com",
                                          name: "iheb",
                                        ))),
                              );
                            },
                            child: navigatorTitle(tr("help"), false),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) => WelcomeScreen(),
                          ),
                          (Route route) => false,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            size: 30,
                          ),
                          Text(
                            tr("logout"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: (sideBarActive)
                      ? MediaQuery.of(context).size.width * 0.6
                      : 0,
                  top: (sideBarActive)
                      ? MediaQuery.of(context).size.height * 0.2
                      : 0,
                  child: RotationTransition(
                    turns: (sideBarActive)
                        ? Tween(begin: -0.05, end: 0.0)
                            .animate(rotationController)
                        : Tween(begin: 0.0, end: -0.05)
                            .animate(rotationController),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: (sideBarActive)
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height,
                      width: (sideBarActive)
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: widget.child == null ? HomePage() : widget.child,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 20,
                  child: (sideBarActive)
                      ? IconButton(
                          padding: EdgeInsets.all(30),
                          onPressed: closeSideBar,
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      : InkWell(
                          onTap: openSideBar,
                          child: Container(
                            margin: EdgeInsets.all(17),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/menu.png'))),
                          ),
                        ),
                )
              ],
            );
            ;
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ColorLoader3());
          }
        },
      ),
    );
  }

  Row navigatorTitle(String name, bool isSelected) {
    return Row(
      children: [
        (isSelected)
            ? Container(
                width: 5,
                height: 60,
                color: Color(0xffffac30),
              )
            : Container(
                width: 5,
                height: 60,
              ),
        SizedBox(
          width: 10,
          height: 60,
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 16,
              fontWeight: (isSelected) ? FontWeight.w700 : FontWeight.w400),
        )
      ],
    );
  }

  void closeSideBar() {
    sideBarActive = false;
    setState(() {});
  }

  void openSideBar() {
    sideBarActive = true;
    setState(() {});
  }
}
