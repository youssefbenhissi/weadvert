import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pim/screens/offres_cote_automobiliste/json/home_page_json.dart';
import 'package:pim/screens/offres_cote_automobiliste/theme/colors.dart';
import 'package:pim/screens/offres_cote_automobiliste/theme/styles.dart';
import 'package:pim/screens/offres_cote_automobiliste/widgets/custom_slider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pim/models/offre.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:pim/constants.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'dart:ui';
import 'package:pim/screens/offres_cote_automobiliste/pages/detail_offre.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "Hey there !";
  SharedPreferences preferences;

  int idAuto;

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        for (Offre o in offres) {
          if (o.idOffre.toString() == result) {
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return JobDetail(
                company: o,
              );
            }));
          }
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  bool isLoaded = false;
  int activeMenu = 0;
  Offre v;
  Future data;

  List<Offre> offres = new List<Offre>();
  List<Offre> offresTunis = new List<Offre>();
  List<Offre> offresMonastir = new List<Offre>();
  List<Offre> offresAriana = new List<Offre>();
  List<Offre> offrestous = new List<Offre>();
  List<Offre> offresnew = new List<Offre>();
  List<Offre> offreslikds = new List<Offre>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
    );
  }

  Future<List<Offre>> _getallofrresparregion(String region) async {
    String url = link + '/offreregion';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"region": "' + region + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);

    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      Offre o = Offre(
        idOffre: u["idOffre"],
        idAnnonceur: u["idAnnonceur"],
        description: u["description"],
        gouvernorat: u["gouvernorat"],
        likes: u["likes"],
        dateDeb: u["dateDeb"],
        dateFin: u["dateFin"],
        cout: u["cout"],
        nbCandidats: u["nbCandidats"],
        entreprise: u["entreprise"],
        image: u["image"],
        imageOffer: u['imageOffer'],
        nbrdefois: u['nbrdefois'],
        somme: u['somme'],
        typeEntre: u['typeEntre'],
        email: u['email'],
      );
      offresTunis.add(o);
    }
    return offresTunis;
  }

  Future<List<Offre>> _getallofrresparregionmonsatir(String region) async {
    String url = link + '/offreregion';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"region": "' + region + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);
    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      Offre o = Offre(
        idOffre: u["idOffre"],
        idAnnonceur: u["idAnnonceur"],
        description: u["description"],
        gouvernorat: u["gouvernorat"],
        dateDeb: u["dateDeb"],
        dateFin: u["dateFin"],
        cout: u["cout"],
        nbCandidats: u["nbCandidats"],
        entreprise: u["entreprise"],
        likes: u["likes"],
        image: u["image"],
        nbrdefois: u['nbrdefois'],
        somme: u['somme'],
        imageOffer: u["imageOffer"],
        typeEntre: u['typeEntre'],
        email: u['email'],
      );
      offresMonastir.add(o);
    }
    return offresMonastir;
  }

  Future<List<Offre>> _getallofrresparregionariana(String region) async {
    String url = link + '/offreregion';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"region": "' + region + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);
    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      Offre o = Offre(
        idOffre: u["idOffre"],
        idAnnonceur: u["idAnnonceur"],
        description: u["description"],
        gouvernorat: u["gouvernorat"],
        dateDeb: u["dateDeb"],
        dateFin: u["dateFin"],
        cout: u["cout"],
        nbCandidats: u["nbCandidats"],
        likes: u["likes"],
        entreprise: u["entreprise"],
        image: u["image"],
        nbrdefois: u['nbrdefois'],
        somme: u['somme'],
        imageOffer: u["imageOffer"],
        typeEntre: u['typeEntre'],
        email: u['email'],
      );
      offresAriana.add(o);
    }
    return offresAriana;
  }

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
          nbCandidats: u["nbCandidats"],
          likes: u["likes"],
          cout: u["cout"],
          nbrdefois: u['nbrdefois'],
          somme: u['somme'],
          typeEntre: u['typeEntre'],
          email: u['email'],
          entreprise: u["entreprise"],
          imageOffer: u["imageOffer"]);
      offres.add(o);
    }
    return offres;
  }

  Future<List<Offre>> _gettousofrres() async {
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
          cout: u["cout"],
          typeEntre: u['typeEntre'],
          email: u['email'],
          nbCandidats: u["nbCandidats"],
          nbrdefois: u['nbrdefois'],
          somme: u['somme'],
          entreprise: u["entreprise"],
          likes: u["likes"],
          imageOffer: u["imageOffer"]);
      offrestous.add(o);
    }
    return offrestous;
  }

  Future<List<Offre>> _getallnew() async {
    var data = await http.get(link + '/gettousoffresnewones');
    var jsondata = json.decode(data.body);

    for (var u in jsondata) {
      Offre o = Offre(
        idOffre: u["idOffre"],
        idAnnonceur: u["idAnnonceur"],
        description: u["description"],
        gouvernorat: u["gouvernorat"],
        dateDeb: u["dateDeb"],
        dateFin: u["dateFin"],
        cout: u["cout"],
        typeEntre: u['typeEntre'],
        email: u['email'],
        nbrdefois: u['nbrdefois'],
        somme: u['somme'],
        nbCandidats: u["nbCandidats"],
        entreprise: u["entreprise"],
        imageOffer: u["imageOffer"],
        likes: u["likes"],
      );

      offresnew.add(o);
    }
    return offresnew;
  }

  Future<List<Offre>> _getalllikes() async {
    var data = await http.get(link + '/gettousoffresliked');
    var jsondata = json.decode(data.body);

    for (var u in jsondata) {
      Offre o = Offre(
        idOffre: u["idOffre"],
        idAnnonceur: u["idAnnonceur"],
        description: u["description"],
        gouvernorat: u["gouvernorat"],
        dateDeb: u["dateDeb"],
        dateFin: u["dateFin"],
        cout: u["cout"],
        typeEntre: u['typeEntre'],
        email: u['email'],
        nbCandidats: u["nbCandidats"],
        entreprise: u["entreprise"],
        nbrdefois: u['nbrdefois'],
        somme: u['somme'],
        imageOffer: u["imageOffer"],
        likes: u["likes"],
      );

      offreslikds.add(o);
    }
    return offreslikds;
  }

  Color purple = Color(0xff5c4db1);
  Color pink = Color(0xffdc4f89);

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAuto = preferences.getInt('idAuto');
  }

  @override
  void initState() {
    super.initState();

    data = getSP().then((value) => _getallofrres());

    _gettousofrres();
    _getallofrresparregion("Tunis");
    _getallofrresparregionmonsatir("Monastir");
    _getallofrresparregionariana("Ariana");
    _getallnew();
    _getalllikes();

    isLoaded = true;
  }

  List list = [
    "Flutter",
    "Angular",
    "Node js",
    "Node js",
    "Node js",
  ];
  Widget getBody() {
    var size = MediaQuery.of(context).size;
    if (isLoaded)
      return RefreshIndicator(
        onRefresh: _getallofrres,
        child: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     Navigator.of(context)
                  //         .push(HeroDialogRoute(builder: (context) {
                  //       return MyHomePage();
                  //     }));
                  //   },
                  //   child: Icon(Icons.forum),
                  //   heroTag: "demoValue",
                  // ),
                  body: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: GFSearchBar(
                              searchList: list,
                              searchQueryBuilder: (query, list) {
                                return list
                                    .where((item) => item
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                    .toList();
                              },
                              overlaySearchListItemBuilder: (item) {
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: _scanQR,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(menu.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeMenu = index;
                                  if (index == 0) {
                                    offres = offrestous;
                                  }
                                  if (index == 1) {
                                    offres = offresTunis;
                                  }
                                  if (index == 2) {
                                    offres = offresMonastir;
                                  }
                                  if (index == 3) {
                                    offres = offresAriana;
                                  }
                                });
                              },
                              child: activeMenu == index
                                  ? ElasticIn(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: black,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 8,
                                              bottom: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                menu[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 8,
                                            bottom: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              menu[index],
                                              style: customContent,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomSliderWidget(
                    items: [
                      "assets/images/slide_1.jpg",
                      "assets/images/slide_2.jpg",
                      "assets/images/slide_3.jpg"
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 10,
                    decoration: BoxDecoration(color: textFieldColor),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          tr("Tous les offres"),
                          style: customTitle,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                children: List.generate(offres.length, (index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return JobDetail(
                                        company: offres[index],
                                        idAuto: this.idAuto);
                                  }));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: Image.network(link +
                                                  "/file/" +
                                                  offres[index].imageOffer)
                                              .image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.all(20),
                                        color: Color(0xffdfdeff),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offres[index].entreprise,
                                              style: TextStyle(
                                                  color: purple,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              offres[index].gouvernorat,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  color: purple,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  DateFormat('yyyy-MM-dd')
                                                          .format(DateTime
                                                              .parse(offres[
                                                                      index]
                                                                  .dateDeb)) +
                                                      " - " +
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(DateTime
                                                              .parse(offres[
                                                                      index]
                                                                  .dateFin)),
                                                  style: TextStyle(
                                                      color: purple,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  tr("Rating"),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                for (var i = 0;
                                                    i < offres[index].somme;
                                                    i++)
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                for (var i = 0;
                                                    i < 4 - offres[index].somme;
                                                    i++)
                                                  Icon(
                                                    Icons.star_border_outlined,
                                                    color: Colors.yellowAccent,
                                                  )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 0.5,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.call,
                                                  color: purple,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.mail_outline,
                                                  color: purple,
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Text(
                                                  "\$" +
                                                      offres[index]
                                                          .cout
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: purple,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width,
                    height: 10,
                    decoration: BoxDecoration(color: textFieldColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ColorLoader3());
            } else
              return Center(child: ColorLoader3());
          },
        ),
      );
  }
}
