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
  @override
  void didChangeDependencies() {
    final playersProvider = Provider.of<Players>(context, listen: false);
    final clubsData = Provider.of<MyClubs>(context);
    playersProvider.getAllPlayerFromClub(clubsData.getActiveClub().id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final playersData = Provider.of<Players>(context);
    final clubsData = Provider.of<MyClubs>(context);
    List<Player> players = playersData.items;

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
