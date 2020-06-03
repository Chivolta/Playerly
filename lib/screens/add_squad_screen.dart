import 'package:flutter/material.dart';
import '../helpers/errors_text.dart';
import '../helpers/functions.dart';
import '../providers/my_clubs.dart';
import '../providers/player.dart';
import '../providers/players.dart';
import '../providers/squad.dart';
import '../providers/squads.dart';
import 'package:provider/provider.dart';

class AddSquadScreen extends StatefulWidget {
  static const routeName = '/add-squad';

  @override
  _AddSquadScreenState createState() => _AddSquadScreenState();
}

class _AddSquadScreenState extends State<AddSquadScreen> {
  final _form = GlobalKey<FormState>();
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final playersProvider = Provider.of<Players>(context);
      final clubsData = Provider.of<MyClubs>(context);
      playersProvider
          .getAllPlayerFromClub(clubsData.getActiveClub().id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
      super.didChangeDependencies();
    }
  }

  var newSquad = Squad(
    id: '',
    name: '',
    formation: Squad.formationList[0],
    playersId: ['', '', '', '', '', '', '', '', '', '', ''],
  );

  List<DropdownMenuItem<int>> formationList = [];

  List<DropdownMenuItem<int>> goalkeepersList = [];

  List<DropdownMenuItem<int>> defendersList = [];

  List<DropdownMenuItem<int>> midfieldersList = [];

  List<DropdownMenuItem<int>> strikersList = [];

  void loadFormationList() {
    formationList = [];
    formationList.add(new DropdownMenuItem(
      child: new Text("4-4-2"),
      value: 0,
    ));
    formationList.add(new DropdownMenuItem(
      child: new Text("3-5-2"),
      value: 1,
    ));
    formationList.add(new DropdownMenuItem(
      child: new Text("4-3-3"),
      value: 2,
    ));
  }

  void loadPlayersPositionList(goalkeepers, defenders, midfielders, strikers) {
    goalkeepersList = [];
    defendersList = [];
    midfieldersList = [];
    strikersList = [];

    for (var i = 0; i < goalkeepers.length; i++) {
      goalkeepersList.add(new DropdownMenuItem(
        child: new Text('${goalkeepers[i].name} ${goalkeepers[i].surname}'),
        value: i,
      ));
    }

    for (var i = 0; i < defenders.length; i++) {
      defendersList.add(new DropdownMenuItem(
        child: new Text('${defenders[i].name} ${defenders[i].surname}'),
        value: i,
      ));
    }

    for (var i = 0; i < midfielders.length; i++) {
      midfieldersList.add(new DropdownMenuItem(
        child: new Text('${midfielders[i].name} ${midfielders[i].surname}'),
        value: i,
      ));
    }

    for (var i = 0; i < strikers.length; i++) {
      strikersList.add(new DropdownMenuItem(
        child: new Text('${strikers[i].name} ${strikers[i].surname}'),
        value: i,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);

    final clubsData = Provider.of<MyClubs>(context);
    final squadsProvider = Provider.of<Squads>(context);

    final clubId = clubsData.getActiveClub().id;

    var goalkeepers = playersProvider.getGoalkeepersFromClub();
    var defenders = playersProvider.getDefendersFromClub();
    var midfielders = playersProvider.getMidfieldersFromClub();
    var strikers = playersProvider.getStrikersFromClub();

    loadFormationList();
    loadPlayersPositionList(goalkeepers, defenders, midfielders, strikers);

    // TODO: Better names of variables
    validatePlayer(int value, List<Player> players, int index) {
      if (value == null) {
        return ErrorsText.requiredPlayerError;
      }

      for (var i = 0; i < players.length; i++) {
        for (var j = 0; j < newSquad.playersId.length; j++) {
          if (j != index) {
            if (newSquad.playersId[j] == players[value].id) {
              return ErrorsText.duplicatePlayerError;
            }
          }
        }
      }

      return null;
    }

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      newSquad.id = Functions.generateId();
      squadsProvider
          .addSquad(newSquad, clubId)
          .then((value) => Navigator.of(context).pop());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowy skład'),
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Form(
                      key: _form,
                      child: Column(children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nazwa składu',
                            prefixIcon: const Icon(Icons.description),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => {newSquad.name = value},
                          validator: (value) => value.isNotEmpty
                              ? null
                              : ErrorsText.requiredErrorText,
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.fiber_manual_record),
                                labelText: 'Formacja'),
                            items: formationList,
                            value: 0,
                            onChanged: (value) {
                              setState(() {
                                newSquad.formation = Squad.formationList[value];
                              });
                            }),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                          child: Text(
                            'Skład:',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Bramkarz'),
                            items: goalkeepersList,
                            validator: (value) =>
                                validatePlayer(value, goalkeepers, 0),
                            onChanged: (value) {
                              newSquad.playersId[0] = goalkeepers[value].id;
                            }),
                        ...new List<Widget>.generate(
                            newSquad.formation[1],
                            (int index) => DropdownButtonFormField(
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: 'Obrońca'),
                                items: defendersList,
                                validator: (value) =>
                                    validatePlayer(value, defenders, 1 + index),
                                onChanged: (value) {
                                  newSquad.playersId[1 + index] =
                                      defenders[value].id;
                                })),
                        ...new List<Widget>.generate(
                          newSquad.formation[2],
                          (int index) => DropdownButtonFormField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Pomocnik'),
                            items: midfieldersList,
                            validator: (value) => validatePlayer(value,
                                midfielders, 1 + newSquad.formation[1] + index),
                            onChanged: (value) => {
                              newSquad.playersId[1 +
                                  newSquad.formation[1] +
                                  index] = midfielders[value].id
                            },
                          ),
                        ),
                        ...new List<Widget>.generate(
                            newSquad.formation[3],
                            (int index) => DropdownButtonFormField(
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: 'Napastnik'),
                                items: strikersList,
                                validator: (value) => validatePlayer(
                                    value,
                                    strikers,
                                    1 +
                                        newSquad.formation[1] +
                                        newSquad.formation[2] +
                                        index),
                                onChanged: (value) => {
                                      newSquad.playersId[1 +
                                          newSquad.formation[1] +
                                          newSquad.formation[2] +
                                          index] = strikers[value].id
                                    })),
                      ]))),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
