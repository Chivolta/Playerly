import 'package:flutter/material.dart';

enum Position { Goalkeeper, Defender, Midfielder, Striker }

class Player with ChangeNotifier {
  String id;
  String clubId;
  String name;
  String surname;
  int age;
  int number;
  Position position;
  double salary;
  int totalGoals;
  int totalAssists;
  int totalTacles;
  int totalGoalsConceded;
  double averageGrade;
  bool isInjury;
  DateTime injuryDate;

  String getPosition() {
    if (position == Position.Goalkeeper) {
      return "Bramkarz";
    }
    if (position == Position.Defender) {
      return "Obrońca";
    }
    if (position == Position.Midfielder) {
      return "Pomocnik";
    }
    if (position == Position.Striker) {
      return "Napastnik";
    }
    return "";
  }

  Player(
      {@required this.id,
      @required this.clubId,
      @required this.name,
      @required this.surname,
      @required this.age,
      @required this.number,
      @required this.position,
      @required this.salary,
      this.totalGoals = 0,
      this.totalAssists = 0,
      this.totalTacles = 0,
      this.totalGoalsConceded = 0,
      this.averageGrade = 0,
      this.isInjury = false,
      this.injuryDate});
}
