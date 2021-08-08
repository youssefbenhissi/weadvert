import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/screens/annonceur_side/ajouter_annonce.dart';
import 'package:pim/screens/annonceur_side/components/popular_places.dart';
import 'package:pim/screens/annonceur_side/components/recommended.dart';
import 'package:pim/screens/annonceur_side/components/recommended_places.dart';

import 'package:http/http.dart' as http;
import 'package:pim/screens/profile/components/loader.dart';
import '../../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pim/screens/Home/assets.dart';
import 'package:pim/screens/Home/network_image.dart';
import 'dart:convert';
import 'candidates.dart';
import 'profile/components/Chat_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static final String path = "lib/src/pages/misc/sliders.dart";
  final List<String> images = [
    avatars[0],
    breakfast,
    fishtail,
    avatars[2],
    pancake,
    fewalake,
    avatars[3],
    fries,
    kathmandu1,
    avatars[1],
    burger,
    pashupatinath,
  ];
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;
  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  List<Offre> offres = new List<Offre>();
  Future data;
  bool isLoaded = false;
  Future<List<Offre>> _getallofrres() async {
    var data = await http.get(link + '/offre');
    var jsondata = json.decode(data.body);

    for (var u in jsondata) {
      Offre o = Offre(
          idOffre: u["idOffre"],
          idAnnonceur: u["idAnnonceur"],
          description: u["description"],
          gouvernorat: u["gouvernorat"],
          dateDeb: u["dateDeb"],
          dateFin: u["dateFin"],
          likes: u["likes"],
          nbrdefois: u['nbrdefois'],
          somme: u['somme'],
          nbCandidats: u["nbCandidats"],
          entreprise: u["entreprise"],
          imageOffer: u["imageOffer"]);
      offres.add(o);
    }
    print(offres.length);
    return offres;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    data = _getallofrres();
    isLoaded = true;
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (isLoaded)
      return FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                extendBody: true,
                backgroundColor: Theme.of(context).primaryColor,
                floatingActionButton: Positioned(
                  right: 30,
                  bottom: 30,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      IgnorePointer(
                        child: Container(
                          color: Colors.transparent,
                          height: 150.0,
                          width: 150.0,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(270),
                            degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                              getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degOneTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.blue,
                            width: 50,
                            height: 50,
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginSignupScreen()),
                              );
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(225),
                            degTwoTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                              getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degTwoTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.black,
                            width: 50,
                            height: 50,
                            icon: Icon(
                              Icons.chat,
                              color: Theme.of(context).primaryColor,
                            ),
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          email: "iheb@gmail.com",
                                          name: "iheb",
                                        )),
                              );
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(180),
                            degThreeTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                              getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degThreeTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.orangeAccent,
                            width: 50,
                            height: 50,
                            icon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Candidates(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value)),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.red,
                          width: 60,
                          height: 60,
                          icon: Icon(
                            Icons.menu,
                            color: Theme.of(context).primaryColor,
                          ),
                          onClick: () {
                            if (animationController.isCompleted) {
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              tr('Best Offers'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 220,
                        color: Colors.transparent,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: Image.network(link +
                                              "/file/" +
                                              offres[index].imageOffer)
                                          .image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        offres[index].entreprise,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child:
                                                Text(offres[index].description),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          itemWidth: 300,
                          itemHeight: 200,
                          itemCount: offres.length,
                          layout: SwiperLayout.STACK,
                        ),
                      ),
                      Recommended(),
                      RecommendedPlaces(),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ColorLoader3());
            } else
              return Center(child: ColorLoader3());
          });
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
