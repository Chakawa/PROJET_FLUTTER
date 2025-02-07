import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Détails de l'Événement",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Fonction de partage à ajouter plus tard
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de l'événement
              Text(
                "Nom de l'Événement",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Date et localisation de l'événement
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "2025-01-20",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.deepPurple.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Réunion virtuelle",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description de l'événement
              Text(
                "Description :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ceci est un exemple de description d'événement. Ajoutez plus de détails ici. Vous pouvez inclure des informations supplémentaires, des instructions ou des liens pertinents.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              // Bouton de retour avec animation et design plus moderne
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    "Retour",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
