import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/models/voiture.dart';
import 'package:pim/screens/my_account/upload.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../sign_in/components/custom_dialog.dart';
import './custom_dialog.dart' as customDialog;
import 'package:pim/components/custom_surfix_icon.dart';
import 'package:http/http.dart' as http;
import 'package:tflite/tflite.dart';
import '../../constants.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditCarPage(),
    );
  }
}

class EditCarPage extends StatefulWidget {
  static List<String> imagesVoiture = new List<String>();

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final List<String> errors = [];
  String _type = tr('Utility'), _model, _marque;
  int _annee;
  List<String> paths = new List<String>();
  File selected;
  Voiture v = Voiture();
  Future data;
  bool isLoaded = false;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SharedPreferences preferences;
  var idAuto;
  List<String> suggestions = [
    'Citroen',
    'Dacia',
    'Fiat',
    'Hyundai',
    'Peugeot',
    'Renault',
    'Seat',
    'Skoda',
    'Toyota',
    'Volkswagen'
  ];
  var _recognitions;

  Future predict(File image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    setState(() {
      _recognitions = recognitions;
    });
  }

  Future _getImage() async {
    this.selected = await ImagePicker.pickImage(source: ImageSource.gallery);

    await predict(this.selected);

    if (_recognitions[0]["label"] != "1 car") {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Not a car",
          description: tr("not_car"),
          primaryButtonText: tr("bouttondialog"),
        ),
      );
    } else {
      this.paths.add(this.selected.path);
    }
  }

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAuto = preferences.getInt('idAuto');
  }

  _makeGetRequest() async {
    String url = link + '/voiture/' + this.idAuto.toString();
    http.Response response = await http.get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String body = response.body;
    if (response.statusCode == 200) {
      v = Voiture.fromJson(jsonDecode(response.body));
      _marque = v.marque;
      _model = v.model;
      _type = v.type;
      _annee = v.annee;
    } else
      v = null;

    url = link + '/image_voiture_auto/' + this.idAuto.toString();
    response = await http.get(url);
    statusCode = response.statusCode;
    headers = response.headers;
    contentType = headers['content-type'];
    body = response.body;

    if (response.statusCode == 200) {
      EditCarPage.imagesVoiture = Voiture.images(jsonDecode(response.body));
    }
  }

  _makePostRequest(String method) async {
    String url = link + '/voiture';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"idAuto": ' +
        this.idAuto.toString() +
        ', "type" : "' +
        _type +
        '", "marque": "' +
        _marque +
        '","model" : "' +
        _model +
        '", "annee" : ' +
        _annee.toString() +
        '}';
    if (method == "post") {
      http.Response response =
          await http.post(url, headers: headers, body: json);
      String idVoiture = response.body.substring(6, response.body.indexOf(","));
      if (this.paths != null) {
        this.paths.forEach((element) async {
          String imgName = Uuid().v4().toString() + ".jpeg";
          String url = link + '/image';
          Map<String, String> headers = {"Content-type": "application/json"};
          String json =
              '{"idVoiture": ' + idVoiture + ', "nom" : "' + imgName + '"}';
          http.Response response =
              await http.post(url, headers: headers, body: json);
          upload(File(element), imgName);
          this.paths.clear();
        });
      }
      v = Voiture(
          idVoiture: int.parse(idVoiture),
          type: _type,
          marque: _marque,
          model: _model);
      Toast.show(tr("car_added"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      url += "/" + this.idAuto.toString();
      if (this.paths != null) {
        this.paths.forEach((element) async {
          String imgName = Uuid().v4().toString() + ".jpeg";
          String url = link + '/image';
          Map<String, String> headers = {"Content-type": "application/json"};
          String json = '{"idVoiture": ' +
              v.idVoiture.toString() +
              ', "nom" : "' +
              imgName +
              '"}';
          http.Response response =
              await http.post(url, headers: headers, body: json);
          upload(File(element), imgName);
          this.paths.clear();
        });
      }
      http.Response response =
          await http.put(url, headers: headers, body: json);
      Toast.show(tr("car_update"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  @override
  void initState() {
    super.initState();
    data = getSP().then((value) => _makeGetRequest());
    isLoaded = true;
    loadModel().then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded)
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Text(
                        tr("vehicule"),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
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
                      Card(
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ...ListTile.divideTiles(
                                    color: Colors.white,
                                    tiles: [
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: this.v == null
                                            ? tr(this._type)
                                            : tr(this.v.type),
                                        icon: CustomSurffixIcon(
                                            svgIcon: "assets/icons/car.svg"),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Color(0xFFA7A7A7),
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            this._type = tr(newValue);
                                            if (this.v != null)
                                              this.v.type = tr(newValue);
                                          });
                                        },
                                        items: <String>[
                                          'Taxi',
                                          tr('Utility'),
                                          tr('Particular')
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(children: [
                                          buildMarqueFormField(tr("marque"),
                                              tr("marque"), "car.svg"),
                                          buildModelFormField(tr("model"),
                                              tr("model"), "car.svg"),
                                          buildAnneeFormField(
                                              "Annee", "Annee", "car.svg"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  if (v == null) {
                                                    if (this.paths.length == 0)
                                                      Toast.show(
                                                          tr("pics_first"),
                                                          context,
                                                          duration: Toast
                                                              .LENGTH_SHORT,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                    else if (_formKey
                                                        .currentState
                                                        .validate()) {
                                                      _formKey.currentState
                                                          .save();
                                                      _makePostRequest("post");
                                                    }
                                                  } else if (_formKey
                                                      .currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                    _makePostRequest("put");
                                                  }
                                                },
                                                color: kPrimaryColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50),
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(
                                                  tr("update"),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 2.2,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )
                                        ]),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ColorLoader3());
            }
          },
        ),
      );
    else
      return Center(child: ColorLoader3());
  }

  Padding buildMarqueFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: v != null
          ? TextFormField(
              initialValue: v == null ? "" : v.marque,
              decoration: InputDecoration(
                labelText: fieldName,
                hintText: hint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/" + icon),
              ),
            )
          : SimpleAutoCompleteTextField(
              key: key,
              decoration: InputDecoration(
                labelText: fieldName,
                hintText: hint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/" + icon),
              ),
              suggestions: suggestions,
              textChanged: (text) => _marque = text,
              textSubmitted: (text) => _marque = text,
              clearOnSubmit: false,
            ),
    );
  }

  Padding buildModelFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: v == null ? "" : v.model,
        keyboardType: TextInputType.text,
        onSaved: (newValue) => _model = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: fieldName,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/" + icon),
        ),
      ),
    );
  }

  Padding buildAnneeFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: v == null ? "" : v.annee.toString(),
        keyboardType: TextInputType.number,
        onSaved: (newValue) => _annee = int.parse(newValue.toString()),
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: fieldName,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/" + icon),
        ),
      ),
    );
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Container imageWidget(int index) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 150,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xfff1f3f6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100,
            width: 80,
            child: Image.file(File(this.paths[index])),
          ),
        ],
      ),
    );
  }

  GestureDetector allImageWidget(String imgName) {
    return GestureDetector(
      onLongPress: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => customDialog.CustomDialog(
            title: "Suppression",
            description: tr("remove_msg"),
            primaryButtonText: tr("bouttondialog"),
            secondaryButtonText: tr("CANCEL"),
            imgName: imgName,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 150,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xfff1f3f6)),
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 80,
              child: Image.network(link + '/file/' + imgName),
            ),
            Center(
              child: Icon(
                Icons.remove_circle,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> images() {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < EditCarPage.imagesVoiture.length; i++)
      list.add(allImageWidget(EditCarPage.imagesVoiture.elementAt(i)));
    for (int i = 0; i < this.paths.length; i++) {
      list.add(imageWidget(i));
    }
    list.add(
      GestureDetector(
        onTapUp: (c) {
          _getImage();
        },
        child: Container(
          height: 70,
          width: 70,
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
          ),
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
    if (this.paths.length + EditCarPage.imagesVoiture.length == 5)
      list.removeAt(list.length - 1);
    return list;
  }
}
