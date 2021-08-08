class Automobiliste {
  int idAuto, score, etatValidation;
  String nom, prenom, cin, photo, profession, lieuCirculation, email;
  double revenu;
  DateTime dateNaiss;

  Automobiliste(
      {this.idAuto,
      this.score,
      this.etatValidation,
      this.nom,
      this.prenom,
      this.email,
      this.cin,
      this.photo,
      this.profession,
      this.lieuCirculation,
      this.revenu,
      this.dateNaiss});

  factory Automobiliste.fromJson(dynamic json) {
    return Automobiliste(
        idAuto: json['idAuto'] as int,
        score: json['score'] as int,
        etatValidation: json['etatValidation'] as int,
        nom: json['nom'] as String,
        prenom: json['prenom'] as String,
        email: json['email'] as String,
        cin: json['cin'] as String,
        photo: json['photo'] as String,
        profession: json['profession'] as String,
        lieuCirculation: json['lieuCirculation'] as String,
        revenu: double.parse(json['revenu'].toString()),
        dateNaiss: DateTime.parse(json['dateNaiss'].toString()));
  }
}
