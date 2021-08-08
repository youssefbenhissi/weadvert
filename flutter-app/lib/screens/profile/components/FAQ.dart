import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pim/screens/profile/components/Chat_Screen.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  Color darkGrey = Color(0xff202020);
  List<Panel> panels = [
    Panel(
        'Do you accept orders through VOIP?',
        'hile we are happy to hear from our international customers, we are unable to accept VOIP(voice over internet protocol) calls at this time. We apologize for the inconvenience this may cause.',
        false),
    Panel(
        'I want to know if you carry a specific brand?',
        "Try clicking Brands Offers located at the Offers' page - you will be taken to a page where you can apply to that offer. Please check back often since we add new offers on a daily basis! Or if you know what you're looking for - try the search bar as well.",
        false),
    Panel(
        'How long does it take for me to get my payment?',
        'For the vast majority of returns, it takes about 5-10 Business Days for us to give you your payment at the fulfillment center.',
        false),
    Panel(
        'What forms of payment do you accept?',
        'WeAdvert currently accepts Visa, MasterCard, and American Express for all orders.',
        false),
    Panel(
        'I received an email from WeAdvert regarding an offer I didn’t subscribe to. What should I do?',
        "If you received correspondence regarding an offer you didn’t subscribe to, it likely wasn’t from WeAdvert. Don't share any personal information, click any links in the email, or respond to the email, and delete it immediately.",
        false),
    Panel(
        'Do you offer Live Chat support?',
        'Yes we do! To get in contact with one of our live chat specialists, look for the Live Help button located on the down right hand of the page, to the right of our phone number. If you are unable to see this button, it saddens us to say that we do not have a specialist available to assist via chat.',
        false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.black,
        // ),

        //backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 16.0),
                child: Text(
                  'FAQ',
                  style: TextStyle(
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              ...panels
                  .map((panel) => ExpansionTile(
                          title: Text(
                            panel.title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                          ),
                          children: [
                            Container(
                                padding: EdgeInsets.all(16.0),
                                color: Color(0xffFAF1E2),
                                child: Text(panel.content,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)))
                          ]))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 16.0, top: 16),
                child: Text(
                  tr("Contact US"),
                  style: TextStyle(
                      //color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              SizedBox(
                  height: Get.height / 7,
                  child: GridView.count(
                      padding: EdgeInsets.all(10),
                      crossAxisSpacing: 5,
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 5,
                      mainAxisSpacing: 5,
                      children: [
                        GFIconButton(
                          onPressed: () {},
                          color: Colors.green,
                          icon: Icon(Icons.phone),
                          size: GFSize.SMALL,
                        ),
                        GFIconButton(
                          onPressed: () {},
                          color: Colors.red,
                          icon: Icon(Icons.email),
                          size: GFSize.SMALL,
                        ),
                        GFIconButton(
                          onPressed: () {},
                          color: Colors.blue,
                          icon: Icon(FontAwesomeIcons.facebookMessenger),
                          size: GFSize.SMALL,
                        ),
                        GFIconButton(
                          onPressed: () {},
                          color: Colors.green,
                          icon: Icon(FontAwesome.whatsapp),
                          size: GFSize.SMALL,
                        ),
                        GFIconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        email: "iheb@gmail.com",
                                        name: "iheb",
                                      )),
                            );
                          },
                          color: Colors.orange,
                          icon: Icon(FontAwesome.chat),
                          size: GFSize.SMALL,
                        ),
                      ])),
              GFIconButton(
                onPressed: () {},
                icon: Icon(Icons.share),
                size: GFSize.SMALL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}
