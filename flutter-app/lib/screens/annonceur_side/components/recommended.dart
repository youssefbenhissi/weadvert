import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Recommended extends StatelessWidget {
  const Recommended({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              tr('Your Offers'),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
