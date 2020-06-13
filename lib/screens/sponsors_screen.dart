import '../widgets/club_management_drawer.dart';

import '../providers/sponsor.dart';

import '../providers/sponsors.dart';
import '../providers/my_clubs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SponsorsScreen extends StatefulWidget {
  static const routeName = '/sponsors';
  @override
  _SponsorsScreenState createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      setState(() {
        _isLoading = true;
      });
      final sponsorsProvider = Provider.of<Sponsors>(context);
      final clubsProvider = Provider.of<MyClubs>(context);
      var clubId = clubsProvider.getActiveClub().id;

      sponsorsProvider.getAllSponsors(clubId).then((_) {
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
    final sponsorsProvider = Provider.of<Sponsors>(context);
    List<Sponsor> sponsors = sponsorsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsorzy'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {},
          )
        ],
      ),
      drawer: ClubManagementDrawer(),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sponsors.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: sponsors[i],
                  child: InkWell(
                    child: Card(
                      // elevation: 10,
                      margin: const EdgeInsets.all(1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                '${(i + 1).toString()}. ${sponsors[i].name}, Przychody: \$${sponsors[i].revenue}'),
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
