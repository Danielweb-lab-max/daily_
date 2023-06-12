import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

const int maxFailedLoadAttempts = 3;

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  //final user=FirebaseAuth.instance.currentUser!;
  //InterstitialAd? _interstitialAd;
  //int _interstitialLoadAttempts=0;
  int _rewardedLoadAttempts = 0;
  RewardedAd? _rewardedAd;
  int _rewardLoadAttempts = 0;

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback:
          RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
        _rewardedAd = ad;
        _rewardedLoadAttempts = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        _rewardedAd = null;
        if (_rewardedLoadAttempts >= maxFailedLoadAttempts) {
          _createRewardedAd();
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
        Navigator.pushNamed(context, '/');
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
         ad.dispose();
         _createRewardedAd();
        // Navigator.pushNamed(context, '/index_screen');
      });

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print("${reward.amount} ${reward.type}");
      });
    }
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-8079412866368398/8819342141'
        : 'ca-app-pub-8079412866368398/8819342141',
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );



  @override
  void initState() {
    super.initState();
    myBanner.load();
    //_createInterstitialAd();
    //_showInterstitialAd();
    _createRewardedAd();
    _showRewardedAd();
  }

  void dispose() {
    super.dispose();
    myBanner.dispose();
    //_interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.2],
                    colors: [Colors.green, Colors.blueAccent]),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [

                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('messages').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messages = snapshot.data!.docs;
                          List<Padding> messageWidgets = [];
                          for (var message in messages) {
                            final messageNationality1 =
                                message.get('Nationality1');
                            final messageTeam1 = message.get('Team1');
                            final messageTime1 = message.get('Time1');
                            final messageWin1 = message.get('Win1');
                            final messageNationality2 =
                                message.get('Nationality2');
                            final messageTeam2 = message.get('Team2');
                            final messageTime2 = message.get('Time2');
                            final messageWin2 = message.get('Win2');
                            final messageOdds = message.get('Odds');

                            final messageWidget = Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [

                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.emoji_events,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageNationality1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.access_time_filled,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageTime1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.sports_kabaddi_outlined,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageTeam1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.sports_score,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageWin1',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.emoji_events,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageNationality2',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.access_time_filled,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageTime2',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.sports_kabaddi_outlined,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageTeam2',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.sports_score,
                                              size:20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageWin2',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.thumb_up_off_alt_sharp,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            title: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$messageOdds',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                            messageWidgets.add(messageWidget);
                          }
                          return Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              thickness: 10,

                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                children: messageWidgets,
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Material(
                        color: Colors.black,
                        //borderRadius: BorderRadius.circular(10),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/");
                            // _showRewardedAd();
                          },
                          height: 20,
                          minWidth: 40,
                          child: Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: myBanner.size.height.toDouble(),
                      //height:20,
                      width: myBanner.size.width.toDouble(),
                      //width: 200,

                      child: AdWidget(
                        ad: myBanner,
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
