import 'package:flutter/material.dart';
import 'package:pitch_league/screens/profile.dart';
import 'package:pitch_league/screens/teams.dart';
import 'package:pitch_league/screens/custom_menu_bar.dart';
import 'package:pitch_league/screens/explore.dart';
import 'package:pitch_league/screens/leagues.dart';
import 'package:pitch_league/screens/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _loadPage(int index) {
    // Menü öğesine tıklama işlemi
    switch (index) {
      case 1:
      // Takımlar sayfası seçildiyse, yüklemeyi tetikle
        (context.findAncestorStateOfType<TeamsScreenState>())?.loadTeams();
        break;
      case 2:
      // Ligler sayfası seçildiyse, yüklemeyi tetikle
        (context.findAncestorStateOfType<LeaguesScreenState>())?.loadLeagues();
        break;
      case 0:
      // Keşfet sayfası seçildiyse, yüklemeyi tetikle
        (context.findAncestorStateOfType<ExploreScreenState>())?.loadFields();
        break;
      case 3:
      // Profil sayfası seçildiyse, yüklemeyi tetikle
        (context.findAncestorStateOfType<ProfileScreenState>())?.loadUser();
        break;
    // Menü ekranı için veri güncelleme gerekli değilse, case eklemeye gerek yok
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pitch League'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ExploreScreen(onPageSelected: () => _loadPage(0)),
          TeamsScreen(onPageSelected: () => _loadPage(1)),
          LeaguesScreen(onPageSelected: () => _loadPage(2)),
          ProfileScreen(onPageSelected: () => _loadPage(3)),
          MenuScreen(),
        ],
      ),
      bottomNavigationBar: CustomMenuBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(index);
          _loadPage(index); // API çağrısını burada yapıyoruz
        },
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
