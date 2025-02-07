import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../functions/sqlite_functions.dart';
import '../models/event_model.dart';
import 'event_form_screen.dart';

class HomeScreenDefault extends StatefulWidget {
  const HomeScreenDefault({super.key});

  @override
  State<HomeScreenDefault> createState() => _HomeScreenDefaultState();
}

class _HomeScreenDefaultState extends State<HomeScreenDefault> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final List<Map<String, String>> _events = [];
  final List<Reminder> _reminders = [];

  void _addEvent(Map<String, String> event) {
    setState(() {
      _events.add(event);
    });
  }

  Future<void> _deleteEvent(int index, int eventId) async {
    await databaseHelper.deleteReminder(eventId);
    setState(() {
      loadEvent();
    });

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
    loadEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.primary,
        elevation: 5,
        // ignore: deprecated_member_use
        shadowColor: colorScheme.primary.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, color: colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              "EventEase",
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: colorScheme.onPrimary,
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 100,
                      // ignore: deprecated_member_use
                      color: colorScheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Bienvenue sur EventEase",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Une plateforme moderne pour organiser, gérer et suivre tous vos événements sans effort.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ajoutez votre premier événement pour commencer !",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        // ignore: deprecated_member_use
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : AnimationLimiter(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundColor: colorScheme.primaryContainer,
                              child: const Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            title: Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description : ${event.description}",
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Localisation : ${event.location}",
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Date : ${DateFormat.yMd().format(event.date)}",
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventFormScreen(event: event),
                                        ));

                                    // final updatedEvent = await Navigator.push<
                                    //     Map<String, String>>(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         EventFormScreen(event: event),
                                    //   ),
                                    // );

                                    // if (updatedEvent != null) {
                                    //   setState(() {
                                    //     _events[index] = updatedEvent;
                                    //   });
                                    // }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteEvent(index, event.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            backgroundColor: colorScheme.primary,
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
            child: const Icon(Icons.calendar_month),
          ),
          FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () async {
              final newEvent = await Navigator.push<Map<String, String>>(
                context,
                MaterialPageRoute(
                    builder: (context) => const EventFormScreen()),
              );

              if (newEvent != null) {
                _addEvent(newEvent);
              }
            },
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
