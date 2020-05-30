import 'package:flutter/material.dart';
import 'package:playerly/widgets/club_management_drawer.dart';

class SquadsScreen extends StatelessWidget {
  static const routeName = '/squads';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Składy'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}
