import 'package:flutter/material.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/screens/my_account/upload.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:pim/components/custom_surfix_icon.dart';
import 'package:http/http.dart' as http;
import 'package:pim/models/automobiliste.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePage extends StatefulWidget {
  static final String path = "lib/src/pages/profile/profile8.dart";

  @override
  _ProfileEightPageState createState() => _ProfileEightPageState();
}

class _ProfileEightPageState extends State<EditProfilePage> {
  Automobiliste automobiliste = new Automobiliste();
  bool isLoaded = false;
  Future data;
  File _image;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    this.automobiliste.idAuto = prefs.getInt('idAuto');
    this.automobiliste.nom = prefs.getString('nom');
    this.automobiliste.prenom = prefs.getString('prenom');
    this.automobiliste.dateNaiss = DateTime.parse(prefs.getString('dateNaiss'));
    this.automobiliste.email = prefs.getString('email');
    this.automobiliste.profession = prefs.getString('profession');
    this.automobiliste.lieuCirculation = prefs.getString('lieuCirculation');
    this.automobiliste.cin = prefs.getString('cin');
    this.automobiliste.photo = prefs.getString('photo');
    return "stringValue";
  }

  Future _getImage() async {
    this._image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._image = _image;
    });
  }

  @override
  void initState() {
    super.initState();
    this.data = getStringValuesSF(); //_getAutomobiliste();
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<dynamic>(
            future: data,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTapUp: (c) {
                          _getImage();
                        },
                        child: ProfileHeader(
                          avatar: this._image == null
                              ? this.automobiliste.photo == null
                                  ? Image.asset("assets/images/avatar1.png")
                                      .image
                                  : Image.network(link +
                                          "/file/" +
                                          this.automobiliste.photo)
                                      .image
                              : Image.file(this._image).image,
                          //NetworkImage(link + "/file/"+ this.automobiliste.photo),
                          coverImage: NetworkImage(
                              "https://wallpapercave.com/wp/wp8413230.jpg"),
                          title: "",
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      UserInfo(this.automobiliste, this._image),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: ColorLoader3());
              } else
                return Center(child: ColorLoader3());
            }));
  }
}

class UserInfo extends StatefulWidget {
  Automobiliste automobiliste;
  File image;

  UserInfo(this.automobiliste, this.image);
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool showPassword = false;
  final List<String> errors = [];
  String _nom = "baha",
      _prenom = "baha",
      _email = "baha",
      _password = "baha",
      _zoneCirculation = "baha",
      _profession = "baha";
  Automobiliste automobiliste = new Automobiliste();
  bool isLoaded = false;
  Future data;

  final _formKey = GlobalKey<FormState>();

  Padding buildNomFormField(
      String fieldName, String hint, String icon, String initial) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.name,
        onSaved: (newValue) => _nom = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _nom = value.toString();
            removeError(error: kEmailNullError);
          }
          return this._nom;
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

  Padding buildPrenomFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: widget.automobiliste.prenom,
        keyboardType: TextInputType.name,
        onSaved: (newValue) => _prenom = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _prenom = value.toString();
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

  Padding buildEmailFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: widget.automobiliste.email,
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => _email = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _email = value.toString();
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
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

  Padding buildProfessionFormField(String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: widget.automobiliste.profession,
        keyboardType: TextInputType.text,
        onSaved: (newValue) => _profession = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _profession = value.toString();
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

  Padding buildCirculationFormField(
      String fieldName, String hint, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: widget.automobiliste.lieuCirculation,
        keyboardType: TextInputType.name,
        onSaved: (newValue) => _zoneCirculation = newValue.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {
            _zoneCirculation = value.toString();
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

  Widget buildPasswordFormField(String labelText, String placeholder,
      String icon, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        onChanged: (newValue) => _zoneCirculation = newValue.toString(),
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            )),
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

  _makePutRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = link + '/automobiliste/' + prefs.getInt('idAuto').toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    if (widget.image != null) {
      print("not null");
      String imgName = Uuid().v4().toString() + ".jpeg";
      String json = '{"nom": "' +
          _nom +
          '","prenom": "' +
          _prenom +
          '","email" : "' +
          _email +
          '","password" : "' +
          _password +
          '","dateNaiss" : "' +
          widget.automobiliste.dateNaiss.toString().substring(
              0, widget.automobiliste.dateNaiss.toString().length - 1) +
          '", "profession" : "' +
          _profession +
          '","lieuCirculation" : "' +
          _zoneCirculation +
          '", "revenu" : 0, "score" : 0, "etatValidation" :1, "photo" : "' +
          imgName +
          '"}';
      http.Response response =
          await http.put(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      String body = response.body;
      upload(widget.image, imgName);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('nom', _nom);
      await preferences.setString('prenom', _prenom);
      await preferences.setString('email', _email);
      await preferences.setString('profession', _profession);
      await preferences.setString('lieuCirculation', _zoneCirculation);
      await preferences.setString('photo', imgName);
      await preferences.setString('dateNaiss',
          DateTime.parse(widget.automobiliste.dateNaiss.toString()).toString());
      if (statusCode == 200)
        Toast.show(tr("account_updated"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      String json = '{"nom": "' +
          _nom +
          '","prenom": "' +
          _prenom +
          '","email" : "' +
          _email +
          '","password" : "' +
          _password +
          '","dateNaiss" : "' +
          widget.automobiliste.dateNaiss.toString().substring(
              0, widget.automobiliste.dateNaiss.toString().length - 1) +
          '", "profession" : "' +
          _profession +
          '","lieuCirculation" : "' +
          _zoneCirculation +
          '", "revenu" : 0, "score" : 0, "etatValidation" :1, "photo": "' +
          widget.automobiliste.photo +
          '"}';
      http.Response response = await http.put(url,
          headers: headers, body: json); // check the status code for the result
      int statusCode = response.statusCode;
      String body = response.body;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('nom', _nom);
      await preferences.setString('prenom', _prenom);
      await preferences.setString('email', _email);
      await preferences.setString('profession', _profession);
      await preferences.setString('lieuCirculation', _zoneCirculation);
      await preferences.setString('dateNaiss',
          DateTime.parse(widget.automobiliste.dateNaiss.toString()).toString());
      if (statusCode == 200)
        Toast.show(tr("account_updated"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
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
                          Form(
                              key: _formKey,
                              child: Column(children: [
                                buildNomFormField(
                                    tr("last_name"),
                                    tr("last_name"),
                                    "User.svg",
                                    widget.automobiliste.nom),
                                buildPrenomFormField(tr("first_name"),
                                    tr("first_name"), "User.svg"),
                                Container(
                                  height: 150,
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: DateTime.parse(widget
                                        .automobiliste.dateNaiss
                                        .toString()),
                                    maximumDate: DateTime.now(),
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      widget.automobiliste.dateNaiss =
                                          newDateTime;
                                    },
                                  ),
                                ),
                                buildEmailFormField(
                                    "Email", tr("enter_email"), "Mail.svg"),
                                // buildPasswordFormField(
                                //     tr("password"), "******", "Lock.svg", true),
                                buildProfessionFormField(
                                    "Profession", tr("profession"), "User.svg"),
                                buildCirculationFormField("Zone de circulation",
                                    tr("zone_circulation"), "User.svg"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          _makePutRequest();
                                        }
                                      },
                                      color: kPrimaryColor,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                              ]))
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
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              // Avatar(
              //   image: avatar,
              //   radius: 40,
              //   backgroundColor: Colors.white,
              //   borderColor: Colors.grey.shade300,
              //   borderWidth: 4.0,
              // ),
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: [
                    CircleAvatar(
                      backgroundImage: avatar
                    ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.white),
                          ),
                          color: Color(0xFFF5F6F9),
                          onPressed: () {},
                          child:
                              SvgPicture.asset("assets/icons/Camera Icon.svg"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 70,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + 2 * borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius,
          backgroundImage: image,
        ),
      ),
    );
  }
}
