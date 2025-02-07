import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/event_model.dart';
import '../functions/sqlite_functions.dart';
import '../widgets/text_form_widget.dart';

class Calendrier extends StatefulWidget {
  @override
  _CalendrierState createState() => _CalendrierState();
}

class _CalendrierState extends State<Calendrier> {
  late MeetingDataSource _calendarDataSource;
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool showMonth = true;
  DateTime _selectedDate = DateTime.now();
  CalendarController calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _calendarDataSource = MeetingDataSource(<Appointment>[]);
    _loadAppointmentsFromDatabase();
  }

  Future<void> _loadAppointmentsFromDatabase() async {
    final List<Reminder> maps = await databaseHelper.getReminders();
    final List<Appointment> appointments = maps.map((map) {
      return Appointment(
        id: map.id,
        subject: map.title,
        notes: map.description,
        startTime: map.date,
        endTime: map.date.add(Duration(hours: 1)),
        isAllDay: false,
      );
    }).toList();

    setState(() {
      _calendarDataSource = MeetingDataSource(appointments);
    });
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    calendarController.displayDate = newDate;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthToString(date.month)} ${date.year}";
  }

  String _monthToString(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDate(_selectedDate),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white)
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/'),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SfCalendar(
        key: UniqueKey(),
        controller: calendarController,
        view: showMonth ? CalendarView.month : CalendarView.day,
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.isNotEmpty) {
            _showEventDialog(context, calendarTapDetails.appointments!.first);
          } else {
            setState(() => showMonth = !showMonth);
          }
        },
        initialDisplayDate: _selectedDate,
        initialSelectedDate: _selectedDate,
        headerStyle: CalendarHeaderStyle(),
        viewHeaderHeight: 40,
        viewHeaderStyle: ViewHeaderStyle(),
        headerHeight: 0,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        dataSource: _calendarDataSource,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _addReminder(
      String title, String description, String lieu, DateTime date) async {
    await databaseHelper.insertReminder(Reminder(
      title: title,
      description: description,
      date: date,
      location: lieu,
      isCompleted: false,
    ));
    await _loadAppointmentsFromDatabase();
  }

  Future<void> _deleteReminder(int id) async {
    await databaseHelper.deleteReminder(id);
    await _loadAppointmentsFromDatabase();
  }

  void _showEventDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appointment.subject),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${appointment.notes ?? "Aucune description"}'),
              SizedBox(height: 10),
              Text('Date: ${appointment.startTime}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteReminder(appointment.id as int);
                Navigator.of(context).pop();
              },
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog(context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _eventController = TextEditingController();
    final TextEditingController _lieuController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un événement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormWidget(
                controller: _titleController,
                myText: 'Titre',
                minWidth: double.infinity,
              ),
              SizedBox(height: 10),
              TextFormWidget(
                controller: _eventController,
                myText: 'Description',
                minWidth: double.infinity,
              ),
              SizedBox(height: 10),
              TextFormWidget(
                controller: _lieuController,
                myText: 'Lieu',
                minWidth: double.infinity,
              ),
              SizedBox(height: 10),
              TextFormWidget(
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                ),
                myText: 'Date',
                enabled: false,
                minWidth: double.infinity,
              ),
              SizedBox(height: 10),
              Center(
                child: IconButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(140, 40),
                    maximumSize: Size(140, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _eventController.text.isNotEmpty &&
                    _lieuController.text.isNotEmpty) {
                  await _addReminder(
                    _titleController.text,
                    _eventController.text,
                    _lieuController.text,
                    _selectedDate,
                  );
                  Navigator.of(context).pop();
                }
              },
              child:
                  Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
