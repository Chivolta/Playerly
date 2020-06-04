import '../providers/sponsors.dart';
import '../providers/my_club.dart';
import 'my_club.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

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

  Future<void> getAllClubs() async {
    print('Getting all clubs');
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
  Future<void> deleteClub(clubId) async {
    print('Deleting club');
    var deletedIndex = _myClubs.indexWhere((c) => c.id == clubId);
    // var deletedClub = _myClubs[deletedIndex];
    _myClubs.removeAt(deletedIndex);

    try {
      await databaseReference.collection('clubs').document(clubId).delete();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addMyClub(MyClub club, newSponsors, context) async {
    print('Adding my club');
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

    notifyListeners();
  }

  MyClub getMyClubById(clubId) {
    return _myClubs.firstWhere((c) => c.id == clubId);
  }
}
