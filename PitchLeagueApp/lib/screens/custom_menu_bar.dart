import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomMenuBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Takımlar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports),
          label: 'Ligler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: 'Maçlarım',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: 'Takımım',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          label: 'Chat',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      showUnselectedLabels: true,
      showSelectedLabels: true,
    );
  }
}
