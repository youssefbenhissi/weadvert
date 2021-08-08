class Voiture {
  int idVoiture, idAuto, idImage, annee;
  String type, marque, model, nom;

  Voiture(
      {this.idVoiture,
      this.idAuto,
      this.type,
      this.marque,
      this.model,
      this.idImage,
      this.nom,
      this.annee});

  factory Voiture.fromJson(List<dynamic> json) {
    return Voiture(
        idVoiture: json[0]['idVoiture'] as int,
        idAuto: json[0]['idAuto'] as int,
        type: json[0]['type'] as String,
        marque: json[0]['marque'] as String,
        model: json[0]['model'] as String,
        idImage: json[0]['idImage'] as int,
        nom: json[0]['nom'] as String,
        annee: json[0]['annee'] as int);
  }

  static List<String> images(List<dynamic> json) {
    List<String> list = new List<String>();
    json.forEach((element) {
      list.add(element['nom']);
    });
    return list;
  }

  @override
  String toString() {
    return this.idVoiture.toString() +
        " " +
        this.idAuto.toString() +
        " " +
        this.type +
        " " +
        this.marque +
        " " +
        this.model +
        " " +
        this.idImage.toString() +
        " " +
        this.nom;
  }
}
