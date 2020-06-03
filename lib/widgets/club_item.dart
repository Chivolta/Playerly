import 'package:flutter/material.dart';
import '../providers/my_clubs.dart';
import '../providers/my_club.dart';
import '../screens/club_management_screen.dart';
import 'package:provider/provider.dart';

class ClubItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final club = Provider.of<MyClub>(context);
    final myClubsProvider = Provider.of<MyClubs>(context);

    void selectClub(context, clubId) {
      myClubsProvider.setActiveClub(clubId);
      Navigator.of(context).pushNamed(ClubManagementScreen.routeName);
    }

    void removeClub(clubId) {
      myClubsProvider.deleteClub(clubId);
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
            margin: const EdgeInsets.all(5),
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
                      // Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: const Icon(Icons.attach_money),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Majątek: ${club.fortune}'),
                          )
                        ],
                      ),
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
