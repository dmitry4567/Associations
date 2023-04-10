import 'dart:math';
import 'package:flutter/material.dart';

import 'cards.dart';

class LogicState with ChangeNotifier {
  List players = [
    ["player1", 0],
    ["player2", 0],
    ["player3", 0],
    ["player4", 0],
    ["player5", 0],
  ];

  List<int> cards_number = [];
  List cards = [];

  int i = 0;
  int skipCount = 0;
  int peopleCount = 0;
  int index = 0;

  String get player {
    return players[i][0];
  }

  String get playerPoints {
    return players[i][1].toString();
  }

  bool checkNumber(int number) {
    for (var h = 0; h < cards_number.length; h++) {
      if (number == cards_number[h]) {
        return false;
      }
    }
    cards_number.add(number);
    return true;
  }

  void setCards(int length) {
    var x;
    while (cards_number.length < length) {
      x = Random().nextInt(length);
      checkNumber(x);
    }
    for (int x = 0; x < cards_number.length; x++) {
      cards.add(cardsbd[cards_number[x]]);
    }
    print(cards_number);
    cards_number = [];
  }

  void addPointPlayer() {
    players[i % peopleCount][1] += 1;
  }

  void skipCard() {
    skipCount += 1;
    notifyListeners();
  }

  void setIndex(int setindex) {
    index = setindex;
  }

  void nextPeople() {
    i++;
    notifyListeners();
  }
}
