import 'package:flutter/material.dart';
import '../providers/my_clubs.dart';
import '../providers/my_club.dart';
import '../screens/club_management_screen.dart';
import 'package:provider/provider.dart';

class ClubItem extends StatelessWidget {
  void selectClub(context, clubId) {
    Navigator.of(context)
        .pushNamed(ClubManagementScreen.routeName, arguments: clubId);
  }

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<MyClub>(context);
    final clubs = Provider.of<MyClubs>(context);
    // final totalExpenses = club.getTotalExpenses();
    // final totalReveneus = club.getTotalReveneus();

    void removeClub(clubId) {
      clubs.deleteClub(clubId);
      Navigator.of(context).pop(false);
    }

    return InkWell(
      child: Dismissible(
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                      const Text("Jesteś pewien, że chcesz usunąć ten klub?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => removeClub(club.id),
                        child: const Text("Usuń")),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Anuluj"),
                    ),
                  ],
                );
              },
            );
          },
          key: Key(club.id),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text('Przychody(m): $totalReveneus'),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text('Wydatki(m): $totalExpenses'),
                          // ),
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
          )),
      onTap: () => selectClub(context, club.id),
      splashColor: Colors.purple,
    );
  }
}
