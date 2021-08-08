import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pim/models/offre.dart';
import 'package:pim/screens/offres_cote_automobiliste/models/company.dart';
import 'package:pim/constants.dart';
import 'package:pim/screens/offres_cote_automobiliste/pages/description_tab.dart';
import 'package:pim/screens/offres_cote_automobiliste/pages/company_tab.dart';
import 'package:g_captcha/g_captcha.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:http/http.dart' as http;
import 'package:pim/screens/offres_cote_automobiliste/pages/home_page.dart';
import '../../sign_in copy/components/custom_dialog.dart';
import '../rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class JobDetail extends StatefulWidget {
  final Offre company;
  int idAuto;
  JobDetail({this.idAuto, this.company});

  @override
  _JobDetailState createState() => _JobDetailState(company: this.company);
}

class _JobDetailState extends State<JobDetail> {
  int statuscode;
  int statuscoderating;
  final Offre company;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  _JobDetailState({this.company});
  Future<int> _verifieretat(int idoffre, int idautomobiliste) async {
    String url = link + '/verifiercandidature';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"idoffre": "' +
        idoffre.toString() +
        '","idautomobiliste": "' +
        idautomobiliste.toString() +
        '"}'; // make POST request

    http.Response response = await http.post(url, headers: headers, body: j);
    print("lahhhhhhhhhhhhhnnnnnnnnnnnneeeeeeeeeeee");
    statuscode = response.statusCode;
    return response.statusCode;
  }

  Future<int> _verifieretatrating(int idoffre, int idautomobiliste) async {
    String url = link + '/verifierrating';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"idoffre": "' +
        idoffre.toString() +
        '","idautomobiliste": "' +
        idautomobiliste.toString() +
        '"}'; // make POST request

    http.Response response = await http.post(url, headers: headers, body: j);
    print("lahhhhhhhhhhhhhnnnnnnnnnnnneeeeeeeeeeee");
    statuscoderating = response.statusCode;
    print(response.statusCode);
    return response.statusCode;
  }

  Future<int> _ajouterapplication(int idoffre, int idautomobiliste) async {
    String url = link + '/ajoutercandidature';
    Map<String, String> headers = {"Content-type": "application/json"};
    String j = '{"idoffre": "' +
        idoffre.toString() +
        '","idautomobiliste": "' +
        idautomobiliste.toString() +
        '"}'; // make POST request

    http.Response response = await http.post(url, headers: headers, body: j);
    print("lahhhhhhhhhhhhhnnnnnnnnnnnneeeeeeeeeeee");
    statuscode = response.statusCode;
    _makePostRequest();
    return response.statusCode;
  }

  _makePostRequest() async {
    String url = link + '/followers';
    String fcmToken = await _fcm.getToken();
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"idAuto":  ' +
        widget.idAuto.toString() +
        ' ,"idAnnonceur": ' +
        company.idAnnonceur.toString() +
        ', "token" : "' +
        fcmToken +
        '"}';
    http.Response response = await http.post(url,
        headers: headers, body: json); // check the status code for the result
    int statusCode = response.statusCode;
    String body = response.body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifieretat(company.idOffre, widget.idAuto);
    _verifieretatrating(company.idOffre, widget.idAuto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSilver,
      appBar: AppBar(
        backgroundColor: kSilver,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.company.entreprise,
          style: kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 250.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: Image.network(
                                    link + "/file/" + widget.company.imageOffer)
                                .image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      widget.company.gouvernorat,
                      style: kTitleStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(widget.company.dateDeb)) +
                          "/" +
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(widget.company.dateFin)),
                      style: kSubtitleStyle,
                    ),
                    SizedBox(height: 25.0),
                    Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: kBlack.withOpacity(.2),
                        ),
                      ),
                      // borderRadius: BorderRadius.circular(12.0),
                      child: TabBar(
                        unselectedLabelColor: kBlack,
                        indicator: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "Company"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: TabBarView(
                  children: [
                    DescriptionTab(company: widget.company),
                    CompanyTab(company: widget.company),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          padding: EdgeInsets.only(left: 18.0, bottom: 25.0, right: 18.0),
          // margin: EdgeInsets.only(bottom: 25.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(color: kBlack.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.bookmark_border,
                  color: kBlack,
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (statuscode == 409) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                            title: tr("Application already done!"),
                            description: tr(
                                "You had already done the application for this offer . Just wait for the business answer"),
                            primaryButtonText: tr("bouttondialog"),
                          ),
                        );
                      } else {
                        _openReCaptcha();
                      }
                    },
                    color: kBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      tr("Apply for Job"),
                      style: kTitleStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.0),
              InkWell(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: kBlack.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.rate_review_rounded,
                    color: kBlack,
                  ),
                ),
                onTap: () {
                  if (statuscoderating == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: tr("rating already done!"),
                        description:
                            tr("You had already done a rating for this offer"),
                        primaryButtonText: tr("bouttondialog"),
                      ),
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmotionsPage(
                                  company: this.company,
                                )));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openReCaptcha() async {
    String tokenResult =
        await GCaptcha.reCaptcha("6LdULoIaAAAAAD-dOk3MpeEx4TxjdWvmMpWAIpo9");
    print('tokenResult: $tokenResult');
    //Fluttertoast.showToast(msg: tokenResult, timeInSecForIosWeb: 4);
    if (tokenResult != null) {
      await _ajouterapplication(company.idOffre, 4);
      showDialog(
        context: context,
        builder: (BuildContext context) => CCCCCC(
          title: tr("Successful Application!"),
          description: tr("You have successfully done your application"),
          primaryButtonText: tr("bouttondialog"),
        ),
      );
    }
    // setState
  }
}

class CCCCCC extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);

  final String title, description, primaryButtonText;

  CCCCCC({
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
  });

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: AutoSizeText(
                        primaryButtonText,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(HeroDialogRoute(builder: (context) {
                        return HomePage();
                      }));
                    }),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
