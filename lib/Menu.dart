import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  bool locales = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB3B3B3),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipOval(
              child: Material(
                color: Colors.transparent, // Button color
                child: InkWell(
                  splashColor: Color(0xff999999), // Splash color
                  onTap: () async {
                    if (locales == false) {
                      await FlutterI18n.refresh(context, Locale("en", "US"));
                      locales = true;
                    } else {
                      await FlutterI18n.refresh(context, Locale("ru", "RU"));
                      locales = false;
                    }
                    setState(() {});
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
            left: 0,
            right: 0,
            child: Column(
              children: [
                MaterialButton(
                  minWidth: 300,
                  height: 60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(53),
                  ),
                  padding: EdgeInsets.all(12),
                  onPressed: () {
                    Navigator.pushNamed(context, "/settings_game");
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
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: 300,
                  height: 60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(53),
                  ),
                  padding: EdgeInsets.all(12),
                  onPressed: () {},
                  color: Color(0xff00A1FF),
                  child: Text(
                    FlutterI18n.translate(context, "about_developers"),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: 300,
                  height: 60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(53),
                  ),
                  padding: EdgeInsets.all(12),
                  onPressed: () {},
                  color: Color(0xff22B573),
                  child: Container(
                    width: 275,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          "assets/other_icons/money.png",
                          scale: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          FlutterI18n.translate(
                              context, "support_this_project"),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffFFFFB8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            child: Text(
              "v 1.2",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
