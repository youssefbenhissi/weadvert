import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/constants.dart';
import 'package:pim/models/offre.dart';

class DescriptionTab extends StatelessWidget {
  final Offre company;
  DescriptionTab({this.company});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 25.0),
          Row(
            children: [
              Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 35.0),
              ),
              Text(
                tr("Description de l'offre"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            children: [
              SizedBox(width: 60),
              Flexible(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                child: Text(company.description,
                    style: kSubtitleStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                        color: Color(0xFF5B5B5B)),
                    softWrap: true),
              ))
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
                tr("nombre de candidature:"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(company.nbCandidats.toString(),
                  style: TextStyle(fontSize: 19.0))
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "•  ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 35.0),
              ),
              Text(
                tr("cout maximal"),
                style: kTitleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(company.cout.toString(), style: TextStyle(fontSize: 19.0))
            ],
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
