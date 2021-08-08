import 'package:intl/intl.dart';

class CurrentOffer {
  int idAnnonceur, typeoffre;
  String annonceur, imgUrl, type;
  double solde;
  String dateDeb, dateFin, gouvernorat;
  static DateFormat formatter = DateFormat('yyyy-MM-dd');

  CurrentOffer(
      {this.idAnnonceur,
      this.annonceur,
      this.imgUrl,
      this.type,
      this.solde,
      this.dateDeb,
      this.dateFin,
      this.typeoffre,
      this.gouvernorat});

  factory CurrentOffer.fromJson(dynamic json) {
    return CurrentOffer(
      idAnnonceur: json['idAnnonceur'] as int,
      annonceur: json['entreprise'] as String,
      imgUrl: json['image'] as String,
      type: json['typeEntre'] as String,
      solde: json['solde'] as double,
      dateDeb: formatter.format(DateTime.parse(json['dateDeb'].toString())),
      dateFin: formatter.format(DateTime.parse(json['dateFin'].toString())),
      typeoffre: json['typeoffre'] as int,
      gouvernorat: json['gouvernorat'] as String,
    );
  }

  @override
  String toString() {
    return 'entreprise: ' + this.annonceur + 'solde : ' + this.solde.toString();
  }
}
