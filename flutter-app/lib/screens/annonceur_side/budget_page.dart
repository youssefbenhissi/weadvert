import 'package:pim/theme/colors.dart';
import 'package:pim/screens/widget/chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../profile/components/loader.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

List days = [
  {"label": "", "day": "28"},
  {"label": "", "day": "29"},
  {"label": "", "day": "30"},
  {"label": "", "day": "1"},
  {"label": "", "day": "2"},
  {"label": "", "day": "3"},
  {"label": "", "day": "4"},
];
List months = [
  {"label": "2021", "day": "Jan"},
  {"label": "2021", "day": "Feb"},
  {"label": "2021", "day": "Mar"},
  {"label": "2021", "day": "Apr"},
  {"label": "2021", "day": "May"},
  {"label": "2021", "day": "Jun"},
];

class _BudgetPageState extends State<BudgetPage> {
  int activeDay = 3;
  bool showAvg = false;
  int _nbOffres, _nbUsers, _totalCout;
  Future data;
  bool isLoaded = false;
  SharedPreferences preferences;
  int idAnnonceur;

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAnnonceur = preferences.getInt('idAnnonceur');
  }

  _getData() async {
    String url = link + '/nbOffres/' + this.idAnnonceur.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    if (statusCode == 200) {
      setState(() {
        this._nbOffres = int.parse(response.body.substring(
            response.body.indexOf(":") + 1, response.body.indexOf("}")));
        print(_nbOffres);
      });
    }

    url = link + '/nbUsers/' + this.idAnnonceur.toString();
    response = await http.get(url);
    statusCode = response.statusCode;
    headers = response.headers;
    contentType = headers['content-type'];
    if (statusCode == 200) {
      setState(() {
        this._nbUsers = int.parse(response.body.substring(
            response.body.indexOf(":") + 1, response.body.indexOf("}")));
        print(_nbOffres);
      });
    }

    url = link + '/totalCout/' + this.idAnnonceur.toString();
    response = await http.get(url);
    statusCode = response.statusCode;
    headers = response.headers;
    contentType = headers['content-type'];
    if (statusCode == 200) {
      setState(() {
        this._totalCout = int.parse(response.body.substring(
            response.body.indexOf(":") + 1, response.body.indexOf("}")));
        print(_nbOffres);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    data = getSP().then((value) => _getData());
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    List expenses = [
      {
        "icon": Icons.business_center_rounded,
        "color": blue,
        "label": "Offres",
        "cost": _nbOffres.toString()
      },
      {
        "icon": Icons.drive_eta,
        "color": red,
        "label": "Automobilistes",
        "cost": _nbUsers.toString()
      },
    ];
    if (isLoaded)
      return FutureBuilder<dynamic>(
        future: data,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: white, boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 60, right: 20, left: 20, bottom: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dashboard",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              Icon(AntDesign.search1)
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(months.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activeDay = index;
                                    });
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        6,
                                    child: Column(
                                      children: [
                                        Text(
                                          months[index]['label'],
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: activeDay == index
                                                  ? primary
                                                  : black.withOpacity(0.02),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: activeDay == index
                                                      ? primary
                                                      : black
                                                          .withOpacity(0.1))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12,
                                                top: 7,
                                                bottom: 7),
                                            child: Text(
                                              months[index]['day'],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: activeDay == index
                                                      ? white
                                                      : black),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cout annonces",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Color(0xff67727d)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    this._totalCout.toString() + " TND",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: (size.width - 20),
                                height: 150,
                                child: LineChart(
                                  mainData(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                      spacing: 20,
                      children: List.generate(expenses.length, (index) {
                        return Container(
                          width: (size.width - 60) / 2,
                          height: 170,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.01),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: expenses[index]['color']),
                                  child: Center(
                                      child: Icon(
                                    expenses[index]['icon'],
                                    color: white,
                                  )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expenses[index]['label'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      expenses[index]['cost'] == null
                                          ? ""
                                          : expenses[index]['cost'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ColorLoader3());
          }
        },
      );
    else
      return Center(child: ColorLoader3());
  }
}
