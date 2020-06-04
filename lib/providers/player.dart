import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Position { Goalkeeper, Defender, Midfielder, Striker }

class Player with ChangeNotifier {
  String id;
  String name;
  String surname;
  int age;
  int number;
  Position position;
  double salary;

  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    Position position;

    if (data['position'] == 0) {
      position = Position.Goalkeeper;
    }

    if (data['position'] == 1) {
      position = Position.Defender;
    }

    if (data['position'] == 2) {
      position = Position.Midfielder;
    }

    if (data['position'] == 3) {
      position = Position.Striker;
    }

    return Player(
      id: doc.documentID,
      name: data['name'],
      surname: data['surname'],
      age: data['age'],
      number: data['number'],
      position: position,
      salary: data['salary'],
    );
  }

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

  Player({
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.age,
    @required this.number,
    @required this.position,
    @required this.salary,
  });
}
