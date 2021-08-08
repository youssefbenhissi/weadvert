import 'package:intl/intl.dart';

class Utilisateur {
  int id, verification_code, nbrdefois;
  String email, etat;

  Utilisateur(
    this.id,
    this.etat,
    this.verification_code,
    this.nbrdefois,
    this.email,
  );

  static List<Utilisateur> getAll(List<dynamic> json) {
    List<Utilisateur> list = new List<Utilisateur>();
    for (var item in json) {
      list.add(Utilisateur.fromJson(item));
    }
  }

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      json['id'] as int,
      json['etat'] as String,
      json['verification_code'] as int,
      json['nbrdefois'] as int,
      json['email'] as String,
    );
  }
}
