import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:http/http.dart' as http;
import 'package:pim/constants.dart';
import 'package:pim/models/courbestat.dart';
import 'package:pim/models/sommestatistiques.dart';
import 'package:pim/services/admob_service.dart';
import 'package:pim/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final ams = AdMobService();
  int _nbOffres, _nbUsers, _totalCout;
  int activeDay = 3;
  Future data;
  StatistiquesSomme s;
  StatistiquesSomme s1;
  List<courbe> offres = new List<courbe>();
  bool showAvg = false;
  final List<String> axisdata = [];
  final List<num> ydata = [];
  SharedPreferences preferences;
  int idAnnonceur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: EasyRefresh(
        onRefresh: () async {
          axisdata.clear();
          ydata.clear();

          _getData();
        },
        child: getBody(),
      ),
    );
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

    data = getSP().then((value) => _getData());
  }

  Widget buildchart() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Echarts(
        option: '''              

option = {
    title: {
        text: ''
    },
    
    toolbox: {
        show: true,
        feature: {
            magicType: {
                type: ['line', 'tiled','bar']
            },
            
        }
    },
    tooltip: {
            trigger: 'axis',
            showContent: true
        },
     dataset: {
            source: [
               ${jsonEncode(axisdata)},
                ${jsonEncode(ydata)},
                
            ]
        },   
   xAxis: {type: 'category'},
        yAxis: {gridIndex: 0},
        grid: {top: '5%',left:'5%'},
    series: [
            {type: 'line', smooth: true, seriesLayoutBy: 'row', markPoint: {
                data: [
                    {type: 'max', name: 'max'},
                    {type: 'min', name: 'min'}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: 'average'}
                ]
            }},
           
        ],
    animationEasing: 'elasticOut',
    animationDelayUpdate: function (idx) {
        return idx * 5;
    }
}
    
                  ''',
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    List expenses = [
      {
        "icon": Icons.business_center_rounded,
        "color": blue,
        "label": tr("offers"),
        "cost": _nbOffres.toString()
      },
      {
        "icon": Icons.drive_eta,
        "color": red,
        "label": tr("automobiliste"),
        "cost": _nbUsers.toString()
      },
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, right: 20, left: 20, bottom: 15),
              child: AdmobBanner(
                adUnitId: ams.getBannerAdId(),
                adSize: AdmobBannerSize.FULL_BANNER,
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
                      ),
                    ]),
                child: buildchart()),
          ),
          SizedBox(
            height: 20,
          ),
          Wrap(
              spacing: 15,
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
  }
}
