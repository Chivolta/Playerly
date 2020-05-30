import 'package:flutter/material.dart';
import 'package:playerly/data/players.dart';
import 'package:playerly/providers/player.dart';

class Players with ChangeNotifier {
  List<Player> _players = playersData;

  List<Player> get items {
    return [..._players];
  }

  void addPlayer(player) {
    _players.add(player);
    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  List<Player> getPlayerFromClubById(clubId) {
    print(clubId);
    return _players.where((p) => p.clubId == clubId).toList();
  }

  // MyClub getPlayer(clubId) {
  //   return _myClubs.firstWhere((c) => c.id == clubId);
  // }
}
