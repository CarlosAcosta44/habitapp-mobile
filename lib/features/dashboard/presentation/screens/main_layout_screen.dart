import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    if (index == 2) {
      // Future: Open 'Create Habit' modal or screen
      return;
    }
    
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Comunidad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 48, color: Theme.of(context).primaryColor),
            label: 'Añadir',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            label: 'Retos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
