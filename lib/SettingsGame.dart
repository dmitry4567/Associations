import 'package:Associations/Logic.dart';
import 'package:Associations/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import 'Timer.dart';

class SettingsGame extends StatefulWidget {
  const SettingsGame({Key? key}) : super(key: key);

  @override
  State<SettingsGame> createState() => _SettingsGameState();
}

class _SettingsGameState extends State<SettingsGame> {
  int people_length = 2;
  int cards_length = 20;
  int time = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB3B3B3),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 60,
            child: Image.asset(
              "assets/other_icons/" +
                  FlutterI18n.currentLocale(context).toString() +
                  ".png",
              scale: 5,
            ),
          ),
          Positioned(
            bottom: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            if (people_length > 2) {
                                              people_length -= 1;
                                            }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_left,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    people_length.toString(),
                                    style: TextStyle(
                                      color: Color(0xffF7931E),
                                      fontSize: 58,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            if (people_length < 5) {
                                              people_length += 1;
                                            }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_right,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                FlutterI18n.translate(
                                    context, "numbers_of_players"),
                                style: TextStyle(
                                  color: Color(0xff999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            // if (cards_length > 10) {
                                            cards_length -= 1;
                                            // }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_left,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    cards_length.toString(),
                                    style: TextStyle(
                                      color: Color(0xffF7931E),
                                      fontSize: 58,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            if (cards_length < 20) {
                                              cards_length += 10;
                                            }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_right,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                FlutterI18n.translate(
                                    context, "number_of_cards"),
                                style: TextStyle(
                                  color: Color(0xff999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            if (time > 30) {
                                              time -= 10;
                                            }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_left,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    time.toString(),
                                    style: TextStyle(
                                      color: Color(0xffF7931E),
                                      fontSize: 58,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffE6E6E6), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            if (time < 120) {
                                              time += 10;
                                            }
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.arrow_right,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                FlutterI18n.translate(
                                    context, "running_time_in_seconds"),
                                style: TextStyle(
                                  color: Color(0xff999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MaterialButton(
                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
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
                      color: Color(0xff0065FF),
                      child: Text(
                        FlutterI18n.translate(context, "new_game"),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
