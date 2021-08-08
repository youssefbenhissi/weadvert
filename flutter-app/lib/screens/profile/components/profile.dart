import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pim/constants.dart';
import 'package:pim/models/automobiliste.dart';
import 'package:pim/models/offre.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pim/screens/annonceur_side/widgets/opaque_image.dart';
import 'package:pim/screens/annonceur_side/widgets/profile_info_big_card.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:pim/screens/profile/components/my_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  Automobiliste person;
  Profile(this.person);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future data;
  bool isLoaded;
  List<Offre> offres = new List<Offre>();
  Color purple = Color(0xff5c4db1);

  @override
  void initState() {
    super.initState();
    data = _getallofrres();
    setState(() {
      isLoaded = true;
    });
  }

  Future<List<Offre>> _getallofrres() async {
    String url = link + '/oldOffres/' + widget.person.idAuto.toString();
    var data = await http.get(url);
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
          cout: u["solde"],
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: <Widget>[
                          widget.person.photo == null
                              ? OpaqueImage(
                                  imageUrl: link + "/file/avatar1.png")
                              : OpaqueImage(
                                  imageUrl:
                                      link + "/file/" + widget.person.photo,
                                ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.arrow_back)),
                                  ),
                                  MyInfo(
                                    widget.person.photo.toString(),
                                    widget.person.nom.toString(),
                                    widget.person.prenom.toString(),
                                    widget.person.dateNaiss,
                                    widget.person.lieuCirculation.toString(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.only(top: 50),
                        color: Colors.white,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 30, top: 15),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0.8, 10, 8.0),
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.history),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          tr("previous_deals"),
                                          textWidthBasis:
                                              TextWidthBasis.longestLine,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xFF8391A0),
                                            fontWeight: FontWeight.w200,
                                          ).copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  offres.length > 0
                                      ? Column(
                                          children: List.generate(offres.length,
                                              (index) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(20),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: Image.network(link +
                                                            "/file/" +
                                                            offres[0]
                                                                .imageOffer)
                                                        .image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  padding: EdgeInsets.all(20),
                                                  color: Color(0xffdfdeff),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        offres[index]
                                                            .entreprise,
                                                        style: TextStyle(
                                                            color: purple,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        offres[index]
                                                            .gouvernorat,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: purple,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            DateFormat('yyyy-MM-dd').format(
                                                                    DateTime.parse(
                                                                        offres[index]
                                                                            .dateDeb)) +
                                                                " - " +
                                                                DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .format(DateTime.parse(
                                                                        offres[index]
                                                                            .dateFin)),
                                                            style: TextStyle(
                                                                color: purple,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            tr("Rating"),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          for (var i = 0;
                                                              i <
                                                                  offres[index]
                                                                      .somme;
                                                              i++)
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.yellow,
                                                            ),
                                                          for (var i = 0;
                                                              i <
                                                                  4 -
                                                                      offres[index]
                                                                          .somme;
                                                              i++)
                                                            Icon(
                                                              Icons
                                                                  .star_border_outlined,
                                                              color: Colors
                                                                  .yellowAccent,
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
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }))
                                      : Center(
                                          child: Text(
                                            tr("no_previous"),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Color(0xFF8391A0),
                                              fontWeight: FontWeight.w200,
                                            ).copyWith(color: Colors.black),
                                          ),
                                        ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: screenHeight * (5 / 9) - 150 / 2,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ProfileInfoCard(
                            firstText: widget.person.score.toString(),
                            secondText: "Score"),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ProfileInfoCard(
                            firstText: widget.person.profession,
                            secondText: tr("profession")),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ColorLoader3());
          }
        },
      ),
    );
  }
}
