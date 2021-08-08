import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pim/constants.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/narrow_app_bar.dart';
import 'candidate_profile.dart';
import 'package:easy_localization/easy_localization.dart';

class Candidates extends StatefulWidget {
  @override
  _CandidatesState createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates> {
  int idAnnonceur;
  List<Map<String, dynamic>> object = new List<Map<String, dynamic>>();
  Future data;
  bool isLoaded = false;
  List<Offre> offres = new List<Offre>();
  List<String> selectedCountList = [];
  SharedPreferences preferences;

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAnnonceur = preferences.getInt('idAnnonceur');
  }

  _getAllCandidates() async {
    String url = link + '/allCandidates/' + this.idAnnonceur.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String body = response.body;
    List<dynamic> list = json.decode(response.body);
    object.clear();
    list.forEach((element) {
      object.add(element);
    });
  }

  Future<List<Offre>> _getallofrres() async {
    var data = await http.get(link + '/offre/' + this.idAnnonceur.toString());
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
  void initState() {
    super.initState();
    data = getSP()
        .then((value) => _getallofrres().then((value) => _getAllCandidates()));

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NarrowAppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
        trailing: InkWell(
          onTap: () {
            setState(() {
              data = _getAllCandidates();
              FilterChipDisplay.selectedCities.clear();
              FilterChipDisplay.selectedManufacturer.clear();
              FilterChipDisplay.vehicleType.clear();
            });
          },
          child: Text(
            tr("Tous"),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 5,
            ),
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      tr("offers"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ).copyWith(color: Colors.black),
                    ),
                  ),
                  offres.length > 0
                      ? Container(
                          height: 220,
                          color: Colors.transparent,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _getAllCandidates();
                                    object = this
                                        .object
                                        .where((element) =>
                                            element["description"].toString() ==
                                            offres.elementAt(index).description)
                                        .toList();
                                  });
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      margin: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: Image.network(link +
                                                  "/file/" +
                                                  offres[index].imageOffer)
                                              .image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            offres[index].entreprise,
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
                                                child: Text(
                                                  offres[index].description,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                            itemWidth: 300,
                            itemHeight: 200,
                            itemCount: offres.length,
                            layout: SwiperLayout.STACK,
                          ),
                        )
                      : Center(
                          child: Text(
                          tr("You do not have offers yet"),
                          style: TextStyle(fontSize: 18),
                        )),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.length != 0)
                              object = this
                                  .object
                                  .where((element) =>
                                      element["nom"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element["prenom"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            else
                              object = _getAllCandidates();
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: tr("searchByAuto"),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ).copyWith(color: Color(0xFFE4E0E8))),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Text(
                            tr("nb_candidat"),
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xFF8391A0),
                              fontWeight: FontWeight.w200,
                            ).copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFDB3620)),
                            child: Center(
                              child: Text(
                                object.length.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) {
                                return FilterChipDisplay();
                              }));
                              ScaffoldMessenger.of(context)
                                ..setState(() {
                                  setState(() {
                                    if (FilterChipDisplay
                                                .selectedCities.length !=
                                            0 ||
                                        FilterChipDisplay
                                                .selectedManufacturer.length !=
                                            0 ||
                                        FilterChipDisplay.vehicleType.length !=
                                            0)
                                      object = this
                                          .object
                                          .where((element) =>
                                              FilterChipDisplay.selectedCities
                                                  .contains(element[
                                                      "lieuCirculation"]) ||
                                              FilterChipDisplay
                                                  .selectedManufacturer
                                                  .contains(
                                                      element["marque"]) ||
                                              FilterChipDisplay.vehicleType
                                                  .contains(element["type"]))
                                          .toList();
                                    else
                                      data = _getAllCandidates();
                                  });
                                });
                            },
                            icon: Icon(
                              Icons.filter_list_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: object.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: ListTile(
                                  onTap: () async {
                                    var result = await Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CandidateProfile(object[index]);
                                    }));
                                    ScaffoldMessenger.of(context)
                                      ..setState(() {
                                        setState(() {
                                          data = _getAllCandidates();
                                        });
                                      });
                                  },
                                  title: Text(
                                    object[index]["prenom"],
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: Color(0xFF1A1316),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/icons/location_pin.png",
                                        width: 15.0,
                                        height: 15.0,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "  " + object[index]["lieuCirculation"],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ).copyWith(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  leading: Column(children: [
                                    ClipOval(
                                      child: Image.network(
                                        link +
                                            '/file/' +
                                            this.object[index]["photo"],
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ]),
                                  trailing: SizedBox(
                                    width: 75,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Icon(
                                                  Icons.info,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: object.length,
                          )
                        : Center(
                            child: Text(
                              tr("no_candidates"),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF8391A0),
                                fontWeight: FontWeight.w200,
                              ).copyWith(color: Colors.black),
                            ),
                          ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ColorLoader3());
            }
          }),
    );
  }
}

class FilterChipDisplay extends StatefulWidget {
  static List<String> selectedCities = new List<String>();
  static List<String> selectedManufacturer = new List<String>();
  static List<String> vehicleType = new List<String>();

  @override
  _FilterChipDisplayState createState() => _FilterChipDisplayState();
}

class _FilterChipDisplayState extends State<FilterChipDisplay> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, 'Yep!');
            }),
        title: Text(
          tr("Filter"),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  FilterChipDisplay.selectedCities.clear();
                  FilterChipDisplay.selectedManufacturer.clear();
                  FilterChipDisplay.vehicleType.clear();
                });
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _titleContainer(tr("choose_city")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: <Widget>[
                    filterChipWidgetCity(
                        chipName: 'Tunis',
                        isSelected:
                            FilterChipDisplay.selectedCities.contains('Tunis')),
                    filterChipWidgetCity(
                        chipName: 'Ariana',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Ariana')),
                    filterChipWidgetCity(
                        chipName: 'Ben Arous',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Ben Arous')),
                    filterChipWidgetCity(
                        chipName: 'Manouba',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Manouba')),
                    filterChipWidgetCity(
                        chipName: 'Nabeul',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Nabeul')),
                    filterChipWidgetCity(
                        chipName: 'Zaghouen',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Zaghouen')),
                    filterChipWidgetCity(
                        chipName: 'Bizerte',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Bizerte')),
                    filterChipWidgetCity(
                        chipName: 'Beja',
                        isSelected:
                            FilterChipDisplay.selectedCities.contains('Beja')),
                    filterChipWidgetCity(
                        chipName: 'Jendouba',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Jendouba')),
                    filterChipWidgetCity(
                        chipName: 'Le kef',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Le kef')),
                    filterChipWidgetCity(
                        chipName: 'Kairouan',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Kairouan')),
                    filterChipWidgetCity(
                        chipName: 'Kasserine',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Kasserine')),
                    filterChipWidgetCity(
                        chipName: 'Sidi bouzid',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Sidi bouzid')),
                    filterChipWidgetCity(
                        chipName: 'Sousse',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Sousse')),
                    filterChipWidgetCity(
                        chipName: 'Monastir',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Monastir')),
                    filterChipWidgetCity(
                        chipName: 'Mahdia',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Mahdia')),
                    filterChipWidgetCity(
                        chipName: 'Sfax',
                        isSelected:
                            FilterChipDisplay.selectedCities.contains('Sfax')),
                    filterChipWidgetCity(
                        chipName: 'Gafsa',
                        isSelected:
                            FilterChipDisplay.selectedCities.contains('Gafsa')),
                    filterChipWidgetCity(
                        chipName: 'Tozeur',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Tozeur')),
                    filterChipWidgetCity(
                        chipName: 'Kebili',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Kebili')),
                    filterChipWidgetCity(
                        chipName: 'Gabes',
                        isSelected:
                            FilterChipDisplay.selectedCities.contains('Gabes')),
                    filterChipWidgetCity(
                        chipName: 'Medenine',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Medenine')),
                    filterChipWidgetCity(
                        chipName: 'Tataouine',
                        isSelected: FilterChipDisplay.selectedCities
                            .contains('Tataouine')),
                  ],
                )),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _titleContainer(tr("vehicle_type")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: <Widget>[
                      filterChipWidgetTypeVehicle(
                          chipName: tr('Utility'),
                          isSelected: FilterChipDisplay.vehicleType
                              .contains(tr('Utility'))),
                      filterChipWidgetTypeVehicle(
                          chipName: 'Taxi',
                          isSelected:
                              FilterChipDisplay.vehicleType.contains('Taxi')),
                      filterChipWidgetTypeVehicle(
                          chipName: tr('Particular'),
                          isSelected: FilterChipDisplay.vehicleType
                              .contains(tr('Particular'))),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _titleContainer(tr("choose_manufact")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: <Widget>[
                      filterChipWidgetManufacturer(
                          chipName: 'Citroen',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Citroen')),
                      filterChipWidgetManufacturer(
                          chipName: 'Dacia',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Dacia')),
                      filterChipWidgetManufacturer(
                          chipName: 'Fiat',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Fiat')),
                      filterChipWidgetManufacturer(
                          chipName: 'Hyundai',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Hyundai')),
                      filterChipWidgetManufacturer(
                          chipName: 'Peugeot',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Peugeot')),
                      filterChipWidgetManufacturer(
                          chipName: 'Renault',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Renault')),
                      filterChipWidgetManufacturer(
                          chipName: 'Seat',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Seat')),
                      filterChipWidgetManufacturer(
                          chipName: 'Skoda',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Skoda')),
                      filterChipWidgetManufacturer(
                          chipName: 'Toyota',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Toyota')),
                      filterChipWidgetManufacturer(
                          chipName: 'Volkswagen',
                          isSelected: FilterChipDisplay.selectedManufacturer
                              .contains('Volkswagen')),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class filterChipWidgetCity extends StatefulWidget {
  final String chipName;
  var isSelected = false;

  filterChipWidgetCity({Key key, this.chipName, this.isSelected})
      : super(key: key);

  @override
  _filterChipWidgetCityState createState() => _filterChipWidgetCityState();
}

class _filterChipWidgetCityState extends State<filterChipWidgetCity> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      selected: widget.isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.blue,
      onSelected: (isSelected) {
        setState(() {
          widget.isSelected = isSelected;
          isSelected
              ? FilterChipDisplay.selectedCities.add(widget.chipName)
              : FilterChipDisplay.selectedCities.remove(widget.chipName);
        });
      },
      selectedColor: Colors.grey,
    );
  }
}

class filterChipWidgetManufacturer extends StatefulWidget {
  final String chipName;
  var isSelected = false;

  filterChipWidgetManufacturer({Key key, this.chipName, this.isSelected})
      : super(key: key);

  @override
  _filterChipWidgetManufacturerState createState() =>
      _filterChipWidgetManufacturerState();
}

class _filterChipWidgetManufacturerState
    extends State<filterChipWidgetManufacturer> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      selected: widget.isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.blue,
      onSelected: (isSelected) {
        setState(() {
          widget.isSelected = isSelected;
          isSelected
              ? FilterChipDisplay.selectedManufacturer.add(widget.chipName)
              : FilterChipDisplay.selectedManufacturer.remove(widget.chipName);
        });
      },
      selectedColor: Colors.grey,
    );
  }
}

class filterChipWidgetTypeVehicle extends StatefulWidget {
  final String chipName;
  var isSelected = false;

  filterChipWidgetTypeVehicle({Key key, this.chipName, this.isSelected})
      : super(key: key);

  @override
  _filterChipWidgetTypeVehicleState createState() =>
      _filterChipWidgetTypeVehicleState();
}

class _filterChipWidgetTypeVehicleState
    extends State<filterChipWidgetTypeVehicle> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      selected: widget.isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.blue,
      onSelected: (isSelected) {
        setState(() {
          widget.isSelected = isSelected;
          isSelected
              ? FilterChipDisplay.vehicleType.add(widget.chipName)
              : FilterChipDisplay.vehicleType.remove(widget.chipName);
        });
      },
      selectedColor: Colors.grey,
    );
  }
}
