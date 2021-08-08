import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/constants.dart';
import 'package:pim/screens/my_account/upload.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({
    String photo,
    Key key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String photo;
  int idAnnonceur;
  bool isLoaded = false;
  Future data;
  File _image;
  String imgName = Uuid().v4().toString() + ".jpeg";

  Future _getImage() async {
    this._image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._image = _image;
    });
    _updateAnnonceurImage();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.idAnnonceur = prefs.getInt('idAnnonceur');
    this.photo = prefs.getString('image');
    return "rrrrrrrrr";
  }

  @override
  void initState() {
    super.initState();
    this.data = getStringValuesSF();
    this.isLoaded = true;
  }

  _updateAnnonceurImage() async {
    if (this._image != null) {
      String url =
          link + '/updateImageAnnonceur/' + this.idAnnonceur.toString();
      print(url);
      String json = '{"image": "' + imgName + '"}';
      Map<String, String> headers = {"Content-type": "application/json"};
      http.Response response =
          await http.put(url, headers: headers, body: json);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      upload(this._image, imgName);
      await prefs.setString('image', imgName);
      setState(() {
        this.photo = imgName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLoaded)
      return Container(
          child: FutureBuilder<dynamic>(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      overflow: Overflow.visible,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _getImage();
                          },
                          child: CircleAvatar(
                            backgroundImage: this.photo == null
                                ? AssetImage("assets/images/Profile Image.png")
                                : Image.network(link + "/file/" + this.photo)
                                    .image,
                          ),
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
                              onPressed: () {
                                _getImage();
                              },
                              child: SvgPicture.asset(
                                  "assets/icons/Camera Icon.svg"),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: ColorLoader3());
                } else {
                  return Center(child: ColorLoader3());
                }
              }));
  }
}
