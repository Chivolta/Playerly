import 'package:flutter/material.dart';
import 'package:playerly/providers/my_clubs.dart';
import 'package:playerly/widgets/club_management_drawer.dart';
import 'package:provider/provider.dart';

class ClubManagementScreen extends StatelessWidget {
  static const routeName = '/club-management';

  @override
  Widget build(BuildContext context) {
    final myClubsProvider = Provider.of<MyClubs>(context);
    final clubId = ModalRoute.of(context).settings.arguments as String;

    if (clubId != null) {
      print(clubId);
      myClubsProvider.setActiveClub(clubId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Podsumowanie'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}
