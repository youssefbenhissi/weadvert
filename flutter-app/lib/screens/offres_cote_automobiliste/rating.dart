import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:pim/constants.dart';

import 'package:http/http.dart' as http;
import '../../models/offre.dart';
import '../annonceur_side/root_app.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmotionsPage(),
    );
  }
}

class EmotionsPage extends StatefulWidget {
  final Offre company;
  EmotionsPage({this.company});
  @override
  _EmotionsPageState createState() => _EmotionsPageState(company: this.company);
}

class _EmotionsPageState extends State<EmotionsPage> {
  Future<int> _ajouterrating(
      int likes, int nbrdefois, int somme, int idoffre) async {
    String url = link + '/ajouterratingoffre';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"likes": "' +
        likes.toString() +
        '","nbrdefois": "' +
        nbrdefois.toString() +
        '","somme": "' +
        somme.toString() +
        '","idoffre": "' +
        idoffre.toString() +
        '"}'; // make POST request

    http.Response response = await http.post(url, headers: headers, body: j);
    print("lahhhhhhhhhhhhhnnnnnnnnnnnneeeeeeeeeeee");
    print(response.statusCode);
    return response.statusCode;
  }

  final Offre company;
  _EmotionsPageState({this.company});
  String feel = "0";
  double _value = 0.0;
  double lastsection = 0.0;
  String feedbacktxt = "Very Poor";
  Color backgroundclr = Colors.red;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("waaaaaaaaaaaaaaaaaaaaaaaaaaa" + company.idOffre.toString());
    print("waaaaaaaaaaaaaaaaaaaaaaaaaaa" + company.likes.toString());
    print("waaaaaaaaaaaaaaaaaaaaaaaaaaa" + company.somme.toString());
    print("waaaaaaaaaaaaaaaaaaaaaaaaaaa" + company.nbrdefois.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundclr,
        body: Stack(
          children: <Widget>[
            Center(
              child: FlareActor(
                'assets/images/feelings.flr',
                fit: BoxFit.contain,
                alignment: Alignment.center,
                animation: feel,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    feedbacktxt,
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Slider(
                  min: 0.0,
                  max: 100.0,
                  value: _value,
                  divisions: 100,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.black,
                  label: tr("Set a value"),
                  onChanged: (val) {
                    setState(() {
                      _value = val;
                    });
                    if (_value == 0.0) {
                      if (lastsection > 0.0) {
                        setState(() {
                          feel = "0-";
                        });
                      }
                      setState(() {
                        lastsection = 0.0;
                        backgroundclr = Colors.red;
                        feedbacktxt = tr("Very Poor");
                      });
                    } else if (_value > 0.0 && _value < 25.0) {
                      if (lastsection == 0.0) {
                        setState(() {
                          feel = "0+";
                        });
                      } else if (lastsection == 50.0) {
                        setState(() {
                          feel = "25-";
                        });
                      }
                      setState(() {
                        lastsection = 25.0;
                        backgroundclr = Colors.orange;
                        feedbacktxt = tr("Poor");
                      });
                    } else if (_value >= 25.0 && _value < 50.0) {
                      if (lastsection == 25.0) {
                        setState(() {
                          feel = "25+";
                        });
                      } else if (lastsection == 75.0) {
                        setState(() {
                          feel = "50-";
                        });
                      }
                      setState(() {
                        lastsection = 50.0;
                        backgroundclr = Colors.orangeAccent;
                        feedbacktxt = tr("Below Average");
                      });
                    } else if (_value >= 50.0 && _value < 75.0) {
                      if (lastsection == 50.0) {
                        setState(() {
                          feel = "50+";
                        });
                      } else if (lastsection == 100.0) {
                        setState(() {
                          feel = "75-";
                        });
                      }
                      setState(() {
                        lastsection = 75.0;
                        backgroundclr = Colors.yellow;
                        feedbacktxt = tr("Above Average");
                      });
                    } else if (_value >= 75.0 && _value <= 100.0) {
                      if (lastsection == 75.0) {
                        setState(() {
                          feel = "75+";
                        });
                      }
                      setState(() {
                        lastsection = 100.0;
                        backgroundclr = Colors.green;
                        feedbacktxt = "Excellent";
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            padding: EdgeInsets.only(left: 18.0, bottom: 25.0, right: 18.0),
            // margin: EdgeInsets.only(bottom: 25.0),
            //color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(width: 15.0),
                Expanded(
                  child: SizedBox(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (lastsection == 0) {
                          _ajouterrating(
                              company.likes,
                              company.nbrdefois + 1,
                              (company.likes / company.nbrdefois + 1).round(),
                              company.idOffre);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                        if (lastsection == 25.0) {
                          _ajouterrating(
                              company.likes + 1,
                              company.nbrdefois + 1,
                              (company.likes + 1 / company.nbrdefois + 1)
                                  .round(),
                              company.idOffre);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                        if (lastsection == 50.0) {
                          _ajouterrating(
                              company.likes + 2,
                              company.nbrdefois + 1,
                              (company.likes + 2 / company.nbrdefois + 1)
                                  .round(),
                              company.idOffre);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                        if (lastsection == 75.0) {
                          _ajouterrating(
                              company.likes + 3,
                              company.nbrdefois + 1,
                              (company.likes + 3 / company.nbrdefois + 1)
                                  .round(),
                              company.idOffre);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                        if (lastsection == 100.0) {
                          print("waaaaaaaaaaaaaaaaaaa" +
                              company.nbrdefois.toString());

                          print("waaaaaaaaaaaaaaaaaaa" +
                              company.likes.toString());
                          _ajouterrating(
                              company.likes + 4,
                              company.nbrdefois + 1,
                              ((company.likes + 4) / (company.nbrdefois + 1))
                                  .round(),
                              company.idOffre);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      },
                      color: kBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        tr("Rate the offer"),
                        style: kTitleStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
