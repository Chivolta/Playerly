import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyClub with ChangeNotifier {
  String id;
  String name;
  String owner;
  List<double> expenses;
  List<double> reveneus;
  double fortune;

  MyClub({
    this.id,
    @required this.name,
    @required this.owner,
    this.expenses,
    this.reveneus,
    this.fortune,
  });

  factory MyClub.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return MyClub(
        id: doc.documentID,
        name: data['name'],
        owner: data['owner'],
        expenses: new List<double>.from(data['expenses']),
        fortune: data['fortune'],
        reveneus: new List<double>.from(data['reveneus']));
  }
}
