import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/Screens/Welcome/components/background.dart';
import 'package:pim/components/rounded_button.dart';
import 'package:pim/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/models/offre.dart';
import '../../../data/storydata.dart';
import '../../../components/storybtn.dart';
import 'package:pim/screens/sign_in/sign_in_screen.dart';
import 'package:pim/screens/sign_in copy/sign_in_screen.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Offre>> _getallofrres() async {
    var data = await http.get(link + '/offre');
    var jsondata = json.decode(data.body);
    int i = 0;
    for (var u in jsondata) {
      Offre o = Offre(
          idOffre: u["idOffre"],
          idAnnonceur: u["idAnnonceur"],
          description: u["description"],
          gouvernorat: u["gouvernorat"],
          dateDeb: u["dateDeb"],
          dateFin: u["dateFin"],
          likes: u["likes"],
          email: u["email"],
          telephone: u["telephone"],
          nbrdefois: u['nbrdefois'],
          somme: u['somme'],
          website: u['website'],
          image: u['image'],
          nbCandidats: u["nbCandidats"],
          entreprise: u["entreprise"],
          imageOffer: u["imageOffer"]);
      setState(() {
        stories.add(StoryData(
            i,
            o.entreprise,
            link + "/file/" + o.image,
            link + "/file/" + o.imageOffer,
            o.entreprise,
            o.email,
            o.nbCandidats,
            o.website,
            o.telephone));
      });
      i++;
    }
  }

  Future data;
  @override
  void initState() {
    super.initState();
    data = _getallofrres();
  }

  List<StoryData> stories = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    // FutureBuilder<dynamic>(
    //     future: data,
    //     // ignore: missing_return
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              width: double.infinity,
              height: 150.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return storyButton(stories[index], context);
                  }),
            ),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            RoundedButton(
              text: tr("SIGN IN AS A DRIVER"),
              press: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()))
              },
            ),
            RoundedButton(
              text: tr("SIGN IN AS A BUSINESS"),
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInScreennnoceur()));
              },
            ),
          ],
        ),
      ),
    );
    //   } else if (snapshot.connectionState == ConnectionState.waiting) {
    //     return Center(child: ColorLoader3());
    //   }
    // });
  }
}
