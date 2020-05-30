import 'package:flutter/material.dart';
import 'package:playerly/widgets/club_management_drawer.dart';

class TimetableScreen extends StatelessWidget {
  static const routeName = '/timetable';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminarz'),
      ),
      drawer: ClubManagementDrawer(),
      body: Text('test'),
    );
  }
}
