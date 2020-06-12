import '../providers/squad.dart';

import '../providers/player_matches_statistics.dart';
import '../providers/players.dart';
import '../providers/squads.dart';
import '../providers/my_clubs.dart';
import '../providers/my_match.dart';
import '../providers/my_matches.dart';
import '../providers/timetables.dart';

import '../helpers/errors_text.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMyMatchScreen extends StatefulWidget {
  static const routeName = '/add-my-match';

  @override
  _AddMyMatchScreenState createState() => _AddMyMatchScreenState();
}

class _AddMyMatchScreenState extends State<AddMyMatchScreen> {
  final _form = GlobalKey<FormState>();
  final datetimeController = TextEditingController();
  var _isLoading = false;
  var _isInit = false;
  var _selectedSquad = 0;

  var newMyMatch = MyMatch(
    id: '',
    datetimeMatch: null,
    opponentGoals: null,
    opponentName: '',
    ourGoals: null,
    revenue: null,
    squadId: null,
    stadiumName: '',
  );

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
    final squadsProvider = Provider.of<Squads>(context);

    final myClubsProvider = Provider.of<MyClubs>(context);
    final activeClub = myClubsProvider.getActiveClub();
    final clubId = myClubsProvider.getActiveClub().id;

    final playerMatchesStatisticsProvider =
        Provider.of<PlayerMatchesStatistics>(context);

    final timetablesProvider = Provider.of<Timetables>(context);
    final selectedTimetable = timetablesProvider.getSelectedTimetable();

    final playersProvider = Provider.of<Players>(context);

    var squads = squadsProvider.items;

    showDateTimePicker(context) {
      DatePicker.showDateTimePicker(context,
          currentTime: DateTime.now(),
          minTime: DateTime.now().subtract(new Duration(days: 360)),
          maxTime: DateTime.now().add(
            new Duration(days: 360),
          )).then((value) {
        setState(() {
          datetimeController.text = value.toString();
          newMyMatch.datetimeMatch = value;
        });
      });
    }

    List<DropdownMenuItem<int>> squadsList = [];
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

    void loadSquadsList() {
      squadsList = [];

      for (var i = 0; i < squads.length; i++)
        squadsList.add(new DropdownMenuItem(
          child: new Text(squads[i].name),
          value: i,
        ));
    }

    bool checkIfAllPlayersFromSquadExists() {
      var playersIdList =
          squadsProvider.getSquadById(newMyMatch.squadId).playersId;
      for (var i = 0; i < playersIdList.length; i++) {
        if (playersProvider.getPlayerById(playersIdList[i]) == null) {
          return false;
        }
      }

      return true;
    }

    onSubmit() {
      var isValid = _form.currentState.validate();

      if (!checkIfAllPlayersFromSquadExists()) {
        isValid = false;
        showAlertDialog(context, 'Musisz miec 11 zawodników w składzie');
      }

      if (!isValid) {
        return;
      }

      _form.currentState.save();
      myMatchesProvider.addMatch(
          newMyMatch, activeClub.id, selectedTimetable.id);

      Navigator.of(context).pop();
    }

    createAutomateSquad() async {
      _isLoading = true;
      await playersProvider.getAllPlayerFromClub(clubId);

      var goalkeepersRatingList = [];
      var defendersRatingList = [];
      var midfieldersRatingList = [];
      var strikersRatingList = [];

      var goalkeepers = playersProvider.getGoalkeepersFromClub().where((p) {
        if (p.injuryTo != null) {
          if (p.injuryTo.compareTo(DateTime.parse(datetimeController.text)) <
              0) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      });

      if (goalkeepers.length < 1) {
        showAlertDialog(
            context, 'Potrzebujesz conajmniej 1 bramkarza bez kontuzji!');
        _isLoading = false;
        return;
      }

      var defenders = playersProvider.getDefendersFromClub().where((p) {
        if (p.injuryTo != null) {
          if (p.injuryTo.compareTo(DateTime.parse(datetimeController.text)) <
              0) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      });

      if (defenders.length < 4) {
        showAlertDialog(
            context, 'Potrzebujesz conajmniej 4 obrońców bez kontuzji!');
        _isLoading = false;
        return;
      }

      var midfielders = playersProvider.getMidfieldersFromClub().where((p) {
        if (p.injuryTo != null) {
          if (p.injuryTo.compareTo(DateTime.parse(datetimeController.text)) <
              0) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      });

      if (midfielders.length < 4) {
        showAlertDialog(
            context, 'Potrzebujesz conajmniej 4 pomocników bez kontuzji!');
        _isLoading = false;
        return;
      }

      var strikers = playersProvider.getStrikersFromClub().where((p) {
        if (p.injuryTo != null) {
          if (p.injuryTo.compareTo(DateTime.parse(datetimeController.text)) <
              0) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      });

      if (strikers.length < 2) {
        showAlertDialog(
            context, 'Potrzebujesz conajmniej 2 napastników bez kontuzji!');
        _isLoading = false;
        return;
      }

      for (var p in goalkeepers) {
        var rating = await playerMatchesStatisticsProvider
            .getAveragePlayerRating(clubId, p.id);
        goalkeepersRatingList.add({
          'playerId': p.id,
          'averageRating': rating.isNaN || rating == null ? 0 : rating
        });
      }

      for (var p in defenders) {
        var rating = await playerMatchesStatisticsProvider
            .getAveragePlayerRating(clubId, p.id);
        defendersRatingList.add({
          'playerId': p.id,
          'averageRating': rating.isNaN || rating == null ? 0 : rating
        });
      }

      for (var p in midfielders) {
        var rating = await playerMatchesStatisticsProvider
            .getAveragePlayerRating(clubId, p.id);
        midfieldersRatingList.add({
          'playerId': p.id,
          'averageRating': rating.isNaN || rating == null ? 0 : rating
        });
      }

      for (var p in strikers) {
        var rating = await playerMatchesStatisticsProvider
            .getAveragePlayerRating(clubId, p.id);
        strikersRatingList.add({
          'playerId': p.id,
          'averageRating': rating.isNaN || rating == null ? 0 : rating
        });
      }

      if (goalkeepersRatingList.length > 1) {
        goalkeepersRatingList
            .sort((b, a) => a['averageRating'].compareTo(b['averageRating']));
      }

      if (defendersRatingList.length > 1) {
        defendersRatingList
            .sort((b, a) => a['averageRating'].compareTo(b['averageRating']));
      }

      if (midfieldersRatingList.length > 1) {
        midfieldersRatingList
            .sort((b, a) => a['averageRating'].compareTo(b['averageRating']));
      }

      if (strikersRatingList.length > 1) {
        strikersRatingList
            .sort((b, a) => a['averageRating'].compareTo(b['averageRating']));
      }

      print(goalkeepersRatingList);
      print(defendersRatingList);
      print(midfieldersRatingList);
      print(strikersRatingList);

      Squad squad = Squad(
        id: '',
        name: 'Automatyczny sklad${UniqueKey()}',
        formation: [1, 4, 4, 2],
        playersId: [
          goalkeepersRatingList[0]['playerId'],
          defendersRatingList[0]['playerId'],
          defendersRatingList[1]['playerId'],
          defendersRatingList[2]['playerId'],
          defendersRatingList[3]['playerId'],
          midfieldersRatingList[0]['playerId'],
          midfieldersRatingList[1]['playerId'],
          midfieldersRatingList[2]['playerId'],
          midfieldersRatingList[3]['playerId'],
          strikersRatingList[0]['playerId'],
          strikersRatingList[1]['playerId'],
        ],
      );
      await squadsProvider.addSquad(squad, clubId);
      squads = squadsProvider.items;

      setState(() {
        loadSquadsList();
        newMyMatch.squadId = squads[_selectedSquad].id;
        _selectedSquad = squads.length - 1;
        _isLoading = false;
      });
    }

    loadSquadsList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowy mecz'),
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nazwa drużyny przeciwnej',
                      prefixIcon: Icon(Icons.directions_walk),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => {newMyMatch.opponentName = value},
                    validator: (value) =>
                        value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nazwa stadionu',
                      prefixIcon: Icon(Icons.place),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => {newMyMatch.stadiumName = value},
                    validator: (value) =>
                        value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Wybierz datę i czas rozpoczęcia meczu',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    controller: datetimeController,
                    onSaved: (value) =>
                        {newMyMatch.datetimeMatch = DateTime.parse(value)},
                    onTap: () => {showDateTimePicker(context)},
                    key: ObjectKey('xd'),
                    onChanged: (value) {
                      setState(() {
                        datetimeController.text = value;
                        newMyMatch.datetimeMatch = DateTime.parse(value);
                      });
                    },
                    validator: (value) =>
                        value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                  ),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.fiber_manual_record),
                          labelText: 'Wybierz skład'),
                      items: squadsList,
                      value: _selectedSquad,
                      onChanged: (value) {
                        newMyMatch.squadId = squads[value].id;
                      }),
                  datetimeController.text.isNotEmpty
                      ? RaisedButton(
                          child: Text("Stwórz automatycznie skład"),
                          color: Colors.orange,
                          onPressed: () => createAutomateSquad(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                'Jeśli chcesz utworzyć automatycznie skład, wprowadź datę meczu'),
                          ),
                        )
                ],
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
