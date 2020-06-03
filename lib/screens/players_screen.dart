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
      var clubId = clubsData.getActiveClub().id;

      playersProvider.getAllPlayerFromClub(clubId).then((_) {
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
    final playersData = Provider.of<Players>(context);
    List<Player> players = playersData.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zawodnicy'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlayerScreen.routeName),
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: players[i],
                  child: InkWell(
                    child: Card(
                      // elevation: 10,
                      margin: const EdgeInsets.all(1),
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
