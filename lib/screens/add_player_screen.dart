import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/errors_text.dart';
import '../helpers/functions.dart';
import '../providers/my_clubs.dart';
import '../providers/player.dart';
import '../providers/players.dart';
import 'package:provider/provider.dart';

class AddPlayerScreen extends StatefulWidget {
  static const routeName = '/add-player';

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _form = GlobalKey<FormState>();
  final _surnameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _salaryFocusNode = FocusNode();
  var _isLoading = false;

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
      _isLoading = true;
      print(clubId);
      playersProvider
          .addPlayer(newPlayer, clubId)
          .then((value) {})
          .then((value) => playersProvider.getAllPlayerFromClub(clubId))
          .then((value) {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowego zawodnika'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Imię',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_surnameFocusNode),
                      onSaved: (value) => {newPlayer.name = value},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nazwisko',
                        prefixIcon: Icon(Icons.description),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _surnameFocusNode,
                      keyboardType: TextInputType.text,
                      onSaved: (value) => {newPlayer.surname = value},
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_ageFocusNode),
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.exposure_plus_1),
                          labelText: 'Wiek'),
                      textInputAction: TextInputAction.next,
                      focusNode: _ageFocusNode,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_salaryFocusNode),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) => {newPlayer.age = int.parse(value)},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
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
                      focusNode: _salaryFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) =>
                          {newPlayer.salary = double.parse(value)},
                      validator: (value) => value.isNotEmpty
                          ? null
                          : ErrorsText.requiredErrorText,
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
