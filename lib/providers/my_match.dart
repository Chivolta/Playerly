import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyMatch {
  String id;
  String squadId;
  String opponentName;
  String stadiumName;
  DateTime datetimeMatch = DateTime.now();
  int ourGoals;
  int opponentGoals;
  double revenue;
  bool isEnd;

  MyMatch({
    @required this.id,
    @required this.squadId,
    @required this.opponentName,
    @required this.stadiumName,
    @required this.datetimeMatch,
    this.ourGoals,
    this.opponentGoals,
    this.revenue,
    this.isEnd = false,
  });

  factory MyMatch.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return MyMatch(
        id: doc.documentID,
        squadId: data['squadId'],
        opponentName: data['opponentName'],
        stadiumName: data['stadiumName'],
        datetimeMatch:
            DateTime.parse(data['datetimeMatch'].toDate().toString()),
        ourGoals: data['ourGoals'],
        opponentGoals: data['opponentGoals'],
        revenue: data['revenue'],
        isEnd: data['isEnd']);
  }
}
