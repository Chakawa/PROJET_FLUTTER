import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet1/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Paramètres",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section : Apparence
          const Text(
            "Apparence",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text(
                "Mode Sombre",
                style: TextStyle(fontSize: 16),
              ),
              value: themeProvider.themeMode == ThemeMode.dark, // État actuel
              onChanged: (value) {
                themeProvider.toggleTheme(value); // Bascule clair/sombre
              },
              activeColor: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),

          // Section : Notifications
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Gérer les notifications",
                style: TextStyle(fontSize: 16),
              ),
              leading:
                  const Icon(Icons.notifications, color: Colors.deepPurple),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Naviguer vers l'écran des paramètres de notifications
              },
            ),
          ),
          const SizedBox(height: 16),

          // Section : À propos
          const Text(
            "À propos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                "Version de l'application",
                style: TextStyle(fontSize: 16),
              ),
              subtitle: const Text(
                "1.0.0",
                style: TextStyle(fontSize: 14),
              ),
              leading: const Icon(Icons.info, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }
}
