import 'package:flutter/material.dart';
import 'package:pitch_league/screens/profile.dart';
import 'package:pitch_league/screens/teams.dart';
import 'package:pitch_league/screens/custom_menu_bar.dart';
import 'package:pitch_league/screens/explore.dart';
import 'package:pitch_league/screens/leagues.dart';
import 'package:pitch_league/screens/menu.dart';
import 'package:pitch_league/screens/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'games.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _loadPage(int index) {
    switch (index) {
      case 0:
        (context.findAncestorStateOfType<ExploreScreenState>())?.loadFields();
        break;
      case 1:
        (context.findAncestorStateOfType<TeamsScreenState>())?.loadTeams();
        break;
      case 2:
        (context.findAncestorStateOfType<LeaguesScreenState>())?.loadLeagues();
        break;
      case 3:
        (context.findAncestorStateOfType<GamesScreenState>())?.loadGames();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Pitch League'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menü'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profilim'),
              onTap: () {
                Navigator.pop(context); // Menü kapanır
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(onPageSelected: () {})), // Profil sayfasına yönlendirir
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Profilimi Güncelle'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfileScreen(onPageSelected: () {})), // Profil sayfasına yönlendirir
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
                // Ayarlar sayfasına yönlendirme kodu
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ExploreScreen(onPageSelected: () => _loadPage(0)),
          TeamsScreen(onPageSelected: () => _loadPage(1)),
          LeaguesScreen(onPageSelected: () => _loadPage(2)),
          GamesScreen(onPageSelected: () => _loadPage(3)),
        ],
      ),
      bottomNavigationBar: CustomMenuBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(index);
          _loadPage(index); // API çağrısını burada yapıyoruz
        },
        // Profil butonunu kaldırdık
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
