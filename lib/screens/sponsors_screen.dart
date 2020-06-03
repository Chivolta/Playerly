import 'package:flutter/material.dart';

class SponsorsScreen extends StatefulWidget {
  static const routeName = '/sponsors';
  @override
  _SponsorsScreenState createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsorzy'),
      ),
    );
  }
}
