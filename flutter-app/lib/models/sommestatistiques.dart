import 'package:intl/intl.dart';
import 'dart:convert';

class StatistiquesSomme {
  int somme;
  StatistiquesSomme(this.somme);
  factory StatistiquesSomme.fromJson(List<dynamic> json) {
    return StatistiquesSomme(json[0]['somme'] as int);
  }
}
