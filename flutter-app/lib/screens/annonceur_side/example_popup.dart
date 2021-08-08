import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pim/models/userLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:pim/screens/profile/components/loader.dart';

class ExamplePopup extends StatefulWidget {
  final Marker marker;
  final UserLocation user;
  ExamplePopup(this.marker, {this.user, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState(marker);
}

class _ExamplePopupState extends State<ExamplePopup> {
  final Marker _marker;
  String place;
  final List<IconData> _icons = [
    Icons.star_border,
    Icons.star_half,
    Icons.star
  ];
  int _currentIcon = 0;

  _ExamplePopupState(this._marker);

  Future<Map<String, dynamic>> _getPlaceNameFromAPI() async {
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' +
        _marker.point.latitude.toString() +
        ',' +
        _marker.point.longitude.toString() +
        '&key=AIzaSyBdOzsXZBYAvN47ZtcKg3yv4tEGAv00Jow';
    print(url);
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, dynamic> object = json.decode(response.body);
    return object; //["results"][0]["formatted_address"];
  }

  @override
  void initState() {
    super.initState();
    _getPlaceNameFromAPI().then((value) {
      setState(() {
        this.place = value["results"][0]["formatted_address"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.place != null)
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: () => setState(() {
          _currentIcon = (_currentIcon + 1) % _icons.length;
        }),
      ),
    );
    else
     return Center(child: ColorLoader3());
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              tr("user_details"),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              widget.user.nom + " " + widget.user.prenom,
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              tr("place") + this.place == null ? "" : this.place.toString(),
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              tr("revenu_total") + widget.user.solde.toString() + 'TND',
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              tr("offer_description") + widget.user.descriptionOffre.toString(),
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
