import 'package:flutter/material.dart';

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const ProfileInfoBigCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16,
          bottom: 24,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(firstText,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFF1A1316),
                  fontWeight: FontWeight.w600,
                )),
            Text(secondText,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF8391A0),
                  fontWeight: FontWeight.w200,
                )),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath;

  const ProfileInfoCard(
      {Key key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(
                child: Icon(
                  imagePath,
                  color: Colors.black,
                ),
              )
            : TwoLineItem(
                firstText: firstText,
                secondText: secondText,
              ),
      ),
    );
  }
}

class TwoLineItem extends StatelessWidget {
  final String firstText, secondText;

  const TwoLineItem(
      {Key key, @required this.firstText, @required this.secondText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: TextStyle(
            fontSize: 22.0,
            color: Color(0xFF1A1316),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          secondText,
          style: TextStyle(
            fontSize: 18.0,
            color: Color(0xFF8391A0),
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
