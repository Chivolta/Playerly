import 'package:flutter/material.dart';
import '../providers/my_clubs.dart';
import '../providers/squads.dart';
import '../screens/add_squad_screen.dart';
import '../screens/show_squad_screen.dart';
import '../widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

class SquadsScreen extends StatefulWidget {
  static const routeName = '/squads';

  @override
  _SquadsScreenState createState() => _SquadsScreenState();
}

class _SquadsScreenState extends State<SquadsScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });

      final squadsProvider = Provider.of<Squads>(context);
      final myClubsProvider = Provider.of<MyClubs>(context);
      final activeClub = myClubsProvider.getActiveClub();

      squadsProvider.getAllSquadsFromClub(activeClub.id).then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = true;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final squadsProvider = Provider.of<Squads>(context);

    final squads = squadsProvider.items;

    void showSquad(context, squadId) {
      squadsProvider.setSelectedSquad(squadId);
      Navigator.of(context).pushNamed(ShowSquadScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Składy'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddSquadScreen.routeName),
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: squads.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: squads[i],
                  child: InkWell(
                    child: Card(
                      // elevation: 10,
                      margin: EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text((i + 1).toString()),
                            Text(squads[i].name),
                            Text(
                                '${squads[i].formation[1].toString()}-${squads[i].formation[2].toString()}-${squads[i].formation[3].toString()}')
                          ],
                        ),
                      ),
                    ),
                    onTap: () => {showSquad(context, squads[i].id)},
                    hoverColor: Colors.purple,
                    focusColor: Colors.purple,
                    splashColor: Colors.purple,
                  )),
            ),
    );
  }
}
