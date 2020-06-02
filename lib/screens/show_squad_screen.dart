import 'package:flutter/material.dart';
import '../helpers/errors_text.dart';
import '../helpers/functions.dart';
import '../providers/my_clubs.dart';
import '../providers/player.dart';
import '../providers/players.dart';
import '../providers/squad.dart';
import '../providers/squads.dart';
import 'package:provider/provider.dart';

class ShowSquadScreen extends StatefulWidget {
  static const routeName = '/show-squad';

  @override
  _ShowSquadScreenState createState() => _ShowSquadScreenState();
}

class _ShowSquadScreenState extends State<ShowSquadScreen> {
  void didChangeDependencies() {
    final playersProvider = Provider.of<Players>(context, listen: false);
    final myClubsProvider = Provider.of<MyClubs>(context, listen: false);
    final activeClub = myClubsProvider.getActiveClub();
    playersProvider.getAllPlayerFromClub(activeClub.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context, listen: false);

    final clubsData = Provider.of<MyClubs>(context, listen: false);
    final squadsProvider = Provider.of<Squads>(context);

    final Squad activeSquad = squadsProvider.getSelectedSquad();

    final clubId = clubsData.getActiveClub().id;

    final playersFromClub = playersProvider.items;
    final List<Player> playersFormActiveSquad = [];

    for (var i = 0; i < playersFromClub.length; i++) {
      for (var j = 0; j < activeSquad.playersId.length; j++) {
        if (playersFromClub[i].id == activeSquad.playersId[j]) {
          playersFormActiveSquad.add(playersFromClub[i]);
        }
      }
    }

    var goalkeepers = playersFormActiveSquad
        .where((p) => p.position == Position.Goalkeeper)
        .toList();

    var defenders = playersFormActiveSquad
        .where((p) => p.position == Position.Defender)
        .toList();

    var midfielders = playersFormActiveSquad
        .where((p) => p.position == Position.Midfielder)
        .toList();

    var strikers = playersFormActiveSquad
        .where((p) => p.position == Position.Striker)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(activeSquad.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Formacja',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${activeSquad.formation[1].toString()}-${activeSquad.formation[2].toString()}-${activeSquad.formation[3].toString()}',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  'Podstawowa 11:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 500,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Bramkarz:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ...goalkeepers
                      .map((p) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${p.name} ${p.surname}'),
                            ),
                          ))
                      .toList(),
                  Center(
                    child: Text(
                      'Obrońcy:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ...defenders
                      .map((p) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${p.name} ${p.surname}'),
                            ),
                          ))
                      .toList(),
                  Center(
                    child: Text(
                      'Pomocnicy:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ...midfielders
                      .map((p) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${p.name} ${p.surname}'),
                            ),
                          ))
                      .toList(),
                  Center(
                    child: Text(
                      'Napastnicy:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ...strikers
                      .map((p) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${p.name} ${p.surname}'),
                            ),
                          ))
                      .toList(),
                ],
              ),
            )
          ]),
        ))),
      ),
    );
  }
}
