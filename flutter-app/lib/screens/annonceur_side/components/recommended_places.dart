import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/models/Place.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/screens/annonceur_side/components/grid_place_card.dart';

import 'package:http/http.dart' as http;
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'dart:convert';

class RecommendedPlaces extends StatefulWidget {
  const RecommendedPlaces({
    Key key,
  }) : super(key: key);

  @override
  _RecommendedPlacesState createState() => _RecommendedPlacesState();
}

class _RecommendedPlacesState extends State<RecommendedPlaces> {
  List<Offre> offres = new List<Offre>();
  Future data;
  int idAnnonceur;
  SharedPreferences preferences;
  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAnnonceur = preferences.getInt('idAnnonceur');
  }

  bool isLoaded = false;
  Future<List<Offre>> _getallofrres(String idAnnonceur) async {
    var data = await http.get(link + '/offre/' + idAnnonceur);
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
    super.initState();
    data = getSP().then((value) => _getallofrres(idAnnonceur.toString()));
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (isLoaded)
      return FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: offres.length == 0
                    ? Center(
                        child: Text(
                        tr("You do not have offers yet"),
                        style: TextStyle(fontSize: 18),
                      ))
                    : GridView.count(
                        crossAxisCount: 3, //2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.2,
                        children: List.generate(offres.length, (index) {
                          return GridPlaceCard(
                            place: offres[index],
                            tapEvent: () {},
                          );
                        }),
                      ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ColorLoader3());
            } else
              return Center(child: ColorLoader3());
          });
  }
}
