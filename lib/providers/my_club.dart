import 'package:flutter/material.dart';

class Sponsor {
  String name;
  double revenue;
  String id;

  Sponsor(this.name, this.revenue, this.id);
}

class MyClub with ChangeNotifier {
  String id;
  String name;
  String owner;
  List<double> reveneus;
  List<Sponsor> sponsors;
  List<double> expenses;
  double fortune;
  // double playedMatches; // do pobrania z terminarza
  // double matchedToPlayInCurrentSeason; // do pobrania z terminarza
  // String nextMatch; // do pobrania z terminarza
  // String previousMatch; // do pobrania z terminarza

  MyClub({
    this.id,
    @required this.name,
    @required this.owner,
    this.reveneus,
    this.sponsors,
    this.expenses,
    this.fortune,
    // this.playedMatches,
    // this.matchedToPlayInCurrentSeason,
    // this.nextMatch,
    // this.previousMatch});
  });

  double getTotalReveneus() {
    return getTotalReveneusFromSponsors() +
        this.reveneus.reduce((value, element) {
          return value + element;
        });
  }

  double getTotalExpenses() {
    return this.expenses.reduce((value, element) {
      return value + element;
    });
  }

  double getTotalReveneusFromSponsors() {
    var sum = 0.0;

    for (var i = 0; i < this.sponsors.length; i++) {
      sum += this.sponsors[i].revenue;
    }

    return sum;
  }
}
