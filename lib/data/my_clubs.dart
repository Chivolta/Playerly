import 'package:playerly/providers/my_club.dart';

final List<MyClub> myClubsData = [
  MyClub(
    id: 'id1',
    name: 'Dobrzanka Dobra',
    owner: 'Jacek Kurek',
    reveneus: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expenses: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    sponsors: [Sponsor('Stolart', 0, 'fdsfds')],
    fortune: 2000,
    // playedMatches: 0,
    // matchedToPlayInCurrentSeason: 0,
    // nextMatch: "Real Madryt",
    // previousMatch: "Barcelona"
  ),
  MyClub(
    id: 'id2',
    name: 'Wisła Kraków',
    owner: 'Jacek Kurek',
    reveneus: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    expenses: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    sponsors: [Sponsor('Stolart', 0, 'dsdsdsd')],
    fortune: 1000,
    // playedMatches: 0,
    // matchedToPlayInCurrentSeason: 0,
    // nextMatch: "Real Madryt",
    // previousMatch: "Barcelona"
  )
];
