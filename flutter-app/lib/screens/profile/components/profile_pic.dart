import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loader.dart';
import 'package:http/http.dart' as http;

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
  bool isLoaded = false;
  Future data;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.photo = prefs.getString('photo');
    return "rrrrrrrrr";
  }

  @override
  void initState() {
    super.initState();
    this.data = getStringValuesSF();
    this.isLoaded = true;
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
                        CircleAvatar(
                          backgroundImage: this.photo == null
                              ? AssetImage("assets/images/avatar1.png")
                              : Image.network(link + "/file/" + this.photo)
                                  .image,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: ColorLoader3());
                } else {
                  return Center(child: ColorLoader3());
                }
              }));
  }
}
