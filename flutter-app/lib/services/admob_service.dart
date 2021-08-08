import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  String getAdMobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2436093138329511~8255157098';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2436093138329511~8255157098';
    }
    return null;
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2334510780816542/6833456062';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2436093138329511/3436755316';
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  InterstitialAd getNewTripInterstitial() {
    return InterstitialAd(
      adUnitId: getInterstitialAdId(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
