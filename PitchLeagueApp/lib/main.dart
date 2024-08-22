import 'package:flutter/material.dart';
import 'package:pitch_league/screens/games.dart';
import 'package:pitch_league/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/menu.dart';
import 'screens/explore.dart';
import 'screens/leagues.dart';
import 'screens/teams.dart';
import 'screens/profile.dart';

void main() {
  runApp(MyApp());  // TODO : maç detaylarında hangi takıma karşı oynandığı yazılacak!
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthCheck(),
        '/home': (context) => HomeScreen(),
        '/explore': (context) => ExploreScreen(onPageSelected: () {}),
        '/teams': (context) => TeamsScreen(onPageSelected: () {}),
        '/leagues': (context) => LeaguesScreen(onPageSelected: () {}),
        '/games':(context) => GamesScreen(onPageSelected: () {}),
        '/menu': (context) => MenuScreen(),
        '/profile': (context) => ProfileScreen(onPageSelected: () {}),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
  Future<bool> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null;
  }
}