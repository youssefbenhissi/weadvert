class courbe {
  int semester;
  int valeur;
  courbe({this.semester, this.valeur});
  factory courbe.fromJson(dynamic json) {
    return courbe(
      semester: json['semester'] as int,
      valeur: json['valeur'] as int,
    );
  }
}
