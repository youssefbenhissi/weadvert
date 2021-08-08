import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/constants.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/screens/offres_cote_automobiliste/models/company.dart';

class CompanyTab extends StatelessWidget {
  final Offre company;
  CompanyTab({this.company});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 35.0),
              ),
              Text(
                tr("Nom de l'entreprise"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(company.entreprise, style: TextStyle(fontSize: 19.0))
            ],
          ),
          SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 35.0),
              ),
              Text(
                tr("Email de l'entreprise"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(company.email, style: TextStyle(fontSize: 19.0))
            ],
          ),
          SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 35.0),
              ),
              Text(
                tr("type de l'entreprise"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(company.typeEntre, style: TextStyle(fontSize: 19.0))
            ],
          ),
        ],
      ),
    );
  }
}
