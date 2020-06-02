import 'package:flutter/material.dart';
import '../providers/my_match.dart';

class EndedMatchStatistics extends StatelessWidget {
  MyMatch selectedMyMatch;

  EndedMatchStatistics(this.selectedMyMatch);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
            'Wynik: ${selectedMyMatch.ourGoals} - ${selectedMyMatch.opponentGoals}'),
        Text(
          'Przychód: ${selectedMyMatch.revenue}',
        ),
      ],
    );
  }
}
