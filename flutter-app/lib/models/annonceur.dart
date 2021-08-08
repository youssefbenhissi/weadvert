class Annonceur {
  int idAnnonceur;
  String entreprise, typeEntre, email, image, website, telephone;

  Annonceur(
      {this.idAnnonceur,
      this.entreprise,
      this.typeEntre,
      this.email,
      this.image,
      this.telephone,
      this.website});

  factory Annonceur.fromJson(dynamic json) {
    return Annonceur(
      idAnnonceur: json['idAnnonceur'] as int,
      entreprise: json['entreprise'] as String,
      typeEntre: json['typeEntre'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      telephone: json['telephone'] as String,
      website: json['website'] as String,
    );
  }
}
