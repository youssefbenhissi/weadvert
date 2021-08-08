import 'package:intl/intl.dart';
import 'dart:convert';

class Offre {
  int idOffre, idAnnonceur, nbCandidats;
  String description,
      website,
      gouvernorat,
      delegation,
      cible,
      entreprise,
      image,
      telephone,
      imageOffer;
  String dateDeb, dateFin;
  int renouvelable;
  int cout;
  int likes;
  int nbrdefois;
  int somme;
  String typeEntre;
  String email;
  static DateFormat formatter = DateFormat('yyyy-MM-dd');

  Offre(
      {this.idOffre,
      this.idAnnonceur,
      this.description,
      this.gouvernorat,
      this.delegation,
      this.cible,
      this.dateDeb,
      this.dateFin,
      this.telephone,
      //this.renouvelable,
      this.nbCandidats,
      this.cout,
      this.entreprise,
      this.image,
      this.imageOffer,
      this.likes,
      this.nbrdefois,
      this.somme,
      this.typeEntre,
      this.website,
      this.email});

  static List<Offre> offresFromJson(String str) =>
      List<Offre>.from(json.decode(str).map((x) => Offre.fromJson(x)));
  static List<Offre> getAll(List<dynamic> json) {
    List<Offre> list = new List<Offre>();
    for (var item in json) {
      list.add(Offre.fromJson(item));
    }
    return list;
  }

  factory Offre.fromJson(List<dynamic> json) {
    return Offre(
      idOffre: json[0]['idOffre'] as int,
      idAnnonceur: json[0]['idAnnonceur'] as int,
      description: json[0]['description'] as String,
      gouvernorat: json[0]['gouvernorat'] as String,
      delegation: json[0]['delegation'] as String,
      cible: json[0]['cible'] as String,
      dateDeb: formatter.format(DateTime.parse(json[0]['dateDeb'].toString())),
      dateFin: formatter.format(DateTime.parse(json[0]['dateFin'].toString())),
      //json[0]['renouvelable'] as bool,
      nbCandidats: json[0]['nbCandidats'] as int,
      cout: json[0]['cout'] as int,
      entreprise: json[0]['entreprise'] as String,
      image: json[0]['image'] as String,
      imageOffer: json[0]['imageOffer'] as String,
      likes: json[0]['likes'] as int,
      nbrdefois: json[0]['nbrdefois'] as int,
      somme: json[0]['somme'] as int,
      typeEntre: json[0]['typeEntre'] as String,
      email: json[0]['email'] as String,
    );
  }
}
