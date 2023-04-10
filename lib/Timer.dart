import 'package:flutter/cupertino.dart';

class TimeState with ChangeNotifier {
  int time2 = 0;
  int timeFinish = 0;

  int get time => time2;

  set time(int newTime) {
    time2 = newTime;
    notifyListeners();
  }

  void updateColor() {
    notifyListeners();
  }
}
