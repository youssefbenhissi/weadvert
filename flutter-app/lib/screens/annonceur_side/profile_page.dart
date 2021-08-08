import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pim/constants.dart';
import 'package:pim/models/annonceur.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:pim/services/payment-service.dart';
import 'package:pim/theme/colors.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Annonceur annonceur = Annonceur();
  bool isLoaded = false;

  Future getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    annonceur.idAnnonceur = prefs.getInt('idAnnonceur');
    annonceur.image = prefs.getString('image');
    annonceur.entreprise = prefs.getString('entreprise');

    return "rrrrrrrrr";
  }

  int sommedescouts;
  _getallofrresparregion(String region) async {
    String url = link + '/sommedescouts';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"region": "' + region + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);

    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      setState(() {
        sommedescouts = u["somme"] as int;
      });
    }
  }

  _cleargetallofrresparregion(String region, String somme) async {
    String url = link + '/clearsommedescouts';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"region": "' + region + '", "somme": "' + somme + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);
  }

  Future<void> _getallofrres(String id) async {
    String url = link + '/statpayment';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"idAnnonceur": "' + id + '"}';

    http.Response response = await http.post(url, headers: headers, body: j);

    var jsondata = json.decode(response.body);

    final List data = jsondata;

    data.forEach((element) {
      try {
        ydata.add(double.parse(element["valeur"].toString()));
        axisdata.add(element['semester'].toString());
      } catch (e) {
        print(e);
      }
    });
    setState(() {
      isLoaded = true;
    });
  }

  final List<String> axisdata = [];
  final List<double> ydata = [];
  Future data;
  @override
  void initState() {
    super.initState();

    getStringValuesSF().then((value) =>
        _getallofrresparregion(annonceur.idAnnonceur.toString()) &
        _getallofrres(annonceur.idAnnonceur.toString()));

    StripeService.init();
  }

  TextEditingController dateOfBirth = TextEditingController(text: "04-19-1992");
  TextEditingController password = TextEditingController(text: "123456");
  @override
  Widget build(BuildContext context) {
    if ((isLoaded))
      return Scaffold(
        backgroundColor: grey.withOpacity(0.05),
        body: EasyRefresh(
          onRefresh: () async {
            ydata.clear();
            axisdata.clear();
            getStringValuesSF().then((value) =>
                _getallofrresparregion(annonceur.idAnnonceur.toString()) &
                _getallofrres(annonceur.idAnnonceur.toString()));
            _getallofrresparregion(annonceur.idAnnonceur.toString());
            _getallofrres(annonceur.idAnnonceur.toString());
          },
          child: getBody(),
        ),
      );
    else
      return Center(child: ColorLoader3());
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: (sommedescouts * 100).toString(), currency: 'USD');
    await dialog.hide();
    await _cleargetallofrresparregion(
        annonceur.idAnnonceur.toString(), sommedescouts.toString());
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.01),
                    spreadRadius: 10,
                    blurRadius: 3,
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
                        tr("Payment"),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        width: (size.width - 40) * 0.4,
                        child: Container(
                          child: Stack(
                            children: [
                              RotatedBox(
                                quarterTurns: -2,
                                child: CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: grey.withOpacity(0.3),
                                    radius: 110.0,
                                    lineWidth: 6.0,
                                    percent: 0.53,
                                    progressColor: primary),
                              ),
                              Positioned(
                                top: 16,
                                left: 13,
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: annonceur.image == null
                                          ? DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/Profile Image.png"),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: Image.network(link +
                                                      "/file/" +
                                                      annonceur.image)
                                                  .image,
                                              fit: BoxFit.cover)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: (size.width - 40) * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              annonceur.entreprise,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 3,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 25, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr("Total Payments"),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "\$" + sommedescouts.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: white),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: white)),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: FlatButton(
                                child: Text(
                                  tr('Pay'),
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                textColor: Colors.white,
                                onPressed: () {
                                  payViaNewCard(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 21),
                          blurRadius: 53,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tr("Payment Statistics"),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: blue),
                        ),
                        SizedBox(height: 30),
                        AspectRatio(
                          aspectRatio: 1.7,
                          child: BarChart(
                            BarChartData(
                              barGroups: getBarGroups(ydata),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: SideTitles(
                                  showTitles: false,
                                ),
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: getWeek,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  getBarGroups(List<double> data) {
    List<BarChartGroupData> barChartGroups = [];
    ydata.asMap().forEach(
          (i, value) => barChartGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  y: value,
                  width: 16,
                )
              ],
            ),
          ),
        );
    return barChartGroups;
  }

  String getWeek(double value) {
    switch (value.toInt()) {
      case 0:
        return 'semestre 1';
      case 1:
        return 'semestre 2';
      case 2:
        return 'semestre 3';
      case 3:
        return 'semestre 4';
      default:
        return '';
    }
  }
}
