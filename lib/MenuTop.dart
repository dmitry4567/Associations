import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import 'Logic.dart';
import 'Timer.dart';
import 'main.dart';

class MenuTop extends StatelessWidget {
  int people_length;
  int cards_length;
  int time;

  MenuTop(
      {required this.people_length,
      required this.cards_length,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8 * 2,
      height: MediaQuery.of(context).size.width * 0.8 * 2,
      child: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.8 * 2 * 0.25,
            bottom: MediaQuery.of(context).size.width * 0.8 * 2 * 0.14,
            child: Column(
              children: [
                ClipOval(
                  child: Material(
                    color: Color(0xff22B573), // Button color
                    child: InkWell(
                      splashColor: Color(0xff999999), // Splash color
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                            settings: const RouteSettings(name: '/game'),
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                    create: (context) => TimeState()),
                                ChangeNotifierProvider(
                                    create: (context) => LogicState()),
                              ],
                              child: MyHomePage(
                                people_length: people_length,
                                cards_length: cards_length,
                                time: time,
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          "assets/other_icons/refresh.png",
                          scale: 6,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  FlutterI18n.translate(context, "again"),
                  style: TextStyle(
                    color: Color(0xffB3B3B3),
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ClipOval(
                  child: Material(
                    color: Color(0xff0071BC), // Button color
                    child: InkWell(
                      splashColor: Color(0xff999999), // Splash color
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          "assets/other_icons/home.png",
                          scale: 5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  FlutterI18n.translate(context, "menu"),
                  style: TextStyle(
                    color: Color(0xffB3B3B3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }
}
