import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                tr("Choose language"),
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'English',
                subtitle: 'English',
                locale: EasyLocalization.of(context).supportedLocales[0]),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'French',
                subtitle: 'French',
                locale: EasyLocalization.of(context).supportedLocales[1]),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Container buildDivider() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Divider(
          color: Colors.grey,
        ),
      );

  Container buildSwitchListTileMenuItem(
      {BuildContext context, String title, String subtitle, Locale locale}) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: ListTile(
          dense: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () {
            log(locale.toString(), name: toString());
            context.locale = locale;

            Navigator.pop(context);
          }),
    );
  }
}
