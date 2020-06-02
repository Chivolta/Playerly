import 'package:flutter/material.dart';
import '../helpers/errors_text.dart';
import '../helpers/functions.dart';
import '../providers/my_clubs.dart';
import '../providers/player.dart';
import '../providers/players.dart';
import 'package:provider/provider.dart';

class AddPlayerScreen extends StatelessWidget {
  static const routeName = '/add-player';

  final _form = GlobalKey<FormState>();

  var newPlayer = Player(
      id: '',
      name: '',
      surname: '',
      age: null,
      number: null,
      position: Position.Defender,
      salary: 0);

  List<DropdownMenuItem<int>> positionList = [];

  void loadPositionList() {
    positionList = [];
    positionList.add(new DropdownMenuItem(
      child: new Text("Bramkarz"),
      value: 0,
    ));
    positionList.add(new DropdownMenuItem(
      child: new Text('Obrońca'),
      value: 1,
    ));
    positionList.add(new DropdownMenuItem(
      child: new Text('Pomocnik'),
      value: 2,
    ));
    positionList.add(new DropdownMenuItem(
      child: new Text('Napastnik'),
      value: 3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);
    loadPositionList();
    final clubsData = Provider.of<MyClubs>(context);
    final clubId = clubsData.getActiveClub().id;

    onSubmit() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      newPlayer.id = Functions.generateId();
      playersProvider.addPlayer(newPlayer, clubId);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj nowy zawodnika'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Imię',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => {newPlayer.name = value},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nazwisko',
                    prefixIcon: Icon(Icons.description),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => {newPlayer.surname = value},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.exposure_plus_1),
                      labelText: 'Wiek'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => {newPlayer.age = int.parse(value)},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.fiber_manual_record),
                        labelText: 'Pozycja'),
                    items: positionList,
                    value: 1,
                    onChanged: (value) =>
                        {newPlayer.position = Position.values[value]}),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: 'Zarobki miesięczne'),
                  initialValue: newPlayer.salary.toString(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => {newPlayer.salary = double.parse(value)},
                  validator: (value) =>
                      value.isNotEmpty ? null : ErrorsText.requiredErrorText,
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onSubmit(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
