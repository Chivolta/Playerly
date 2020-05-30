import 'package:flutter/material.dart';
import 'package:playerly/providers/my_clubs.dart';
import 'package:playerly/providers/players.dart';
import 'package:playerly/providers/squads.dart';
import 'package:playerly/screens/add_squad_screen.dart';
import 'package:playerly/screens/show_squad_screen.dart';
import 'package:playerly/widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

class SquadsScreen extends StatelessWidget {
  static const routeName = '/squads';

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<Players>(context);
    final clubsProvider = Provider.of<MyClubs>(context);
    final squadsProvider = Provider.of<Squads>(context);

    void showSquad(context, squadId) {
      squadsProvider.setSelectedSquad(squadId);
      Navigator.of(context).pushNamed(ShowSquadScreen.routeName);
    }

    final squads = squadsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Składy'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddSquadScreen.routeName),
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: ListView.builder(
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
