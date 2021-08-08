import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:pim/models/userLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'example_popup.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class CurrentUsersPositions extends StatefulWidget {
  final PopupSnap popupSnap;

  CurrentUsersPositions(this.popupSnap);

  @override
  _CurrentUsersPositionsState createState() => _CurrentUsersPositionsState();
}

class _CurrentUsersPositionsState extends State<CurrentUsersPositions> {
  List<Marker> markers = [];
  MapController mapController = MapController();
  List<UserLocation> users = new List<UserLocation>();
  Timer timer;
  final PopupController _popupLayerController = PopupController();
  List<UserLocation> usersHistory = new List<UserLocation>();
  int idAnnonceur;

  SharedPreferences preferences;

  _getUsers() async {
    String url = link + '/offreAutos/' + this.idAnnonceur.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    if (statusCode == 200) {
      users = UserLocation.fromJson(jsonDecode(response.body));
      users.forEach((element) {
        if (element.isOnline == 1) {
          setState(() {
            markers.add(Marker(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.15,
              point: LatLng(element.latitude, element.longitude),
              builder: (ctx) => Container(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/car_marker.png'),
                  )),
                ),
              ),
            ));
          });
        }
      });
      users.forEach((element) {
        usersHistory.add(element);
      });
    }
  }

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAnnonceur = preferences.getInt('idAnnonceur');
  }

  @override
  void initState() {
    super.initState();
    getSP().then((value) => _getUsers());
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        _popupLayerController.hidePopup();
        this.usersHistory = users;
        this.markers.clear();
        this.users.clear();
      });
      _getUsers();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new FlutterMap(
            options: new MapOptions(
              center: new LatLng(36.84997994617216, 10.166937921804967),
              maxZoom: 30,
              plugins: [PopupMarkerPlugin()],
              onTap: (_) => _popupLayerController.hidePopup(),
            ),
            layers: [
              new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/bbs21/cklmfh21h3b1m17msg2c340o5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYmJzMjEiLCJhIjoiY2tocnV4NGRyMGR5MjM1bGh5ZW1rbm9vciJ9.QVeVxhXuHmFoZA4Ugium4w",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiYmJzMjEiLCJhIjoiY2tocnV4NGRyMGR5MjM1bGh5ZW1rbm9vciJ9.QVeVxhXuHmFoZA4Ugium4w',
                  'id': 'mapbox.streets',
                },
              ),
              MarkerLayerOptions(markers: markers),
              PopupMarkerLayerOptions(
                  markers: markers,
                  popupSnap: widget.popupSnap,
                  popupController: _popupLayerController,
                  popupBuilder: (BuildContext _, Marker marker) {
                    UserLocation u;
                    usersHistory.length != 0
                        ? u = usersHistory.elementAt(markers.indexOf(marker))
                        : u = users.elementAt(markers.indexOf(marker));
                    return ExamplePopup(
                      marker,
                      user: u,
                    );
                  }),
            ],
            mapController: mapController));
  }
}
