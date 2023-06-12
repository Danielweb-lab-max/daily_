import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:free_rollover/screens/index_screen.dart';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

final Uri _url = Uri.parse('https://t.me/+OrWfErPP7nE5MTZk');
const int maxFailedLoadAttempts = 1;

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? title = "";
  String? body="";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //InterstitialAd? _interstitialAd;
  // int _interstitialLoadAttempts=0;
  int _rewardedLoadAttempts = 0;
  RewardedAd? _rewardedAd;

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-8079412866368398/6268366276'
          : 'ca-app-pub-8079412866368398/6268366276',
      request: AdRequest(),
      rewardedAdLoadCallback:
          RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
        _rewardedAd = ad;
        _rewardedLoadAttempts = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        _rewardedAd = null;
       // Navigator.pushNamed(context, '/index_screen');

            if (_rewardedLoadAttempts >= maxFailedLoadAttempts) {
          //_createRewardedAd();
          Navigator.pushNamed(context, '/index_screen');


        }
      }),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          // onAdShowedFullScreenContent:(RewardedAd ad){
          //
          // },
          onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        Navigator.pushNamed(context, '/index_screen');
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        Navigator.pushNamed(context, '/index_screen');

        //_createRewardedAd();

      });

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print("${reward.amount} ${reward.type}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
    _showRewardedAd();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
    FirebaseMessaging.instance.subscribeToTopic('Animal');
  }

  void dispose() {
    super.dispose();
    //_interstitialAd?.dispose();
    _rewardedAd?.dispose();

  }
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) => print(token));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
          title: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Free Tips Daily',
              textStyle: const TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 70),
            ),
          ],
          totalRepeatCount: 1000,
          pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      )),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.4, 0.8],
              colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent]),
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Container(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white70,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.warning_amber_sharp,
                                                size: 60,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "Requires Active Internet Access",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.red,
                                          child: SizedBox.expand(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(2.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Watch ads to view Today's Free Odds",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _showRewardedAd();
                                                    },
                                                    child: Text("Okay"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(11.0),
                                                      ),
                                                      backgroundColor:
                                                      Colors.black,
                                                      minimumSize: Size(40, 40),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                        "TODAY 2+ TICKET",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: Colors.white,
                        minimumSize: Size(50, 70),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),

                    //borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/terms_screen');
                      },
                      child: Text(
                        "TERMS OF USE",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: Colors.black,
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),

                    //borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/legal_screen');
                      },
                      child: Text(
                        "LEGAL DISCLAIMER",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: Colors.black,
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ),Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),

                    //borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        const url = 'https://play.google.com/store/apps/details?id=com.daily_rollover_proApp.daily_rollover_proapp&pli=1';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        "PRO VERSION APP",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.yellow,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.black,
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),

                    //borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        const url = 'https://t.me/FreeOddsDaily100';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        "TELEGRAM",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blueAccent,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        backgroundColor: Colors.black,
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 16),
                  //
                  //   //borderRadius: BorderRadius.circular(10),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       const url = 'https://bit.ly/41eGT93';
                  //       if (await canLaunch(url)) {
                  //         await launch(url);
                  //       } else {
                  //         throw 'Could not launch $url';
                  //       }
                  //     },
                  //     child: Text(
                  //       "JOIN US!!!",
                  //       style: TextStyle(
                  //         fontSize: 25,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(11.0),
                  //       ),
                  //       backgroundColor: Colors.black,
                  //       minimumSize: Size(50, 50),
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
