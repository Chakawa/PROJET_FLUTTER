import 'package:flutter/material.dart';
import 'package:projet1/screens/calendrier.dart';
import 'package:provider/provider.dart';
import 'package:projet1/screens/event_details_screen.dart';
import 'package:projet1/screens/event_form_screen.dart';
import 'package:projet1/screens/settings_screen.dart';
import 'package:projet1/theme_provider.dart';

import 'screens/home_screen_txt.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Fournisseur pour le thème global
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // État du thème

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventEase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode, // Mode thème basé sur ThemeProvider
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/calendar': (context) => Calendrier(),
        '/event-form': (context) => const EventFormScreen(),
        '/event-details': (context) => const EventDetailsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
