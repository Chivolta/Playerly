import 'package:flutter/material.dart';
import 'package:playerly/providers/my_clubs.dart';
import 'package:playerly/providers/players.dart';
import 'package:playerly/screens/add_player_screen.dart';
import 'package:playerly/widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

class PlayersScreen extends StatelessWidget {
  static const routeName = '/players';

  @override
  Widget build(BuildContext context) {
    final playersData = Provider.of<Players>(context);
    final clubsData = Provider.of<MyClubs>(context);
    final players =
        playersData.getPlayerFromClubById(clubsData.getActiveClub().id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Zawodnicy'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlayerScreen.routeName),
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: players[i],
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
                      Text(players[i].name),
                      Text(players[i].surname),
                      Text(players[i].getPosition())
                    ],
                  ),
                ),
              ),
              onTap: () => {},
              hoverColor: Colors.purple,
              focusColor: Colors.purple,
              splashColor: Colors.purple,
            )),
      ),
    );
  }
}
