import 'package:flutter/material.dart';
import '../providers/my_match.dart';

class EndedMatchStatistics extends StatelessWidget {
  final MyMatch selectedMyMatch;

  EndedMatchStatistics(this.selectedMyMatch);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: <Widget>[
          Text(
            'Wynik: ${selectedMyMatch.ourGoals} - ${selectedMyMatch.opponentGoals}',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Przychód: ${selectedMyMatch.revenue}',
            ),
          ),
        ],
      ),
    );
  }
}
