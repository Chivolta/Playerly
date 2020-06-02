import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Squad with ChangeNotifier {
  static const formationList = [
    [1, 4, 4, 2],
    [1, 3, 5, 2],
    [1, 4, 3, 3]
  ];

  String id;
  String name;
  List<int> formation;
  List<String> playersId;

  Squad({
    @required this.id,
    @required this.name,
    @required this.formation,
    @required this.playersId,
  });

  factory Squad.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Squad(
      id: doc.documentID,
      name: data['name'],
      formation: new List<int>.from(data['formation']),
      playersId: new List<String>.from(data['playersId']),
    );
  }
}
