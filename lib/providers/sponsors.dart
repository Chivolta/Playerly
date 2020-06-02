import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../providers/sponsor.dart';

class Sponsors with ChangeNotifier {
  List<Sponsor> _sponsors = [];
  final databaseReference = Firestore.instance;

  List<Sponsor> get items {
    return [..._sponsors];
  }

  void addSponsors(List<Sponsor> sponsors, clubId) async {
    for (var i = 0; i < sponsors.length; i++) {
      DocumentReference ref = await databaseReference
          .collection("clubs")
          .document(clubId)
          .collection("sponsors")
          .add({'name': sponsors[i].name, 'revenue': sponsors[i].revenue});

      sponsors[i].id = ref.documentID;
      _sponsors.add(sponsors[i]);
    }

    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }
}
