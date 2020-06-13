import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/player_matches_statistics.dart';
import 'package:flutter/material.dart';
import '../providers/player.dart';
import '../providers/my_clubs.dart';
import '../providers/players.dart';
import '../screens/add_player_screen.dart';
import '../widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

class PlayersScreen extends StatefulWidget {
  static const routeName = '/players';

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  var _isInit = false;
  var _isLoading = false;
  List<Player> players = [];
  List<Player> goalkeepers = [];
  List<Player> defenders = [];
  List<Player> midfielders = [];
  List<Player> strikers = [];

  @override
  void didChangeDependencies() async {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final playersProvider = Provider.of<Players>(context);
      final clubsProvider = Provider.of<MyClubs>(context);
      var clubId = clubsProvider.getActiveClub().id;

      goalkeepers =
          players.where((p) => p.position == Position.Goalkeeper).toList();

      defenders =
          players.where((p) => p.position == Position.Defender).toList();

      midfielders =
          players.where((p) => p.position == Position.Midfielder).toList();

      strikers = players.where((p) => p.position == Position.Striker).toList();

      setState(() {
        _isLoading = false;
      });
      _isInit = true;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);

    setState(() {
      players = playersProvider.items;
      goalkeepers =
          players.where((p) => p.position == Position.Goalkeeper).toList();

      defenders =
          players.where((p) => p.position == Position.Defender).toList();

      midfielders =
          players.where((p) => p.position == Position.Midfielder).toList();

      strikers = players.where((p) => p.position == Position.Striker).toList();
    });

    bool isInjured(playerId) {
      var foundedPlayer = players.firstWhere((p) => p.id == playerId);
      if (foundedPlayer.injuryTo != null) {
        var isInjured = foundedPlayer.injuryTo.compareTo(DateTime.now());
        print(isInjured);
        return isInjured > 0 ? true : false;
      }
      return false;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Zawodnicy'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlayerScreen.routeName),
            )
          ],
        ),
        drawer: ClubManagementDrawer(),
        body: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Bramkarze:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...goalkeepers.map((p) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${p.name} ${p.surname}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Kontuzja: ${isInjured(p.id) ? 'Tak' : 'Nie'}'),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Obrońcy:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...defenders.map((p) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${p.name} ${p.surname}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Kontuzja: ${isInjured(p.id) ? 'Tak' : 'Nie'}'),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Pomocnicy:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...midfielders.map((p) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${p.name} ${p.surname}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Kontuzja: ${isInjured(p.id) ? 'Tak' : 'Nie'}'),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Napastnicy:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...strikers.map((p) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${p.name} ${p.surname}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Kontuzja: ${isInjured(p.id) ? 'Tak' : 'Nie'}'),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )
        // : ListView.builder(
        //     itemCount: players.length,
        //     itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //         value: players[i],
        //         child: InkWell(
        //           child: Card(
        //             // elevation: 10,
        //             margin: const EdgeInsets.all(1),
        //             child: Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: <Widget>[
        //                   Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: <Widget>[
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                             '${(i + 1).toString()}. ${players[i].name} ${players[i].surname}, Pozycja: ${players[i].getPosition()}'),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                             'Kontuzja: ${isInjured(players[i].id) ? 'Tak' : 'Nie'}'),
        //                       ),
        //                     ],
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //           onTap: () => {},
        //           hoverColor: Colors.purple,
        //           focusColor: Colors.purple,
        //           splashColor: Colors.purple,
        //         )),
        //   ),
        );
  }
}
