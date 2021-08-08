import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pim/utilities/theme.dart' as config;

class MyThemes {
  static final List<ThemeData> themes = [
    ThemeData(
      fontFamily: 'avenir',
      primaryColor: Color(0xFF252525),
      brightness: Brightness.dark,
      secondaryHeaderColor: Color(0xFFFFFF),
      scaffoldBackgroundColor: Color(0xFF2C2C2C),
      accentColor: config.Colorss().mainDarkColor(1),
      hintColor: config.Colorss().secondDarkColor(1),
      focusColor: config.Colorss().accentDarkColor(1),
      textTheme: TextTheme(
        button: TextStyle(color: Color(0xFFF5F5F5)),
        headline5: TextStyle(
            fontSize: 20.0, color: config.Colorss().secondDarkColor(1)),
        headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondDarkColor(1)),
        headline3: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondDarkColor(1)),
        headline2: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: config.Colorss().mainDarkColor(1)),
        headline1: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w300,
            color: config.Colorss().secondDarkColor(1)),
        subtitle1: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: config.Colorss().secondDarkColor(1)),
        headline6: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().mainDarkColor(1)),
        bodyText2: TextStyle(
            fontSize: 12.0, color: config.Colorss().secondDarkColor(1)),
        bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondDarkColor(1)),
        caption: TextStyle(
            fontSize: 12.0, color: config.Colorss().secondDarkColor(0.7)),
      ),
    ),
    ThemeData(
      fontFamily: 'avenir',
      primaryColor: Color(0xFFFFFFFF),
      secondaryHeaderColor: Color(0x000000),
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      accentColor: config.Colorss().mainColor(1),
      focusColor: config.Colorss().accentColor(1),
      hintColor: config.Colorss().secondColor(1),
      primaryColorDark: Color(0xFFADC4C8),
      textTheme: TextTheme(
        button: TextStyle(color: Color(0xFFFFFFFF)),
        headline5:
            TextStyle(fontSize: 20.0, color: config.Colorss().secondColor(1)),
        headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondColor(1)),
        headline3: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondColor(1)),
        headline2: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: config.Colorss().mainColor(1)),
        headline1: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w300,
            color: config.Colorss().secondColor(1)),
        subtitle1: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: config.Colorss().secondColor(1)),
        headline6: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().mainColor(1)),
        bodyText2:
            TextStyle(fontSize: 12.0, color: config.Colorss().secondColor(1)),
        bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: config.Colorss().secondColor(1)),
        caption:
            TextStyle(fontSize: 12.0, color: config.Colorss().secondColor(0.6)),
      ),
    ),
  ];

  static ThemeData getThemeFromIndex(int index) {
    return themes[index];
    // try {
    //   return themes[int.parse(index)];
    // } catch (e) {
    //   print(e);
    // }
  }

  static Future<ThemeData> getSavedTheme() async {
    String index = await getSavedThemeIndex();
    return getThemeFromIndex(index != null ? index : 1);
  }

  static Future<String> getSavedThemeIndex() async {
    final pref = await SharedPreferences.getInstance();
    final index = pref.getString("ui_theme");
    return index;
  }
}

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

class Colorss {
  Color _mainColor = Color(0xffffac30); //Color(0xFF009DB5);
  Color _mainDarkColor = Color(0xffffac30); //Color(0xFF22B7CE);
  Color _secondColor = Color(0xff000000); //Color(0xFF04526B);
  Color _secondDarkColor = Color(0xFFE7F6F8);
  Color _accentColor = Color(0xFFADC4C8);
  Color _accentDarkColor = Color(0xFFADC4C8);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}
