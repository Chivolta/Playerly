import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sponsor with ChangeNotifier {
  String name;
  double revenue;
  String id;

  Sponsor({
    @required this.name,
    @required this.revenue,
    @required this.id,
  });

  factory Sponsor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Sponsor(
        name: data['name'], id: doc.documentID, revenue: doc['revenue']);
  }
}
