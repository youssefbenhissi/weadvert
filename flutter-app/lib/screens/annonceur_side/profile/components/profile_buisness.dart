import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/models/annonceur.dart';
import 'package:pim/screens/Home/assets.dart';
import 'package:pim/screens/Home/network_image.dart';
import 'package:pim/screens/profile/components/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';

class ProfileThreePage extends StatefulWidget {
  static final String path = "lib/src/pages/profile/profile3.dart";

  @override
  _ProfileThreePageState createState() => _ProfileThreePageState();
}

class _ProfileThreePageState extends State<ProfileThreePage> {
  final image = avatars[1];
  SharedPreferences preferences;
  Annonceur annonceur = Annonceur();
  Future data;
  bool isLoaded = false;

  getSP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    annonceur.entreprise = preferences.getString('entreprise');
    annonceur.typeEntre = preferences.getString('typeEntre');
    annonceur.email = preferences.getString('email');
    annonceur.image = preferences.getString('image');
    annonceur.telephone = preferences.getString('telephone');
    annonceur.website = preferences.getString('website');
    return "errrr";
  }

  @override
  void initState() {
    super.initState();
    data = getSP();
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: FutureBuilder<dynamic>(
            future: data,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: annonceur.image == null
                            ? Image.asset(
                                "assets/images/avatar1.png",
                                fit: BoxFit.cover,
                              )
                            : PNetworkImage(
                                link + '/file/' + annonceur.image,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  margin: EdgeInsets.only(top: 16.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 96.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              annonceur.entreprise,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title,
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text(annonceur.typeEntre),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image: annonceur.image != null
                                              ? NetworkImage(link +
                                                  "/file/" +
                                                  annonceur.image)
                                              : Image.asset(
                                                  "assets/images/avatar1.png",
                                                  fit: BoxFit.cover,
                                                ).image,
                                          fit: BoxFit.cover)),
                                  margin: EdgeInsets.only(left: 16.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      tr("Your company information"),
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text(
                                      "Email",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      annonceur.email,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    leading: Icon(
                                      Icons.email,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      tr("Phone"),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      annonceur.telephone,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    leading: Icon(Icons.phone),
                                  ),
                                  ListTile(
                                    title: Text(
                                      tr("Website"),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      annonceur.website,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    leading: Icon(Icons.web),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: ColorLoader3());
              }
            }));
  }
}
