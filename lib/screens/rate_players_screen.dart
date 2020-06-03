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

  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });

      final myClubsProvider = Provider.of<MyClubs>(context);
      final playersProvider = Provider.of<Players>(context);
      final clubId = myClubsProvider.getActiveClub().id;

      playersProvider.getAllPlayerFromClub(clubId).then((_) {
        setState(() {
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
    final myClubsProvider = Provider.of<MyClubs>(context);
    final squadsProvider = Provider.of<Squads>(context);
    final playersProvider = Provider.of<Players>(context);
    final timetablesProvider = Provider.of<Timetables>(context);

    List<PlayerMatchStatistics> playerMatchesStatistics = [];

    final playerMatchesStatisticsProvider =
        Provider.of<PlayerMatchesStatistics>(context);

    Squad getSelectedSquad(squadId) {
      return squadsProvider.getSquadById(squadId);
    }

    final selectedTimetable = timetablesProvider.getSelectedTimetable();
    final timetableId = selectedTimetable.id;

    final selectedClub = myClubsProvider.getActiveClub();
    final clubId = selectedClub.id;

    final selectedMyMatch = myMatchesProvider.getSelectedMyMatch();
    final matchId = selectedMyMatch.id;

    final playersFromClub = playersProvider.items;
    final List<Player> playersFormActiveSquad = [];

    Squad selectedSquad = getSelectedSquad(selectedMyMatch.squadId);

    for (var i = 0; i < playersFromClub.length; i++) {
      for (var j = 0; j < selectedSquad.playersId.length; j++) {
        if (playersFromClub[i].id == selectedSquad.playersId[j]) {
          playersFormActiveSquad.add(playersFromClub[i]);

          _isInjuredList.add(false);
          _ratingsList.add(0.0);

          playerMatchesStatistics.add(PlayerMatchStatistics(
              id: '',
              goals: 0,
              rating: 0.0,
              goalsConceded: 0,
              isInjured: false,
              playerId: playersFromClub[i].id));
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

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      _isLoading = true;

      for (var i = 0; i < playerMatchesStatistics.length; i++) {
        playerMatchesStatistics[i].isInjured = _isInjuredList[i];
        playerMatchesStatistics[i].rating = _ratingsList[i];

        playerMatchesStatisticsProvider
            .addPlayerMatchStatistics(
          playerMatchesStatistics[i],
          clubId,
          timetableId,
          matchId,
          playerMatchesStatistics[i].playerId,
        )
            .then((value) {
          if (playerMatchesStatistics[playerMatchesStatistics.length - 1]
                  .playerId ==
              playerMatchesStatistics[i].playerId) {
            myMatchesProvider
                .checkIfPlayersWereRated(clubId, timetableId, matchId)
                .then((value) => Navigator.of(context).pop());
          }
        });
      }
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
                                      initialRating: _ratingsList[0],
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
                                        _ratingsList[0] = rating;
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
                                        playerMatchesStatistics[0]
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
                                        playerMatchesStatistics[0].goals =
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
                                      value: _isInjuredList[0],
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isInjuredList[0] = value;
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
                                          initialRating: _ratingsList[
                                              goalkeepers.length + i],
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
                                            _ratingsList[goalkeepers.length +
                                                i] = rating;
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
                                            playerMatchesStatistics[
                                                        goalkeepers.length + i]
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
                                          value: _isInjuredList[
                                              goalkeepers.length + i],
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isInjuredList[
                                                      goalkeepers.length + i] =
                                                  value;
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
                                          initialRating: _ratingsList[
                                              goalkeepers.length +
                                                  defenders.length +
                                                  i],
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
                                            _ratingsList[goalkeepers.length +
                                                defenders.length +
                                                i] = rating;
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
                                            playerMatchesStatistics[
                                                        goalkeepers.length +
                                                            defenders.length +
                                                            i]
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
                                          value: _isInjuredList[
                                              goalkeepers.length +
                                                  defenders.length +
                                                  i],
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isInjuredList[
                                                  goalkeepers.length +
                                                      defenders.length +
                                                      i] = value;
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
                                          initialRating: _ratingsList[
                                              goalkeepers.length +
                                                  defenders.length +
                                                  midfielders.length +
                                                  i],
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
                                            _ratingsList[goalkeepers.length +
                                                defenders.length +
                                                midfielders.length +
                                                i] = rating;
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
                                            playerMatchesStatistics[
                                                        goalkeepers.length +
                                                            defenders.length +
                                                            midfielders.length +
                                                            i]
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
                                          value: _isInjuredList[
                                              goalkeepers.length +
                                                  defenders.length +
                                                  midfielders.length +
                                                  i],
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isInjuredList[
                                                  goalkeepers.length +
                                                      defenders.length +
                                                      midfielders.length +
                                                      i] = value;
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
