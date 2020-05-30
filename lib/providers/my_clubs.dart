import 'package:flutter/material.dart';
import 'package:playerly/data/my_clubs.dart';
import 'package:playerly/providers/my_club.dart';

class MyClubs with ChangeNotifier {
  List<MyClub> _myClubs = myClubsData;

  MyClub _activeClub = myClubsData[0];

  MyClub getActiveClub() {
    return _activeClub; // TODO: How to clone this shit
  }

  void setActiveClub(clubId) {
    _activeClub = getMyClubById(clubId);
  }

  List<MyClub> get items {
    return [..._myClubs];
  }

  void addMyClub(club) {
    _myClubs.add(club);
    notifyListeners(); // notify all widgets about changes - so we used ChangeNotifier
  }

  MyClub getMyClubById(clubId) {
    return _myClubs.firstWhere((c) => c.id == clubId);
  }
}
