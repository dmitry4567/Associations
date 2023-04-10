import 'dart:async';
import 'dart:ui';
import 'package:Associations/Menu.dart';
import 'package:Associations/FinishGame.dart';
import 'package:Associations/SettingsGame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Logic.dart';
import 'MenuTop.dart';
import 'Timer.dart';
import 'UsersColors.dart';
import 'custom_progress_bar.dart';
import 'other/clippers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

double map(double x, double inMin, double inMax, double outMin, double outMax) {
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: "res/locales",
            useScriptCode: true,
          ),
          missingTranslationHandler: (key, locale) {
            print(
                "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: <Locale>[
        const Locale("en", "US"),
        const Locale("ru", "RU")
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => Menu(),
        '/settings_game': (context) => SettingsGame(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  int people_length;
  int cards_length;
  int time;

  MyHomePage(
      {required this.people_length,
      required this.cards_length,
      required this.time});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  var _controller;
  bool menu = false;

  List cards = [];

  @override
  void initState() {
    super.initState();
    Provider.of<LogicState>(context, listen: false)
        .setCards(widget.cards_length);
    Provider.of<TimeState>(context, listen: false).timeFinish = widget.time;
    Provider.of<LogicState>(context, listen: false).peopleCount =
        widget.people_length;
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300));
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void finishCards() {
    timer.cancel();
    var data = Provider.of<LogicState>(context, listen: false).players;
    Provider.of<LogicState>(context, listen: false).nextPeople();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 16,
            child: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Карты закончились",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff93278F),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    minWidth: 50,
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(53),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(
                          settings: const RouteSettings(name: '/finish'),
                          builder: (context) => CardFinish(
                              people_length: widget.people_length,
                              cards_length: widget.cards_length,
                              time: widget.time,
                              players: data),
                        ),
                      );
                    },
                    color: Color(0xff93278F),
                    child: Text(
                      "Закончить",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void startTimer() {
    Provider.of<TimeState>(context, listen: false).time2 = widget.time;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (Provider.of<LogicState>(context, listen: false).i +
              Provider.of<LogicState>(context, listen: false).skipCount ==
          widget.cards_length) {
        timer.cancel();
        var data = Provider.of<LogicState>(context, listen: false).players;
        print("1");
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            settings: const RouteSettings(name: '/finish'),
            builder: (context) => CardFinish(
                people_length: widget.people_length,
                cards_length: widget.cards_length,
                time: widget.time,
                players: data),
          ),
        );
      }
      if (Provider.of<TimeState>(context, listen: false).time == 0) {
        timer.cancel();
        print("2");
        var data = Provider.of<LogicState>(context, listen: false).players;
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            settings: const RouteSettings(name: '/finish'),
            builder: (context) => CardFinish(
                people_length: widget.people_length,
                cards_length: widget.cards_length,
                time: widget.time,
                players: data),
          ),
        );
      } else
        Provider.of<TimeState>(context, listen: false).time -= 1;
    });
  }

  CardController controller = CardController();

  var x;
  int direction = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            color: colors[Provider.of<LogicState>(context, listen: true).i %
                Provider.of<LogicState>(context, listen: false).peopleCount],
          ),
          Center(
            child: TinderSwapCard(
              swipeUp: false,
              swipeDown: false,
              orientation: AmassOrientation.BOTTOM,
              totalNum:
                  Provider.of<LogicState>(context, listen: false).cards.length,
              stackNum: 5,
              swipeEdge: 4.0,
              animDuration: 500,
              maxWidth: MediaQuery.of(context).size.width * 0.91,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              minWidth: MediaQuery.of(context).size.width * 0.9,
              minHeight: MediaQuery.of(context).size.height * 0.799,
              cardBuilder: (context, index) => Stack(
                children: [
                  index + Provider.of<LogicState>(context, listen: false).skipCount <
                          Provider.of<LogicState>(context, listen: false)
                              .cards
                              .length
                      ? (index - Provider.of<LogicState>(context, listen: false).i <
                              2
                          ? Card(
                              stopWord: Provider.of<LogicState>(context)
                                      .cards[index + Provider.of<LogicState>(context, listen: false).skipCount]
                                  [0],
                              word: Provider.of<LogicState>(context).cards[index + Provider.of<LogicState>(context, listen: false).skipCount]
                                  [1],
                              complexity: Provider.of<LogicState>(context)
                                      .cards[index + Provider.of<LogicState>(context, listen: false).skipCount]
                                  [2],
                              genre: Provider.of<LogicState>(context)
                                      .cards[index + Provider.of<LogicState>(context, listen: false).skipCount]
                                  [3],
                              hints: Provider.of<LogicState>(context)
                                  .cards[index + Provider.of<LogicState>(context, listen: false).skipCount][4],
                              index: index,
                              index_image: Provider.of<LogicState>(context).cards[index + Provider.of<LogicState>(context, listen: false).skipCount][5])
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(53.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                              ),
                            ))
                      : Container(),
                  if (direction == 1 &&
                      index ==
                          Provider.of<LogicState>(context, listen: false).i)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(53)),
                      child: Stack(
                        children: [
                          Container(
                            color: Color(0xff39B54A).withOpacity(
                              map(x, 220, 392, 0.1, 0.79),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 100),
                              child: Image.asset(
                                "assets/other_icons/like.png",
                                scale: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (direction == -1 &&
                      Provider.of<LogicState>(context, listen: false).i ==
                          index +
                              Provider.of<LogicState>(context, listen: false)
                                  .index)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(53)),
                      child: Stack(
                        children: [
                          Container(
                            color: Color.fromARGB(255, 181, 57, 57).withOpacity(
                              map(x, 210, -22, 0.1, 0.79),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 100),
                              child: Image.asset(
                                "assets/other_icons/dislike.png",
                                scale: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              cardController:
                  controller, /////////////////////////////////////////////////////////////////////////
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                if (details.localPosition.dx > 220 && details.delta.dx > 0) {
                  direction = 1;
                  x = details.localPosition.dx;
                }
                if (details.localPosition.dx < 210 && details.delta.dx < 0) {
                  direction = -1;
                  x = details.localPosition.dx;
                }
                if (details.localPosition.dx > 210 &&
                    details.localPosition.dx < 220) {
                  direction = 0;
                }
              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                direction = 0;
                print(index);
                if (orientation == CardSwipeOrientation.RIGHT) {
                  Provider.of<LogicState>(context, listen: false)
                      .addPointPlayer();
                  Provider.of<LogicState>(context, listen: false).nextPeople();
                }
                if (orientation == CardSwipeOrientation.LEFT) {
                  Provider.of<LogicState>(context, listen: false).nextPeople();
                }
                if (Provider.of<LogicState>(context, listen: false).i +
                        Provider.of<LogicState>(context, listen: false)
                            .skipCount ==
                    Provider.of<LogicState>(context, listen: false)
                        .cards
                        .length) {
                  print("3");
                  var data =
                      Provider.of<LogicState>(context, listen: false).players;
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                      settings: const RouteSettings(name: '/finish'),
                      builder: (context) => CardFinish(
                          people_length: widget.people_length,
                          cards_length: widget.cards_length,
                          time: widget.time,
                          players: data),
                    ),
                  );
                }
              },
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Positioned(
                top: (-MediaQuery.of(context).size.width +
                        85 * (1 - _controller.value)) *
                    0.8 *
                    (2 - _controller.value),
                right: (-MediaQuery.of(context).size.width +
                        85 * (1 - _controller.value)) *
                    0.8 *
                    (2 - _controller.value),
                child: menu
                    ? BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: MenuTop(
                          people_length: widget.people_length,
                          cards_length: widget.cards_length,
                          time: widget.time,
                        ),
                      )
                    : MenuTop(
                        people_length: widget.people_length,
                        cards_length: widget.cards_length,
                        time: widget.time,
                      ),
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                switch (_controller.status) {
                  case AnimationStatus.completed:
                    _controller.reverse();
                    menu = false;
                    break;
                  case AnimationStatus.dismissed:
                    _controller.forward();
                    menu = true;
                    break;
                  default:
                }
                setState(() {});
              },
              child: menu
                  ? Icon(
                      Icons.close,
                      color: Color(0xffB3B3B3),
                    )
                  : Image.asset(
                      "assets/other_icons/open_panel.png",
                      scale: 6,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  String index_image;
  String stopWord;
  String word;
  int complexity;
  String genre;
  int index;
  List<String> hints;

  Card(
      {required this.word,
      required this.stopWord,
      required this.complexity,
      required this.genre,
      required this.hints,
      required this.index,
      required this.index_image});

  String hintsToString() {
    List<String> hints2 = hints;
    String hintString = "";
    for (var i = 0; i < hints2.length; i++) {
      hintString += hints2[i] + " ";
    }
    return hintString.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(53.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(53)),
            child: ListView(
              key: UniqueKey(),
              controller: ScrollController(keepScrollOffset: false),
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipPath(
                            clipper: MyClipper2(),
                            child: Container(
                              padding: EdgeInsets.only(top: 60),
                              width: double.infinity,
                              height: 400,
                              child: Image.asset(
                                'assets/cards/films/' + index_image.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: MyClipper(),
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(53),
                                  topRight: Radius.circular(53),
                                ),
                                color: Color(0xffFF001E),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 30),
                                      child: Text(
                                        "#" + stopWord.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 10,
                                    child: ClipOval(
                                      child: Material(
                                        color:
                                            Color(0xffFF001E), // Button color
                                        child: InkWell(
                                          splashColor:
                                              Color(0xff999999), // Splash color
                                          onTap: () {
                                            Provider.of<LogicState>(context,
                                                    listen: false)
                                                .setIndex(index);
                                            Provider.of<LogicState>(context,
                                                    listen: false)
                                                .skipCard();
                                          },
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Image.asset(
                                              "assets/other_icons/refresh.png",
                                              scale: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                  child: Image.asset("assets/user_icons/p1" +
                                      (index %
                                                  Provider.of<LogicState>(
                                                          context,
                                                          listen: false)
                                                      .peopleCount +
                                              1)
                                          .toString() +
                                      ".png")),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "player" +
                            (index %
                                        Provider.of<LogicState>(context,
                                                listen: false)
                                            .peopleCount +
                                    1)
                                .toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffB3B3B3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                final double width = constraints.maxWidth;
                                return Container(
                                  height: 30,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 14,
                                        left: 24,
                                        right: 0,
                                        child: Consumer<TimeState>(
                                          builder: (context, timeState, _) =>
                                              CustomProgressBar(
                                            color: Color(0xffF7931E),
                                            width: width - 24,
                                            value: timeState.time,
                                            totalValue: timeState.timeFinish,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        child: Container(
                                          child: Center(
                                            child: Image.asset(
                                              "assets/other_icons/timer.png",
                                              scale: 5,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    genre.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xffB3B3B3),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    word,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xff33334A),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 15.5,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: 3,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, i) {
                                        return i < complexity
                                            ? Row(children: [
                                                Image.asset(
                                                  "assets/other_icons/star.png",
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                              ])
                                            : Row(children: [
                                                Image.asset(
                                                  "assets/other_icons/unstar.png",
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                              ]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 11),
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                              color: Color(0xffB3B3B3),
                            ),
                            Text(
                              FlutterI18n.translate(context, "see_hints"),
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  color: Color(0xffF7DFBF),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        hintsToString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff33334A).withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
