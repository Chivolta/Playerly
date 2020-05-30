import 'package:flutter/material.dart';
import 'package:playerly/providers/my_clubs.dart';
import 'package:provider/provider.dart';

import 'club_item.dart';

class ClubLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myClubsData = Provider.of<MyClubs>(context);
    final myClubs = myClubsData.items;

    return ListView.builder(
      itemCount: myClubs.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: myClubs[i],
        child: ClubItem(),
      ),
    );
  }
}
