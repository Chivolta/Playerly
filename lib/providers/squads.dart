import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/squad.dart';

class Squads with ChangeNotifier {
  List<Squad> _squads = [];
  final databaseReference = Firestore.instance;

  List<Squad> get items {
    return [..._squads];
  }

  Squad _selectedSquad;

  Future<void> addSquad(Squad squad, clubId) async {
    print('Adding a squad');
    DocumentReference ref = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('squads')
        .add({
      'name': squad.name,
      'formation': squad.formation,
      'playersId': squad.playersId
    });

    squad.id = ref.documentID;
    _squads.add(squad);

    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  Future<void> getAllSquadsFromClub(clubId) async {
    print('Getting all squads from club');
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('squads')
        .getDocuments()
        .then((value) {
      var squads = value.documents.map((e) => Squad.fromFirestore(e)).toList();
      _squads = squads;
      notifyListeners();
    });
  }

  Squad getSelectedSquad() {
    return _selectedSquad; // TODO: How to clone this shit
  }

  Squad getSquadById(squadId) {
    return _squads.firstWhere((c) => c.id == squadId, orElse: () => null);
  }

  void setSelectedSquad(squadId) {
    _selectedSquad = getSquadById(squadId);
  }
}
