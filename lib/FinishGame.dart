import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'UsersColors.dart';
import 'custom_progress_bar.dart';

class CardFinish extends StatefulWidget {
  int people_length;
  int cards_length;
  int time;
  List players;

  CardFinish(
      {required this.people_length,
      required this.cards_length,
      required this.time,
      required this.players});

  @override
  State<CardFinish> createState() => _CardFinishState();
}

class _CardFinishState extends State<CardFinish> {
  final ConfettiController _controller1 =
      ConfettiController(duration: const Duration(seconds: 10));
  String winner = "";
  int sumPoints = 0;

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _controller1.play();
    print(widget.players);
    widget.players.sort(((a, b) => b[1].compareTo(a[1])));
    widget.players.forEach((element) {
      sumPoints += int.parse(element[1].toString());
    });
    winner = widget.players[0][0];
    print(widget.players);
    print(sumPoints.toString());
    print(widget.players[0][0]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
  }

  Future<void> showInterstitialAd() async {
    final ad = await InterstitialAd.create(
      adUnitId: 'R-M-2313933-1',
      onAdLoaded: () {
        /* Do something */
      },
      onAdFailedToLoad: (error) {
        /* Do something */
      },
    );
    await ad.load(adRequest: AdRequest());
    await ad.show();
    await ad.waitForDismiss();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB3B3B3),
      body: Stack(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(top: 65, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/other_icons/cup.png",
                        scale: 4,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        sumPoints != 0
                            ? winner.toString()
                            : FlutterI18n.translate(context, "draw"),
                        style: TextStyle(
                          color: Color(0xff93278F),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      sumPoints != 0
                          ? Text(
                              FlutterI18n.translate(context, "winner"),
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Text(""),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 240,
                        width: 180,
                        child: sumPoints != 0
                            ? ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.people_length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (_, i) {
                                  return Container(
                                    height: 38,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/user_icons/p" +
                                              (int.parse(
                                                      widget.players[i][0][6]))
                                                  .toString() +
                                              ".png",
                                          scale: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.players[i][0],
                                                style: TextStyle(
                                                  color: colors[((int.parse(
                                                          widget.players[i][0]
                                                              [6])) -
                                                      1)],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              CustomProgressBar(
                                                color: colors[((int.parse(widget
                                                        .players[i][0][6])) -
                                                    1)],
                                                width: 92,
                                                value: int.parse(widget
                                                    .players[i][1]
                                                    .toString()),
                                                totalValue: sumPoints,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text("Нет данных"),
                              ),
                      ),
                      Spacer(),
                      ClipOval(
                          child: Material(
                        color: Color(0xff93278F), // Button color
                        child: InkWell(
                          splashColor: Color(0xff999999), // Splash color
                          onTap: () async {
                            showInterstitialAd();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                FlutterI18n.translate(context, "finish"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _controller1,
              emissionFrequency: 0.02,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 5,
              blastDirectionality: BlastDirectionality.directional,
              blastDirection: pi,
              gravity: 0.2,
              shouldLoop: false,
              displayTarget: false,
              colors: [
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.white,
                Colors.pink
              ],
              minimumSize: const Size(20, 10),
              maximumSize: const Size(30, 15),
              particleDrag: 0.05,
              canvas: MediaQuery.of(context).size,
            ),
          ),
        ],
      ),
    );
  }
}
