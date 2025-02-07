import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../functions/sqlite_functions.dart';
import '../models/event_model.dart';
import 'event_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final List<Reminder> _reminders = [];

  Future<void> _deleteEvent(int eventId) async {
    await databaseHelper.deleteReminder(eventId);
    loadEvent();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Événement supprimé avec succès !"),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> loadEvent() async {
    final List<Reminder> maps = await databaseHelper.getReminders();
    setState(() {
      _reminders.clear();
      _reminders.addAll(maps);
    });
  }

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.primary,
        elevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, color: colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text("EventEase",
                style: TextStyle(
                    color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: colorScheme.onPrimary,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: _reminders.isEmpty
          ? _buildEmptyState(colorScheme)
          : AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _reminders.length,
                itemBuilder: (context, index) =>
                    _buildEventCard(index, colorScheme),
              ),
            ),
      floatingActionButton: _buildFloatingActionButton(colorScheme),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note,
                size: 100, color: colorScheme.primary.withOpacity(0.7)),
            const SizedBox(height: 20),
            Text("Bienvenue sur EventEase",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary)),
            const SizedBox(height: 10),
            Text("Ajoutez votre premier événement pour commencer !",
                style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.7)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(int index, ColorScheme colorScheme) {
    final event = _reminders[index];
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        horizontalOffset: 50,
        child: FadeInAnimation(
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 35,
                backgroundColor: colorScheme.primaryContainer,
                child: const Icon(Icons.event, color: Colors.white, size: 35),
              ),
              title: Text(event.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description : ${event.description}"),
                  Text("Date : ${DateFormat.yMd().format(event.date)}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventFormScreen(event: event),
                        )),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEvent(event.id!),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          backgroundColor: colorScheme.primary,
          onPressed: () => Navigator.pushNamed(context, '/calendar'),
          child: const Icon(Icons.calendar_month),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventFormScreen(),
              )),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
