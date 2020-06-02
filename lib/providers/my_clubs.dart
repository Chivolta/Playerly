import 'dart:convert';

import 'package:com.playerly/providers/sponsors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/my_club.dart';

import 'my_club.dart';

class MyClubs with ChangeNotifier {
  List<MyClub> _myClubs = [];

  MyClub _activeClub;
  final databaseReference = Firestore.instance;

  MyClub getActiveClub() {
    return _activeClub; // TODO: How to clone this shit
  }

  void setActiveClub(clubId) {
    _activeClub = getMyClubById(clubId);
  }

  getAllClubs() async {
    await databaseReference.collection("clubs").getDocuments().then((value) {
      var clubs = value.documents.map((e) => MyClub.fromFirestore(e)).toList();
      _myClubs = clubs;
      notifyListeners();
    });
  }

  List<MyClub> get items {
    return [..._myClubs];
  }

  // TODO: Usuwanie reszty rzeczy
  deleteClub(clubId) async {
    databaseReference
        .collection('clubs')
        .document(clubId)
        .delete()
        .then((value) => print('deleted'));
  }

  void addMyClub(MyClub club, newSponsors, context) async {
    final mySponsorsProvider = Provider.of<Sponsors>(context, listen: false);
    DocumentReference ref = await databaseReference.collection("clubs").add({
      'name': club.name,
      'owner': club.owner,
      'reveneus': club.reveneus,
      'expenses': club.expenses,
      'fortune': club.fortune
    });

    club.id = ref.documentID;
    _myClubs.add(club);

    if (newSponsors.length > 0) {
      mySponsorsProvider.addSponsors(newSponsors, club.id);
    }

    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  MyClub getMyClubById(clubId) {
    return _myClubs.firstWhere((c) => c.id == clubId);
  }
}
