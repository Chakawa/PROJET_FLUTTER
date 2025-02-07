import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String date;
  const EventCard({super.key, required this.title, required this.date});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:150,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          ListTile(
            title: Text("Evenement : ",style:TextStyle(fontSize: 16,color: Colors.black)),
            trailing: Text("${widget.title}",style:TextStyle(fontSize: 16,color: Colors.black)),
          ),
          ListTile(
            title: Text("Date : ",style:TextStyle(fontSize: 16,color: Colors.black)),
            trailing: Text("${widget.date}",style:TextStyle(fontSize: 16,color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
