import 'package:flutter/material.dart';
import 'package:wallpaper_manager/screens/Add/add_wallpaper_view.dart';
import 'package:wallpaper_manager/screens/Home/home_view.dart';
import 'package:wallpaper_manager/screens/Settings/settings_view.dart';

class NavBarAndPagesView extends StatefulWidget {
  const NavBarAndPagesView({super.key});

  @override
  State<NavBarAndPagesView> createState() => NavBarAndPagesViewState();
}

class NavBarAndPagesViewState extends State<NavBarAndPagesView> {
  int indexProvider = 1;

  final List<Widget> screens = [
    const AddWallpaperView(),
    const HomeView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      body: IndexedStack(
        index: indexProvider,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexProvider,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 20),
        type: BottomNavigationBarType.fixed, // This ensures all items are visible
        onTap: (index) {
          setState(() {
            indexProvider = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
