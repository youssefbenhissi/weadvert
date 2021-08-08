import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pim/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pim/progress_button.dart';
import 'package:pim/screens/my_account/edit_car.dart';

class CustomDialog extends StatefulWidget {
  String title, description, primaryButtonText, secondaryButtonText, imgName;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      this.imgName,
      this.secondaryButtonText});
  static const double padding = 20.0;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);
  ButtonState stateTextWithIcon = ButtonState.idle;
  var primaryButtonColor = Colors.redAccent;

  _deletePic(String imgName) async {
    String url = link + '/image/' + imgName;
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.delete(url, headers: headers);

    setState(() {
      if (response.statusCode == 200) {
        widget.primaryButtonText = "Succes";
        this.primaryButtonColor = Colors.greenAccent;
        EditCarPage.imagesVoiture.remove(imgName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomDialog.padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(CustomDialog.padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(CustomDialog.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  widget.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
                AutoSizeText(
                  widget.description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  children: [
                    RaisedButton(
                      color: primaryButtonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: AutoSizeText(
                          widget.primaryButtonText,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _deletePic(this.widget.imgName);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: AutoSizeText(
                          widget.secondaryButtonText,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
