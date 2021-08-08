import 'package:flutter/material.dart';


import 'components/body.dart';

class ProfileScreenAnnonceur extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Body(),
    );
  }
}
