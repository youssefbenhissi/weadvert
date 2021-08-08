class UserLocation {
  String nom, prenom, descriptionOffre;
  double latitude, longitude, solde;
  int idAuto, isOnline;

  UserLocation({this.idAuto, this.latitude, this.longitude, this.isOnline, this.nom, this.prenom, this.solde, this.descriptionOffre});

  static List<UserLocation> fromJson(List<dynamic> json) {
    List<UserLocation> list = new List<UserLocation>();
    json.forEach((value) {
      list.add( UserLocation(
        idAuto: value['idAuto'] as int,
        latitude: value['latitude'] as double,
        longitude: value['longitude'] as double,
        isOnline: value['isOnline'] as int,
        nom: value['nom'] as String,
        prenom: value['prenom'] as String,
        solde: (value['solde']) as double,
        descriptionOffre: value['description'] as String
      ));
    });
    return list;
  }

  @override
  String toString() {
    return "latitude : " +
        latitude.toString() +
        " longitude : " +
        longitude.toString();
  }
}
