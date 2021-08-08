import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pim/models/currentOffre.dart';
import 'package:pim/screens/profile/components/pitem.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:user_location/user_location.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import 'loader.dart';
import 'dart:async';

class CurrentOffre extends StatefulWidget {
  @override
  _CurrentOffreState createState() => _CurrentOffreState();
}

class _CurrentOffreState extends State<CurrentOffre> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];
  LatLng position;
  CurrentOffer co;
  Future data;
  bool isLoaded = false;
  int isFollowing;
  bool swiped = false;
  Timer timer;
  SharedPreferences preferences;
  int idAuto;

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    idAuto = preferences.getInt('idAuto');
  }

  Future _getCurrentOfferDetails() async {
    preferences = await SharedPreferences.getInstance();
    idAuto = preferences.getInt('idAuto');
    String url = link + '/currentOffer/' + this.idAuto.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    if (statusCode == 200) {
      co = CurrentOffer.fromJson(jsonDecode(response.body));
    } else
      co = null;

    url = link +
        '/isFollowing/' +
        this.idAuto.toString() +
        '/' +
        co.idAnnonceur.toString();
    response = await http.get(url);
    statusCode = response.statusCode;
    headers = response.headers;
    contentType = headers['content-type'];
    if (statusCode == 200) {
      this.isFollowing = int.parse(response.body.substring(
          response.body.indexOf(":") + 1, response.body.indexOf("}")));
    }
    return co;
  }

  Future<double> _getAutoSolde() async {
    String url = link + '/autoSolde/' + this.idAuto.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    double solde;
    if (statusCode == 200) {
      List<dynamic> object = json.decode(response.body);
      solde = double.parse(object[0]["solde"].toString());
    }
    return solde;
  }

  @override
  void initState() {
    super.initState();
    data = getSP().then((value) => _getCurrentOfferDetails());
    this.isLoaded = true;

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );

    timer = Timer.periodic(Duration(seconds: 20), (Timer t) {
      _getAutoSolde().then((newSolde) {
        setState(() {
          this.co.solde = newSolde;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (isLoaded)
      return Scaffold(
          body: FutureBuilder<dynamic>(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    child: Stack(children: [
                      new FlutterMap(
                          options: new MapOptions(
                            center: new LatLng(
                                36.84997994617216, 10.166937921804967),
                            maxZoom: 30,
                            plugins: [UserLocationPlugin()],
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
                            userLocationOptions,
                          ],
                          mapController: mapController),
                      Container(
                        child: ShapeOfView(
                          shape: ArcShape(
                            direction: ArcDirection.Outside,
                            height: 45,
                            position: ArcPosition.Bottom,
                          ),
                          child: Container(
                              height: height * 0.23, color: Colors.white10),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            height: height * 0.2,
                            width: width * 0.4,
                            child: CircleAvatar(
                              backgroundColor: kPrimaryLightColor,
                              child: Text(
                                this.co == null
                                    ? "0 \n TND"
                                    : this.co.solde.toString() + "\n TND",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            this.swiped = !this.swiped;
                          });
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: swiped == true
                                ? MediaQuery.of(context).size.height * 0.25
                                : MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 60.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: this.co == null
                                        ? Text(
                                            tr("no_offer"),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              PItem(this.co, this.isFollowing,this.idAuto),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  FollowCard(
                                                    title: tr("start_date"),
                                                    subtitle: this.co.dateDeb,
                                                  ),
                                                  FollowCard(
                                                    title: tr("end_date"),
                                                    subtitle: this.co.dateFin,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: ColorLoader3());
                }
              }));
    else
      return Center(child: ColorLoader3());
  }
}

class FollowCard extends StatelessWidget {
  final title;
  final subtitle;

  const FollowCard({Key key, this.title, this.subtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Colors.black38,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
