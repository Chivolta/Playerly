import 'package:flutter/material.dart';
import 'package:playerly/providers/my_club.dart';
import 'package:playerly/screens/club_management_screen.dart';
import 'package:provider/provider.dart';

class ClubItem extends StatelessWidget {
  void selectClub(context, clubId) {
    Navigator.of(context)
        .pushNamed(ClubManagementScreen.routeName, arguments: clubId);
  }

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<MyClub>(context);
    final totalExpenses = club.getTotalExpenses();
    final totalReveneus = club.getTotalReveneus();

    return InkWell(
      child: Card(
        margin: EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    club.name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.attach_money),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Przychody(m): $totalReveneus'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Wydatki(m): $totalExpenses'),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.attach_money),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Majątek: ${club.fortune}'),
                      )
                    ],
                  ),
                  // club.nextMatch.isNotEmpty
                  //     ? Row(
                  //         children: <Widget>[
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Icon(Icons.navigate_next),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text('Następny mecz z: ${club.nextMatch}'),
                  //           ),
                  //         ],
                  //       )
                  //     : null,
                  // club.nextMatch.isNotEmpty
                  //     ? Row(
                  //         children: <Widget>[
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Icon(Icons.skip_previous),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(
                  //                 'Poprzedni mecz z: ${club.previousMatch}'),
                  //           ),
                  //         ],
                  //       )
                  //     : null,
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () => selectClub(context, club.id),
      splashColor: Colors.purple,
    );
  }
}
