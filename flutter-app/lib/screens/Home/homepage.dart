import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pim/models/currentOffre.dart';
import 'package:pim/screens/profile/components/loader.dart';
import './LiveFeed.dart';
import 'dart:math' as math;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/services/admob_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import '../../constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pim/models/currentweather.dart';
import 'dart:convert';
import 'dart:async';
import 'package:xml2json/xml2json.dart';
import 'population_tunisie.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return homePage();
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool isTrafic = true;
  Future data;
  int count = 0;
  double nombredelitreparcentkilo;
  Weatherr weam, weat, weaa, weap;
  LatLng positionA, positionB;
  Timer timer;
  int timeAtA, timeAtB, dureeAuto;
  String profession, typeVoiture;
  double revenu, taux = 0;
  bool isLoaded;
  SharedPreferences preferences;
  int idAuto, annee;
  String marque, model;

  Future<Weatherr> _getapiweathermonastir() async {
    var data = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=monastir&APPID=65a0a4c91ec65aa07f83a60edee8748d');
    var jsondata = jsonDecode(data.body);

    weam = new Weatherr(
      description: jsondata["weather"][0]["description"] as String,
      temp: jsondata["main"]["temp"] as double,
      windspeed: jsondata["wind"]["speed"] as double,
      pressure: jsondata["main"]["pressure"] as int,
      humidity: jsondata["main"]["humidity"] as int,
      clouds: jsondata["clouds"]["all"] as int,
      sunrise: jsondata["sys"]["sunrise"] as int,
      sunset: jsondata["sys"]["sunset"] as int,
    );
    // setState(() {
    //   weam = w;
    // });
  }

  Future<Weatherr> _getapiweatherariana() async {
    var data = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=ariana&APPID=65a0a4c91ec65aa07f83a60edee8748d');
    var jsondata = jsonDecode(data.body);
    weaa = new Weatherr(
      description: jsondata["weather"][0]["description"] as String,
      temp: jsondata["main"]["temp"] as double,
      windspeed: jsondata["wind"]["speed"] as double,
      pressure: jsondata["main"]["pressure"] as int,
      humidity: jsondata["main"]["humidity"] as int,
      clouds: jsondata["clouds"]["all"] as int,
      sunrise: jsondata["sys"]["sunrise"] as int,
      sunset: jsondata["sys"]["sunset"] as int,
    );
    // setState(() {
    //   weaa = w;
    // });
  }

  Future<Weatherr> _getapiweathertunis() async {
    var data = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=tunis&APPID=65a0a4c91ec65aa07f83a60edee8748d');
    var jsondata = jsonDecode(data.body);
    weat = new Weatherr(
      description: jsondata["weather"][0]["description"] as String,
      temp: jsondata["main"]["temp"] as double,
      windspeed: jsondata["wind"]["speed"] as double,
      pressure: jsondata["main"]["pressure"] as int,
      humidity: jsondata["main"]["humidity"] as int,
      clouds: jsondata["clouds"]["all"] as int,
      sunrise: jsondata["sys"]["sunrise"] as int,
      sunset: jsondata["sys"]["sunset"] as int,
    );
    // setState(() {
    //   weat = w;
    // });
  }

  Future<Weatherr> _getapiweatherataspecificpoint(
      String lat, String lon) async {
    var data = await http.get(
        'https://api.openweathermap.org/data/2.5/onecall?lat=' +
            lat +
            '&lon=' +
            lon +
            '&&appid=65a0a4c91ec65aa07f83a60edee8748d');
    var jsondata = jsonDecode(data.body);
    Weatherr w = new Weatherr(
      description: jsondata["current"]["weather"][0]["description"] as String,
    );
    setState(() {
      weap = w;
    });
    return w;
  }

  Future<List> gethefuelconsumption(
      String year, String make, String model) async {
    var client = new http.Client();
    final myTransformer = Xml2Json();
    String url =
        "https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=" +
            year +
            "&make=" +
            make +
            "&model=" +
            model;
    print(url);
    return await client.get(url).then((response) {
      return response.body;
    }).then((bodyString) {
      myTransformer.parse(bodyString);
      var json = myTransformer.toGData();
      client
          .get("https://www.fueleconomy.gov/ws/rest/ympg/shared/ympgVehicle/" +
              jsonDecode(json)['menuItems']["menuItem"][0]["value"]["\$t"])
          .then((response) {
        return response.body;
      }).then((bodyString) {
        myTransformer.parse(bodyString);
        var json = myTransformer.toGData();
        String kkk = jsonDecode(json)['yourMpgVehicle']["avgMpg"]["\$t"];

        nombredelitreparcentkilo = 235.215 / double.parse(kkk);
      });
    });
  }

  bool liveFeed = false;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  bool _load = false;
  File _pic;
  List _result;
  String _confidence = "";
  String _fingers = "";

  String numbers = '';
  final ams = AdMobService();
  File imageFile = null;
  List<CameraDescription> cameras;

  void dispose() {
    super.dispose();
    Tflite.close();
  }

  loadMyModel() async {
    var res = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model_unquant.tflite");

    print("Result after Loading the Model is : $res");
  }

  chooseImage() async {
    File _img = await ImagePicker.pickImage(source: ImageSource.camera);

    if (_img == null) return;

    setState(() {
      _load = true;
      _pic = _img;
      applyModelonImage(_pic);
    });
  }

  applyModelonImage(File file) async {
    var _res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _load = false;
      _result = _res;
      String str = _result[0]["label"];

      _fingers = str.substring(2);
      _confidence = _result != null
          ? (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%"
          : "";
    });
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  Future<void> camarea() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  @override
  void initState() {
    Admob.initialize();
    super.initState();

    data = getStringValuesSF().then((sp) => _getallofrres().then((value) =>
        _getapiweathermonastir().then((value) =>
            _getapiweatherariana().then((value) => _getapiweathertunis()))));
    isLoaded = true;

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      _updateUserLocation(
          LatLng(location.coords.latitude, location.coords.longitude));
      positionA = LatLng(location.coords.latitude, location.coords.longitude);
      timeAtA = DateTime.now().millisecondsSinceEpoch;

      print("positionA : " +
          positionA.latitude.toString() +
          "," +
          positionA.longitude.toString());
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      _updateUserLocation(
          LatLng(location.coords.latitude, location.coords.longitude));
      positionA = LatLng(location.coords.latitude, location.coords.longitude);
      timeAtA = DateTime.now().millisecondsSinceEpoch;

      print("positionA : " +
          positionA.latitude.toString() +
          "," +
          positionA.longitude.toString());
    });

    bg.BackgroundGeolocation.onProviderChange(
        (bg.ProviderChangeEvent event) {});

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: true,
      startOnBoot: true,
      debug: true,
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
    _load = true;
    loadMyModel().then((v) {
      setState(() {
        _load = false;
      });
    });

    _getCurrentOfferDetails().then((hasCurrentOffer) {
      if (hasCurrentOffer != null) {
        hasCurrentOffer.typeoffre == 0
            ? taux += 0.01
            : hasCurrentOffer.typeoffre == 1
                ? taux += 0.02
                : taux += 0.03;
        gethefuelconsumption(this.annee.toString(), this.marque, this.model)
            .then((fuel) {
          _getLocation().then((value) {
            positionA = LatLng(value.latitude, value.longitude);
            timeAtA = DateTime.now().millisecondsSinceEpoch;
            var sunday = 1;
            var saturday = 6;
            var dataNewYear = DateTime(2021, 01, 01);
            var dateRevolutionandYouthDay = DateTime(2021, 01, 14);
            var dateaujourdui = DateTime.now();
            if (dateaujourdui.difference(dataNewYear).inDays == 0 ||
                dateaujourdui.difference(dateRevolutionandYouthDay).inDays ==
                    0) {}
            _getapiweatherataspecificpoint(positionA.latitude.toString(),
                    positionA.longitude.toString())
                .then((weather) {
              taux += this.typeVoiture.compareTo("Taxi") == 0 ? 0.02 : 0.01;
              taux +=
                  this.typeVoiture.compareTo(tr("Utility")) == 0 ? 0.015 : 0.01;
              taux += DateTime.now().hour >= 8 && DateTime.now().hour <= 10
                  ? 0.04
                  : 0.01;
              taux += DateTime.now().hour >= 16 && DateTime.now().hour <= 19
                  ? 0.04
                  : 0.01;
              taux +=
                  weather.description.compareTo("clear sky") == 0 ? 0.01 : 0.0;
              taux += DateTime.now().weekday == sunday ||
                      DateTime.now().weekday == saturday
                  ? 0.025
                  : 0.01;
              if (gouvernorats[hasCurrentOffer.gouvernorat.toLowerCase()] !=
                  null)
                taux +=
                    gouvernorats[hasCurrentOffer.gouvernorat.toLowerCase()] *
                        0.02;
              print("taux = " + taux.toString());
              timer = Timer.periodic(Duration(seconds: 20), (Timer t) {
                Future<Position> p = _getLocation();
                p.then((value) {
                  _getPlaceNameFromAPI(value).then((placeName) {
                    print(placeName);
                    if (placeName
                        .toLowerCase()
                        .contains(hasCurrentOffer.gouvernorat.toLowerCase())) {
                      print("taux = " + taux.toString());
                      _updateUserLocation(
                          LatLng(value.latitude, value.longitude));
                      _getTrafficFromAPI(value).then((result) async {
                        if (result != 0) {
                          int currentSpeed =
                              result["flowSegmentData"]["currentSpeed"];
                          int freeFlowSpeed =
                              result["flowSegmentData"]["freeFlowSpeed"];
                          double montant = ((freeFlowSpeed > currentSpeed)
                                  ? (1 / (currentSpeed)) * 1.7
                                  : (1 / (currentSpeed)) * 0.5) *
                              taux /
                              2000;
                          String url = link +
                              '/updateAutoSolde/' +
                              this.idAuto.toString() +
                              '/' +
                              montant.toString();
                          http.Response response = await http.put(url);
                        } else {
                          // if (positionB.latitude == positionA.latitude &&
                          //     positionB.longitude == positionA.longitude) {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => Stack(
                          //                 children: [
                          //                   CameraLiveScreen(
                          //                     cameras,
                          //                     //setRecognitions,
                          //                     math.max(_imageHeight, _imageWidth),
                          //                     math.min(_imageHeight, _imageWidth),
                          //                     _recognitions,
                          //                   ),
                          //                 ],
                          //               )));
                          // }

                          print("TomTom non disponible !!!!");
                          positionB = LatLng(value.latitude, value.longitude);
                          timeAtB = DateTime.now().millisecondsSinceEpoch;
                          print("positionB : " +
                              positionB.latitude.toString() +
                              "," +
                              positionB.longitude.toString());
                          dureeAuto = (timeAtB - timeAtA) ~/ 1000;
                          print("Time In traffic : " + dureeAuto.toString());
                          Future<Map<String, dynamic>> object =
                              _getDurationFromAPI();
                          object.then((value) async {
                            print("Duration from API : " +
                                value["rows"][0]["elements"][0]
                                        ["duration_in_traffic"]["value"]
                                    .toString());
                            double montant = 0.0;
                            int durationInTraffic = value["rows"][0]["elements"]
                                [0]["duration_in_traffic"]["value"];
                            int duration = value["rows"][0]["elements"][0]
                                ["duration"]["value"];
                            int distance = value["rows"][0]["elements"][0]
                                ["distance"]["value"];
                            print('durationInTraffic : ' +
                                durationInTraffic.toString() +
                                ' duration : ' +
                                duration.toString() +
                                ' distance : ' +
                                distance.toString());
                            if ((durationInTraffic > duration) &&
                                (duration < 60)) {
                              count++;
                            }
                            if (count == 3) {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Stack(
                              //               children: [
                              //                 CameraLiveScreen(
                              //                   cameras,
                              //                   //setRecognitions,
                              //                   math.max(_imageHeight, _imageWidth),
                              //                   math.min(_imageHeight, _imageWidth),
                              //                   _recognitions,
                              //                 ),
                              //               ],
                              //             )));
                              //  _settingModalBottomSheet(context);
                              count = 0;
                            }
                            montant = duration != 0
                                ? ((durationInTraffic > duration) &&
                                                (duration < 60) &&
                                                isTrafic
                                            ? (1 / (distance / duration)) *
                                                    0.7 *
                                                    (taux / 2000) +
                                                ((distance * 0.01) /
                                                        nombredelitreparcentkilo) *
                                                    2
                                            : (1 / (distance / duration)) *
                                                0.3) *
                                        (taux / 2000) +
                                    ((distance * 0.01) /
                                            nombredelitreparcentkilo) *
                                        2
                                : taux/2000;

                            String url = link +
                                '/updateAutoSolde/' +
                                this.idAuto.toString() +
                                '/' +
                                montant.toString();
                            print(url);
                            http.Response response = await http.put(url);
                            int statusCode = response.statusCode;
                            String body = response.body;
                            positionA = positionB;
                            timeAtA = DateTime.now().millisecondsSinceEpoch;
                            print("positionA : " +
                                positionA.latitude.toString() +
                                "," +
                                positionA.longitude.toString());
                          });
                        }
                      });
                    }
                  });
                });
              });
            });
          });
        });
      }
    });

    // });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future predict(File image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      _recognitions = recognitions;
    });
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":
        imageFile = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 90);
        break;

      case "camera":
        imageFile = await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        break;
    }
    if (imageFile != null) {
      await predict(imageFile);
      if (_recognitions[0]["label"].toString().compareTo("1 car") == 0) {
        isTrafic = true;
      }
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Gallery'),
                    onTap: () => {
                          imageSelector(context, "gallery"),
                          Navigator.pop(context),
                        }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<String> _getPlaceNameFromAPI(Position location) async {
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' +
        location.latitude.toString() +
        ',' +
        location.longitude.toString() +
        '&key=AIzaSyBdOzsXZBYAvN47ZtcKg3yv4tEGAv00Jow';
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, dynamic> object = json.decode(response.body);
    return object["plus_code"]["compound_code"];
  }

  Future<Map<String, dynamic>> _getDurationFromAPI() async {
    String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=matric&origins=' +
            positionA.latitude.toString() +
            ',' +
            positionA.longitude.toString() +
            '&destinations=' +
            positionB.latitude.toString() +
            ',%20' +
            positionB.longitude.toString() +
            '&traffic_model=optimistic&departure_time=now&key=AIzaSyBdOzsXZBYAvN47ZtcKg3yv4tEGAv00Jow';
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, dynamic> object = json.decode(response.body);
    return object;
  }

  Future<dynamic> _getTrafficFromAPI(Position position) async {
    String url =
        'https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/json?' +
            'key=y8YumiqaWstnkFgziG10gKhJYQI7B9Zf&point=' +
            position.latitude.toString() +
            ',' +
            position.longitude.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, dynamic> object = json.decode(response.body);
    if (statusCode == 400) return 0;
    return object;
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.idAuto = prefs.getInt('idAuto');
    this.profession = prefs.getString("profession");
    this.typeVoiture = prefs.getString("typeVoiture");
    this.marque = prefs.getString("marque");
    this.model = prefs.getString("model");
    this.annee = prefs.getInt("annee");
    this.revenu = prefs.getDouble("revenu");
    return "stringValue";
  }

  Future<Position> _getLocation() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    Position userLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return userLocation;
  }

  _updateUserLocation(LatLng userLocation) async {
    String url = link + '/userLocation/' + this.idAuto.toString();
    print(url);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"latitude": ' +
        userLocation.latitude.toString() +
        ',"longitude" : "' +
        userLocation.longitude.toString() +
        '","isOnline" : 1 }';
    http.Response response = await http.put(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
  }

  Future<CurrentOffer> _getCurrentOfferDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.idAuto = prefs.getInt('idAuto');
    String url = link + '/currentOffer/' + this.idAuto.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    CurrentOffer co = CurrentOffer();
    if (statusCode == 200) {
      co = CurrentOffer.fromJson(jsonDecode(response.body));
    }
    Map<String, dynamic> object = jsonDecode(response.body);
    this.typeVoiture = prefs.getString("typeVoiture");
    this.marque = prefs.getString("marque");
    this.model = prefs.getString("model");
    this.annee = prefs.getInt("annee");
    return co;
  }

  List<Offre> offres = new List<Offre>();
  Future<List<Offre>> _getallofrres() async {
    var data = await http.get(link + '/offre');
    var jsondata = json.decode(data.body);
    for (var u in jsondata) {
      Offre o = Offre(
          idOffre: u["idOffre"],
          idAnnonceur: u["idAnnonceur"],
          description: u["description"],
          gouvernorat: u["gouvernorat"],
          dateDeb: u["dateDeb"],
          dateFin: u["dateFin"],
          likes: u["likes"],
          nbrdefois: u['nbrdefois'],
          somme: u['somme'],
          nbCandidats: u["nbCandidats"],
          entreprise: u["entreprise"],
          imageOffer: u["imageOffer"]);
      offres.add(o);
    }
    return offres;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<dynamic>(
            future: data,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(padding: EdgeInsets.all(20), children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Best Offers',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                        items: [
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: Image.network(
                                        link + "/file/" + offres[0].imageOffer)
                                    .image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  offres[0].entreprise,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(offres[0].description),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: Image.network(
                                        link + "/file/" + offres[1].imageOffer)
                                    .image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  offres[1].entreprise,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(offres[1].description),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: Image.network(
                                        link + "/file/" + offres[2].imageOffer)
                                    .image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  offres[2].entreprise,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(offres[2].description),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "eWalle",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'ubuntu',
                                    fontSize: 25),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        tr("Account Overview"),
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'avenir'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this.revenu.toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  tr("Current Balance"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            FloatingActionButton(onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stack(
                                            children: [
                                              CameraLiveScreen(
                                                cameras,
                                                math.max(
                                                    _imageHeight, _imageWidth),
                                                math.min(
                                                    _imageHeight, _imageWidth),
                                                _recognitions,
                                              ),
                                            ],
                                          )));
                            })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr('Weather'),
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'avenir'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black45,
                                    BlendMode.darken,
                                  ),
                                  child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvPB7Djw-zFhL-NsRdwFbMijQBa5LC1U5qbbt9iu5C-_kNuHJTr4qNNYc_rthfOuewNNk&usqp=CAU',
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Ariana',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        1617771265 * 1000))
                                                .toString() +
                                            '\n' +
                                            DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        weaa.sunset * 1000))
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    SizedBox(height: 40),
                                    Text(
                                      ((weaa.temp) - 273.15)
                                              .round()
                                              .toString() +
                                          '°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Text(weaa.description,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black45,
                                    BlendMode.darken,
                                  ),
                                  child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2b_4eMU8_uAuHffjqRVwmW8p-tJC-ZLbnEw&usqp=CAU',
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Monastir',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        1617771265 * 1000))
                                                .toString() +
                                            '\n' +
                                            DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        weam.sunset * 1000))
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    SizedBox(height: 40),
                                    Text(
                                      ((weam.temp) - 273.15)
                                              .round()
                                              .toString() +
                                          '°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Text(weam.description,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black45,
                                    BlendMode.darken,
                                  ),
                                  child: Image.network(
                                    'https://i.pinimg.com/originals/80/3b/17/803b171069ba7af8929e2c8a617ccd40.jpg',
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Tunis',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        weat.sunrise * 1000))
                                                .toString() +
                                            '\n' +
                                            DateFormat.Hm()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        weat.sunset * 1000))
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    SizedBox(height: 40),
                                    Text(
                                      ((weat.temp) - 273.15)
                                              .round()
                                              .toString() +
                                          '°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Text(weat.description,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: ColorLoader3());
              }
            }));
  }

  Column serviceWidget(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png'))),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Container avatarWidget(String img, String name) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 150,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Theme.of(context).primaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/images/$img.png'),
                    fit: BoxFit.contain),
                border: Border.all(color: Colors.black, width: 2)),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}

class Location {
  final String text;
  final String timing;
  final int temperature;
  final String weather;
  final String imageUrl;

  Location({
    this.text,
    this.timing,
    this.temperature,
    this.weather,
    this.imageUrl,
  });
}
