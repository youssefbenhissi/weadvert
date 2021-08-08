import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pim/models/currentOffre.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PItem extends StatefulWidget {
  CurrentOffer co;
  int isFollowing, idAuto;
  PItem(
    this.co,
    this.isFollowing,
    this.idAuto, {
    Key key,
  }) : super(key: key);

  @override
  _PItemState createState() => _PItemState();
}

class _PItemState extends State<PItem> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  SharedPreferences preferences;

  _makePostRequest() async {
    String url = link + '/followers';
    String fcmToken = await _fcm.getToken();
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"idAuto": ' +
        widget.idAuto.toString() +
        ' ,"idAnnonceur": ' +
        widget.co.idAnnonceur.toString() +
        ', "token" : "' +
        fcmToken +
        '"}';
    http.Response response = await http.post(url,
        headers: headers, body: json); 
    int statusCode = response.statusCode;
    String body = response.body;

    setState(() {
      widget.isFollowing = 1;
    });
  }

  _saveDeviceToken() async {  
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      var tokens = _db
          .collection('annonceurs')
          .document('1')
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), 
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        'You\'re now receiving notifications',
        'You will receive all new offer added by ${this.widget.co.annonceur} ',
        platform,
        payload:
            'You will receive all new offer added by ${this.widget.co.annonceur} ');
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  _makeDeleteRequest() async {
    String url = link + '/followers/'+widget.idAuto.toString() +'/'+ widget.co.idAnnonceur.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.delete(url,
        headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;

    setState(() {
      widget.isFollowing = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage:
              NetworkImage(link + "/file/" + this.widget.co.imgUrl),
        ),
        SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.co.annonceur,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.co.type,
              style: TextStyle(
                fontSize: 12.0,
                // color: Colors.black38,
              ),
            ),
          ],
        ),
        Spacer(),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color:
              widget.isFollowing == 0 ? kPrimaryColor : kPrimaryLightColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            if (widget.isFollowing == 0) {
              _makePostRequest();
              _fcm.subscribeToTopic('annonceurs');
            } else {
              _makeDeleteRequest();
              _fcm.unsubscribeFromTopic('annonceurs');
            }
          },
          child: Text(
            this.widget.isFollowing == 0 ? "Follow" : "following",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
