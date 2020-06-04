import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/squad.dart';
import '../providers/players.dart';
import '../providers/player_match_statistics.dart';
import '../providers/timetables.dart';
import '../providers/my_clubs.dart';
import '../providers/my_matches.dart';
import '../providers/player.dart';
import '../providers/player_matches_statistics.dart';
import '../providers/squads.dart';

class RatePlayersScreen extends StatefulWidget {
  static const routeName = '/rate-players';

  @override
  _RatePlayersScreenState createState() => _RatePlayersScreenState();
}

class _RatePlayersScreenState extends State<RatePlayersScreen> {
  var _isInit = false;
  var _isLoading = false;
  var _isInjuredList = [];
  var _ratingsList = [];
  final _form = GlobalKey<FormState>();
  List<PlayerMatchStatistics> playerMatchesStatistics = [];
  final List<Player> playersFormActiveSquad = [];

  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });

      final squadsProvider = Provider.of<Squads>(context);
      Squad getSelectedSquad(squadId) {
        return squadsProvider.getSquadById(squadId);
      }

      final myClubsProvider = Provider.of<MyClubs>(context);
      final playersProvider = Provider.of<Players>(context);
      final myMatchesProvider = Provider.of<MyMatches>(context);
      final clubId = myClubsProvider.getActiveClub().id;
      final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();

      Squad selectedSquad = getSelectedSquad(selectedMyMatch.squadId);
      playersProvider.getAllPlayerFromClub(clubId).then((_) {
        final playersFromClub = playersProvider.items;

        for (var i = 0; i < playersFromClub.length; i++) {
          for (var j = 0; j < selectedSquad.playersId.length; j++) {
            if (playersFromClub[i].id == selectedSquad.playersId[j]) {
              setState(() {
                playersFormActiveSquad.add(playersFromClub[i]);

                playerMatchesStatistics.add(PlayerMatchStatistics(
                    id: '',
                    goals: 0,
                    rating: 0.0,
                    goalsConceded: 0,
                    isInjured: false,
                    playerId: playersFromClub[i].id));
              });

              break;
            }
          }
        }
        setState(() {
          print(playersFormActiveSquad.length);
          _isLoading = false;
        });
      });
    }

    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final myMatchesProvider = Provider.of<MyMatches>(context);
    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();
    final matchId = selectedMyMatch.id;

    final myClubsProvider = Provider.of<MyClubs>(context);
    final clubId = myClubsProvider.getActiveClub().id;

    final playerMatchesStatisticsProvider =
        Provider.of<PlayerMatchesStatistics>(context);

    final timetablesProvider = Provider.of<Timetables>(context);
    final timetableId = timetablesProvider.getSelectedTimetable().id;

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

    showAlertDialog(BuildContext context, String message) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Uwaga!"),
        content: Text(message),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    onSubmit() async {
      var isValid = _form.currentState.validate();
      _form.currentState.save();
      var sumOfOurGoals = 0;
      var sumOfOponnentGoals = 0;
      for (var i = 0; i < playerMatchesStatistics.length; i++) {
        sumOfOurGoals += playerMatchesStatistics[i].goals;
        sumOfOponnentGoals += playerMatchesStatistics[i].goalsConceded;
      }

      if (sumOfOurGoals != selectedMyMatch.ourGoals) {
        isValid = false;
        showAlertDialog(context,
            'Ilość strzelonych goli przez graczy musi zgadzać się ze stanem faktycznym!');
      }

      if (sumOfOponnentGoals != selectedMyMatch.opponentGoals) {
        isValid = false;
        showAlertDialog(context,
            'Ilość straconych goli przez graczy musi zgadzać się ze stanem faktycznym!');
      }

      if (!isValid) {
        return;
      }

      _isLoading = true;

      for (var p in playerMatchesStatistics) {
        await playerMatchesStatisticsProvider.addPlayerMatchStatistics(
          p,
          clubId,
          timetableId,
          matchId,
          p.playerId,
        );
      }

      await myMatchesProvider.checkIfPlayersWereRated(
          clubId, timetableId, matchId);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oceń zawodników'),
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Card(
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Bramkarz:',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...goalkeepers
                            .map(
                              (p) => Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${p.name} ${p.surname}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    RatingBar(
                                      initialRating: playerMatchesStatistics
                                          .firstWhere((g) => p.id == g.playerId)
                                          .rating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        playerMatchesStatistics
                                            .firstWhere(
                                                (g) => p.id == g.playerId)
                                            .rating = rating;
                                      },
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      onSaved: (value) {
                                        playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .goalsConceded =
                                            value.isNotEmpty
                                                ? int.parse(value)
                                                : 0;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.remove),
                                          labelText: 'Stracone gole'),
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      onSaved: (value) => {
                                        playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .goals =
                                            value.isNotEmpty
                                                ? int.parse(value)
                                                : 0
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.add),
                                          labelText: 'Strzelone gole'),
                                    ),
                                    CheckboxListTile(
                                      title: const Text('Kontuzja'),
                                      value: playerMatchesStatistics
                                          .firstWhere((g) => p.id == g.playerId)
                                          .isInjured,
                                      onChanged: (bool value) {
                                        setState(() {
                                          playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .isInjured = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        Center(
                          child: Text(
                            'Obrońcy:',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...defenders
                            .asMap()
                            .map((i, p) => MapEntry(
                                  i,
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${p.name} ${p.surname}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        RatingBar(
                                          initialRating: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .rating = rating;
                                          },
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onSaved: (value) => {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .goals = value
                                                    .isNotEmpty
                                                ? int.parse(value)
                                                : 0
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.add),
                                              labelText: 'Strzelone gole'),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Kontuzja'),
                                          value: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .isInjured,
                                          onChanged: (bool value) {
                                            setState(() {
                                              playerMatchesStatistics
                                                  .firstWhere(
                                                      (g) => p.id == g.playerId)
                                                  .isInjured = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                        Center(
                          child: Text(
                            'Pomocnicy:',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...midfielders
                            .asMap()
                            .map((i, p) => MapEntry(
                                  i,
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${p.name} ${p.surname}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        RatingBar(
                                          initialRating: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .rating = rating;
                                          },
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onSaved: (value) => {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .goals = value
                                                    .isNotEmpty
                                                ? int.parse(value)
                                                : 0
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.add),
                                              labelText: 'Strzelone gole'),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Kontuzja'),
                                          value: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .isInjured,
                                          onChanged: (bool value) {
                                            setState(() {
                                              playerMatchesStatistics
                                                  .firstWhere(
                                                      (g) => p.id == g.playerId)
                                                  .isInjured = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                        Center(
                          child: Text(
                            'Napastnicy:',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...strikers
                            .asMap()
                            .map((i, p) => MapEntry(
                                  i,
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${p.name} ${p.surname}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        RatingBar(
                                          initialRating: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .rating = rating;
                                          },
                                        ),
                                        TextFormField(
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onSaved: (value) => {
                                            playerMatchesStatistics
                                                .firstWhere(
                                                    (g) => p.id == g.playerId)
                                                .goals = value
                                                    .isNotEmpty
                                                ? int.parse(value)
                                                : 0
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.add),
                                              labelText: 'Strzelone gole'),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Kontuzja'),
                                          value: playerMatchesStatistics
                                              .firstWhere(
                                                  (g) => p.id == g.playerId)
                                              .isInjured,
                                          onChanged: (bool value) {
                                            setState(() {
                                              playerMatchesStatistics
                                                  .firstWhere(
                                                      (g) => p.id == g.playerId)
                                                  .isInjured = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
