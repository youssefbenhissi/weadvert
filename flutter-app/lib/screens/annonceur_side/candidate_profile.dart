import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pim/iconed_button.dart';
import 'package:pim/models/voiture.dart';
import 'package:pim/progress_button.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../constants.dart';
import 'widgets/opaque_image.dart';
import 'widgets/my_info.dart';
import 'widgets/profile_info_big_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CandidateProfile extends StatefulWidget {
  Map<String, dynamic> person;
  CandidateProfile(this.person);

  @override
  _CandidateProfileState createState() => _CandidateProfileState();
}

class _CandidateProfileState extends State<CandidateProfile> {
  Future data;
  bool isLoaded;
  List<String> imagesVoiture = new List<String>();
  ButtonState stateTextWithIconApprove = ButtonState.idle;
  ButtonState stateTextWithIconDecline = ButtonState.idle;

  _getVehicleImages() async {
    String url =
        link + '/image_voiture_auto/' + widget.person["idAuto"].toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String body = response.body;
    if (response.statusCode == 200) {
      imagesVoiture = Voiture.images(jsonDecode(response.body));
    }
  }

  _approuver() async {
    String url = link +
        '/approuverAutomobiliste/' +
        widget.person["idOffre"].toString() +
        '/' +
        widget.person["idAuto"].toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers);

    switch (stateTextWithIconApprove) {
      case ButtonState.idle:
        stateTextWithIconApprove = ButtonState.loading;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            stateTextWithIconApprove = response.statusCode == 200
                ? ButtonState.success
                : ButtonState.fail;
          });
        });

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIconApprove = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIconApprove = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIconApprove = stateTextWithIconApprove;
      stateTextWithIconDecline = stateTextWithIconApprove;
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context, 'Yep!');
    });
    _sendNotifications();
  }

  _decline() async {
    String url = link +
        '/declineAutomobiliste/' +
        widget.person["idOffre"].toString() +
        '/' +
        widget.person["idAuto"].toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.delete(url, headers: headers);

    switch (stateTextWithIconDecline) {
      case ButtonState.idle:
        stateTextWithIconDecline = ButtonState.loading;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            stateTextWithIconDecline = response.statusCode == 200
                ? ButtonState.success
                : ButtonState.fail;
          });
        });

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIconDecline = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIconDecline = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIconDecline = stateTextWithIconDecline;
      stateTextWithIconApprove = stateTextWithIconDecline;
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context, 'Yep!');
    });
  }

  _sendNotifications() async {
    String url = link + '/getToken/' + widget.person["idAuto"].toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    if (statusCode == 200) {
      List<dynamic> object = json.decode(response.body);
      object.forEach((value) async {
        String url = 'https://fcm.googleapis.com/fcm/send';
        Map<String, String> headers = {
          "Content-type": "application/json",
          "Authorization":
              "key=AAAABVHQExg:APA91bEmghpBYJlJSW7OmZynoxvmjlBvS-WdFnkO9WMwHJk3dGSV5BBtgUUfkxcZdpWbh9N0ZjRabUHGQQmaafF4h1R6D1Kg61wh90rmgah30Uyl46YFLNSeyQbLRE4QNeu2D8O7JmuV"
        };
        String json =
            '{ "notification":{ "body" : "You have been accepted in ' +
                widget.person["description"] +
                '" ,"text":"You have been accepted in ' +
                widget.person["description"] +
                '", "title":"Accepted !!"},"to":"' +
                value["token"] +
                '"}';
        http.Response response =
            await http.post(url, headers: headers, body: json);
        print("FCM response : " + response.body);
      });
    }
  }

  Widget allImageWidget(String imgName) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SliderShowFullmages(
                listImagesModel: imagesVoiture,
                current: imagesVoiture.indexOf(imgName))));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 200,
        width: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xfff1f3f6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 130,
              child: Image.network(link + '/file/' + imgName),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> images() {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < imagesVoiture.length; i++)
      list.add(allImageWidget(imagesVoiture.elementAt(i)));
    return list;
  }

  Widget approveButton() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: tr("approve"),
          icon: Icon(Icons.check, color: Colors.white),
          color: Colors.lightBlueAccent),
      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.lightBlueAccent),
      ButtonState.fail: IconedButton(
          text: "Fail",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade400),
      ButtonState.success: IconedButton(
          text: "Success",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: _approuver, state: stateTextWithIconApprove);
  }

  Widget declineButton() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: tr("decline"),
          icon: Icon(Icons.remove_circle, color: Colors.white),
          color: Colors.red),
      ButtonState.loading: IconedButton(text: "Loading", color: Colors.red),
      ButtonState.fail: IconedButton(
          text: "Fail",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade400),
      ButtonState.success: IconedButton(
          text: "Success",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: _decline, state: stateTextWithIconDecline);
  }

  @override
  void initState() {
    super.initState();
    data = _getVehicleImages();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: <Widget>[
                            OpaqueImage(
                              imageUrl:
                                  link + "/file/" + widget.person["photo"],
                            ),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.arrow_back)),
                                    ),
                                    MyInfo(widget.person),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.only(top: 50),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        ProfileInfoBigCard(
                                          firstText:
                                              widget.person["type"].toString(),
                                          secondText: tr("vehicule_type"),
                                          icon: Icon(
                                            Icons.car_rental,
                                            size: 32,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                        ProfileInfoBigCard(
                                          firstText: widget.person["marque"],
                                          secondText: tr("marque"),
                                          icon: Icon(
                                            FontAwesomeIcons.car,
                                            size: 32,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        ProfileInfoBigCard(
                                          firstText: widget.person["model"],
                                          secondText: tr("model"),
                                          icon: Icon(
                                            FontAwesomeIcons.star,
                                            size: 32,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                        ProfileInfoBigCard(
                                          firstText:
                                              widget.person["description"],
                                          secondText: tr("wanted_offer"),
                                          icon: Icon(
                                            Icons.request_page,
                                            size: 32,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 130,
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: images(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    approveButton(),
                                    declineButton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: screenHeight * (5 / 9) - 150 / 2,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ProfileInfoCard(
                              firstText: widget.person["score"].toString(),
                              secondText: "Score"),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              return launch(
                                  "tel://" + widget.person["numerotelephone"]);
                            },
                            child: ProfileInfoCard(
                              hasImage: true,
                              imagePath: Icons.call,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ProfileInfoCard(
                              firstText: widget.person["profession"],
                              secondText: tr("job")),
                        ],
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

class SliderShowFullmages extends StatefulWidget {
  final List listImagesModel;
  final int current;
  const SliderShowFullmages({Key key, this.listImagesModel, this.current})
      : super(key: key);
  @override
  _SliderShowFullmagesState createState() => _SliderShowFullmagesState();
}

class _SliderShowFullmagesState extends State<SliderShowFullmages> {
  int _current = 0;
  bool _stateChange = false;
  @override
  void initState() {
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _current = (_stateChange == false) ? widget.current : _current;
    return new Container(
        color: Colors.transparent,
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        autoPlayAnimationDuration: Duration(milliseconds: 500),
                        autoPlay: true,
                        height: MediaQuery.of(context).size.height / 1.3,
                        viewportFraction: 1.0,
                        onPageChanged: (index, data) {
                          setState(() {
                            _stateChange = true;
                            _current = index;
                          });
                        },
                        initialPage: widget.current),
                    items: map<Widget>(widget.listImagesModel, (index, url) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                child: Image.network(
                                  link + '/file/' + url,
                                  fit: BoxFit.fill,
                                  height: 400.0,
                                ),
                              ),
                            )
                          ]);
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(widget.listImagesModel, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 9.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_current == index)
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            )));
  }
}
