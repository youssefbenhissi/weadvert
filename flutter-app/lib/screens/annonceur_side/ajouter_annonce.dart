import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pim/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pim/screens/sign_in/components/custom_dialog.dart';
import 'package:flutter/services.dart';
import 'package:pim/screens/offres_cote_automobiliste/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:pim/iconed_button.dart';
import 'package:pim/progress_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:imageview360/imageview360.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pim/screens/annonceur_side/PdfPreviewScreen.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:pim/services/admob_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/screens/my_account/upload.dart';
import 'package:pim/screens/annonceur_side/popup/add_todo_button.dart';
import 'package:pim/screens/annonceur_side/popup/add_todo_button copy.dart';
import 'package:pim/screens/annonceur_side/popup/add_todo_button copy 2.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

final ams = AdMobService();

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  bool _isButtonDisabled;
  String rrr;
  File selected;
  var _firstPress = false;
  String renouvelable = "0";
  var _recognitions;
  List<String> paths = new List<String>();
  bool isMale = true;
  bool isRememberMe = false;
  InterstitialAd newTripAd = ams.getNewTripInterstitial();
  String coutmaximal;
  String gouvernorat = 'Monastir';
  String description, nbrcandidats;
  DateTime _startDate = DateTime.now();
  String _startDatenott = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDatenott =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  SharedPreferences preferences;

  int idAnnonceur;

  var entreprise;

  @override
  void initState() {
    getSP().then((value) => null);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageListMoyenne(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageListGrande(context));
    _isButtonDisabled = true;
    loadModel().then((val) {
      setState(() {});
    });
  }

  final pdf = pw.Document();
  static int tappedGestureDetector = 0;
  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text(
            tr("Your New Offer"),
            style: pw.TextStyle(
                fontSize: 40,
                color: PdfColors.green,
                background: pw.BoxDecoration(color: PdfColors.amber)),
          )),
          pw.Paragraph(text: "etat: " + rrr),
          pw.Paragraph(text: "nombre de candidats: " + nbrcandidats),
          pw.Paragraph(text: "cout: " + coutmaximal),
          pw.Paragraph(text: "gouvernorat: " + gouvernorat),
          pw.Paragraph(text: "date de début: " + _startDatenott),
          pw.Paragraph(text: "date de fin: " + _endDatenott),
          pw.Paragraph(text: "description: " + description),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        _startDatenott = DateFormat('yyyy-MM-dd').format(_startDate);
        _endDatenott = DateFormat('yyyy-MM-dd').format(_endDate);
      });
    }
  }

  Future getSP() async {
    preferences = await SharedPreferences.getInstance();
    this.idAnnonceur = preferences.getInt('idAnnonceur');
    this.entreprise = preferences.getString('entreprise');
  }

  _sendNotifications() async {
    String url = link + '/getFollowers/' + this.idAnnonceur.toString();
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
        String json = '{ "notification":{ "body" : "'+ this.entreprise +
            ' added a new offer" ,"text":" ' +
            this.entreprise +
            ' added a new offer", "title":"New Offer by ' +
            this.entreprise +
            '"},"to":"' +
            value["token"] +
            '"}';
        http.Response response =
            await http.post(url, headers: headers, body: json);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
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
                        child:
                            Icon(Icons.arrow_back, color: Color(0xffffac30))),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                color: kPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: tr("Create a new Offer"),
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 2,
                          //color: Colors.yellow[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: 150,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 520 : 250,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [if (isSignupScreen) buildSignupSection()],
                ),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 30,
            child: FloatingActionButton(
              onPressed: () async {
                newTripAd
                  ..load()
                  ..show(
                    anchorType: AnchorType.bottom,
                    anchorOffset: 0.0,
                    horizontalCenterOffset: 0.0,
                  );
                writeOnPdf();
                await savePdf();

                Directory documentDirectory =
                    await getApplicationDocumentsDirectory();

                String documentPath = documentDirectory.path;

                String fullPath = "$documentPath/example.pdf";

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfPreviewScreen(
                              path: fullPath,
                            )));
              },
              child: Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getWidgets(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: gouvernorat,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (newValue) {
              setState(() {
                gouvernorat = newValue;
              });
            },
            items: <String>['Monastir', 'Tunis', 'Ariana']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () async {
              await displayDateRangePicker(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.black,
                            ),
                            Text(
                              " $_startDatenott / $_endDatenott",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    tr("  Change"),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
          new TextField(
            onChanged: (newText) {
              coutmaximal = newText;
            },
            decoration: new InputDecoration(labelText: tr("Cout Maximal")),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          new TextField(
            onChanged: (newText) {
              nbrcandidats = newText;
            },
            decoration:
                new InputDecoration(labelText: tr("nombre de candidats")),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (newText) {
                description = newText;
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rrr = "renouvlable";
                      isMale = true;
                      renouvelable = "1";
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      Text(
                        tr("renouvelable"),
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rrr = "non renouvlable";
                      isMale = false;
                      renouvelable = "0";
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Colors.transparent
                                : Palette.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Palette.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        tr("non renouvelable"),
                        style: TextStyle(color: Palette.textColor1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () => {
                        setState(() {
                          tappedGestureDetector = 0;
                        }),
                        Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return AddTodoPopupCard(
                            imageList: imageList,
                          );
                        }))
                      },
                  child: Container(
                    decoration: BoxDecoration(
                      border: tappedGestureDetector == 0
                          ? Border.all(color: Colors.black, width: 1.0)
                          : Border.all(
                              color: Colors.transparent,
                            ),
                    ),
                    width: 100,
                    child: (imagePrecached == true)
                        ? ImageView360(
                            key: UniqueKey(),
                            imageList: imageList,
                            autoRotate: false,
                            rotationCount: 2,
                            rotationDirection: RotationDirection.anticlockwise,
                            frameChangeDuration: Duration(milliseconds: 170),
                            swipeSensitivity: swipeSensitivity,
                            allowSwipeToRotate: allowSwipeToRotate,
                          )
                        : Text("Pre-Caching images..."),
                  )),
              GestureDetector(
                onTap: () => {
                  setState(() {
                    tappedGestureDetector = 1;
                  }),
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return AddTodoPopupCardMoyenne(
                      imageList: imageList,
                    );
                  }))
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: tappedGestureDetector == 1
                        ? Border.all(color: Colors.black, width: 1.0)
                        : Border.all(
                            color: Colors.transparent,
                          ),
                  ),
                  width: 100,
                  child: (imagePrecached == true)
                      ? ImageView360(
                          key: UniqueKey(),
                          imageList: imageListMoyenne,
                          autoRotate: false,
                          rotationCount: 2,
                          rotationDirection: RotationDirection.anticlockwise,
                          frameChangeDuration: Duration(milliseconds: 170),
                          swipeSensitivity: swipeSensitivity,
                          allowSwipeToRotate: allowSwipeToRotate,
                        )
                      : Text("Pre-Caching images..."),
                ),
              ),
              GestureDetector(
                  onTap: () => {
                        setState(() {
                          tappedGestureDetector = 2;
                        }),
                        Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return AddTodoPopupCardGrand(
                            imageList: imageListGrande,
                          );
                        }))
                      },
                  child: Container(
                    decoration: BoxDecoration(
                      border: tappedGestureDetector == 2
                          ? Border.all(color: Colors.black, width: 1.0)
                          : Border.all(
                              color: Colors.transparent,
                            ),
                    ),
                    width: 100,
                    child: (imagePrecached == true)
                        ? ImageView360(
                            key: UniqueKey(),
                            imageList: imageListGrande,
                            autoRotate: false,
                            rotationCount: 2,
                            rotationDirection: RotationDirection.anticlockwise,
                            frameChangeDuration: Duration(milliseconds: 170),
                            swipeSensitivity: swipeSensitivity,
                            allowSwipeToRotate: allowSwipeToRotate,
                          )
                        : Text("Pre-Caching images..."),
                  ))
            ],
          ),
          buildTextWithIcon(),
        ],
      ),
    );
  }

  List<AssetImage> imageList = List<AssetImage>();
  List<AssetImage> imageListMoyenne = List<AssetImage>();
  List<AssetImage> imageListGrande = List<AssetImage>();
  bool autoRotate = true;
  int rotationCount = 2;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  RotationDirection rotationDirection = RotationDirection.anticlockwise;
  Duration frameChangeDuration = Duration(milliseconds: 50);
  bool imagePrecached = false;
  bool imagePrecachedPetit = false;
  bool imagePrecachedGrand = false;
  void updateImageList(BuildContext context) async {
    for (int i = 1; i <= 36; i++) {
      imageList.add(AssetImage('assets/images/$i petit.jpg'));
      await precacheImage(AssetImage('assets/images/$i petit.jpg'), context);
    }
    setState(() {
      imagePrecached = true;
    });
  }

  void updateImageListMoyenne(BuildContext context) async {
    for (int i = 1; i <= 36; i++) {
      imageListMoyenne.add(AssetImage('assets/images/$i moyenne.jpg'));
      await precacheImage(AssetImage('assets/images/$i moyenne.jpg'), context);
    }
    setState(() {
      imagePrecachedPetit = true;
    });
  }

  void updateImageListGrande(BuildContext context) async {
    for (int i = 1; i <= 36; i++) {
      imageListGrande.add(AssetImage('assets/images/$i grand.jpg'));
      await precacheImage(AssetImage('assets/images/$i grand.jpg'), context);
    }
    setState(() {
      imagePrecachedGrand = true;
    });
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

  void onPressedIconWithText() async {
    String imgName = Uuid().v4().toString() + ".jpeg";
    String url = link + '/ajouteroffre';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"idAnnonceur": "' +
        "1" +
        '","description": "' +
        description +
        '","gouvernorat": "' +
        gouvernorat +
        '","datedebut": "' +
        _startDatenott +
        '","datefin": "' +
        _endDatenott +
        '","nbcandidats": "' +
        nbrcandidats +
        '","cout": "' +
        coutmaximal +
        '","renouvelable": "' +
        renouvelable +
        '","typeoffre": "' +
        tappedGestureDetector.toString() +
        '","imageOffer": "' +
        imgName +
        '"}';

    http.Response response = await http.post(url, headers: headers, body: json);
    upload(File(this.paths.elementAt(0)), imgName);
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        stateTextWithIcon = ButtonState.loading;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            stateTextWithIcon = Random.secure().nextBool()
                ? ButtonState.success
                : ButtonState.fail;
          });
        });

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
      _firstPress = false;
    });
    _sendNotifications();
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: tr("Send"),
          icon: Icon(Icons.send, color: Colors.white),
          color: kPrimaryColor),
      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
      ButtonState.fail: IconedButton(
          text: tr("Success"),
          icon: Icon(Icons.check_circle, color: Colors.white),
          color: Colors.green.shade400),
      ButtonState.success: IconedButton(
          text: tr("Success"),
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: onPressedIconWithText, state: stateTextWithIcon);
  }

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
    //await predict(this.selected);
    

    // print(_recognitions[0]["label"]);
    // if (_recognitions[0]["label"] != "1 car") {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) => CustomDialog(
    //       title: tr("customBoxTitle"),
    //       description: tr("not_car"),
    //       primaryButtonText: tr("bouttondialog"),
    //     ),
    //   );
    // } else {
      this.paths.add(this.selected.path);
      print("paths:" + this.paths.toString());
    // }
  }

  List<Widget> _getWidgets() {
    List listings = List<Widget>();
    int i = 0;
    listings.add(
      GestureDetector(
        onTapUp: (c) {
          _getImage();
        },
        child: Container(
          height: 50,
          width: 70,
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffffac30),
          ),
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );

    if (this.paths.length == 1) listings.removeAt(0);
    for (i = 0; i < this.paths.length; i++) {
      listings.add(imageWidget(i));
    }
    return listings;
  }

  Container imageWidget(int index) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 50,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xfff1f3f6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 50,
            width: 80,
            child: Image.file(File(this.paths[index])),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
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
