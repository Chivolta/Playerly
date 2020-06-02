import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/player.dart';

class Players with ChangeNotifier {
  List<Player> _players = [];
  final databaseReference = Firestore.instance;

  List<Player> get items {
    return [..._players];
  }

  void addPlayer(Player player, clubId) async {
    DocumentReference ref = await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('players')
        .add({
      'name': player.name,
      'surname': player.surname,
      'age': player.age,
      'number': player.number,
      'position': player.position.index,
      'salary': player.salary,
    });

    player.id = ref.documentID;
    _players.add(player);

    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  getAllPlayerFromClub(clubId) async {
    await databaseReference
        .collection("clubs")
        .document(clubId)
        .collection('players')
        .getDocuments()
        .then((value) {
      var players =
          value.documents.map((e) => Player.fromFirestore(e)).toList();
      _players = players;
      notifyListeners();
    });
  }
}
