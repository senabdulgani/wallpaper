import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_manager/product/state/theme_provider.dart';
import 'package:wallpaper_manager/product/theme/app_colors.dart';
import 'package:wallpaper_manager/screens/navbar_and_pages_view.dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(prefs)),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    // Theme
    AppColors.isDark = context.read<ThemeProvider>().themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facelog',
      theme: AppColors().appTheme,
      darkTheme: AppColors().appTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      showPerformanceOverlay: false,
      home: const NavBarAndPagesView(),
    );
  }
}
