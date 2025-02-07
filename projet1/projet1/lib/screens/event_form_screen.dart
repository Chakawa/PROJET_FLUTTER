import 'package:flutter/material.dart';

import '../functions/sqlite_functions.dart';
import '../models/event_model.dart';

class EventFormScreen extends StatefulWidget {
  final Reminder? event; // Paramètre optionnel pour un événement existant

  const EventFormScreen({super.key, this.event});

  @override
  // ignore: library_private_types_in_public_api
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clé pour valider le formulaire
  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime _selectedDate = DateTime.now();
  bool loadingSave = false;

  @override
  void initState() {
    super.initState();

    // Si un événement est passé, pré-remplir les champs
    if (widget.event != null) {
      _titleController.text = widget.event?.title ?? '';
      _descriptionController.text = widget.event?.description ?? '';
      _locationController.text = widget.event?.location ?? '';
      _dateController.text = widget.event?.date.toIso8601String() ?? '';
    }
  }

  // Méthode pour ouvrir le calendrier
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}"
            .split(' ')[0]; // Formater la date (AAAA-MM-JJ)
      });
    }
  }

  Future<void> _addModifReminder(bool save, String title, String description,
      String lieu, DateTime date) async {
    save
        ? await databaseHelper.updateReminder(Reminder(
            id: widget.event?.id,
            title: title,
            description: description,
            date: date,
            location: lieu,
            isCompleted: false,
          ))
        : await databaseHelper.insertReminder(Reminder(
            title: title,
            description: description,
            date: date,
            location: lieu,
            isCompleted: false,
          ));
  }

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      // Créer un nouvel événement ou modifier l'existant
      setState(() {
        loadingSave = true;
      });

      _addModifReminder(widget.event != null, _titleController.text,
          _descriptionController.text, _locationController.text, _selectedDate);

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          loadingSave = false;
          Navigator.pushNamed(context, '/');
        });
      });
      // Retourner l'événement mis à jour
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.event == null ? 'Ajouter un événement' : 'Créer un événement',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Titre avec un icône
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  prefixIcon: Icon(Icons.title, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ Description avec un icône
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  prefixIcon: Icon(Icons.description, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ Localisation avec un icône
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localisation',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  prefixIcon: Icon(Icons.location_on, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La localisation est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ Date avec calendrier intégré
              GestureDetector(
                onTap: () =>
                    _selectDate(context), // Ouvrir le calendrier lors du clic
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Colors.deepPurple),
                      prefixIcon:
                          Icon(Icons.date_range, color: Colors.deepPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La date est requise';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton Sauvegarder stylisé
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Couleur du bouton
                  padding: const EdgeInsets.symmetric(
                      vertical: 18), // Padding du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Coins arrondis
                  ),
                  elevation: 10, // Ombre
                ),
                onPressed: _saveEvent,
                child: loadingSave
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Sauvegarder',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
