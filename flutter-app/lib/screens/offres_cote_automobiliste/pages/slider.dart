import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pim/screens/Home/assets.dart';
import 'package:pim/screens/Home/network_image.dart';

class SlidersPage extends StatelessWidget {
  static final String path = "lib/src/pages/misc/sliders.dart";
  final List<String> images = [
    avatars[0],
    breakfast,
    fishtail,
    avatars[2],
    pancake,
    fewalake,
    avatars[3],
    fries,
    kathmandu1,
    avatars[1],
    burger,
    pashupatinath,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sliders'),
      ),
      body: Container(
        height: 300,
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: PNetworkImage(
                images[index],
                fit: BoxFit.cover,
              ),
            );
          },
          itemWidth: 300,
          itemCount: 10,
          layout: SwiperLayout.STACK,
        ),
      ),
    );
  }
}
