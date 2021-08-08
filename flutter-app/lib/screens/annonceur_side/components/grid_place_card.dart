import 'package:flutter/material.dart';
import 'package:pim/models/offre.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:pim/screens/annonceur_side/components/liked_button.dart';
import 'package:pim/constants.dart';

import '../../../util.dart';

class GridPlaceCard extends StatelessWidget {
  const GridPlaceCard({Key key, @required this.place, @required this.tapEvent})
      : super(key: key);

  final Offre place;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapEvent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Hero(
                tag: place.idOffre,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(link + "/file/" + place.imageOffer))),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: cardInfoDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            place.gouvernorat,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          LikedButton()
                        ],
                      ),
                      SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (v) {},
                        starCount: 5,
                        rating: place.somme.toDouble(),
                        size: 15,
                        isReadOnly: true,
                        color: kRatingStarColor,
                        borderColor: kRatingStarColor,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
