import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'commons/const.dart';

class UserProfile extends StatefulWidget {
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  UserProfile({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  String _myThumbnail;
  String _myName;
  @override
  void initState() {
    _myName = widget.myData.myName;
    _myThumbnail = widget.myData.myThumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Card(
            elevation: 2.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 60,
                        width: 60,
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 40,
                                height: 40,
                                child: this._myThumbnail == null
                                    ? Image.asset("assets/images/avatar1.png")
                                    : Image.network(
                                        link + '/file/' + this._myThumbnail)),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                tr("  Change"),
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.03),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
                GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Name: $_myName',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
              ],
            ))
      ],
    );
  }

  Future<void> _updateMyData(String newName, String newThumbnail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName', newName);
    prefs.setString('myThumbnail', newThumbnail);
    setState(() {
      _myThumbnail = newThumbnail;
      _myName = newName;
    });
    MyProfileData newMyData =
        MyProfileData(myName: newName, myThumbnail: newThumbnail);
    widget.updateMyData(newMyData);
  }
}
