import 'package:flutter/material.dart';
import '../views/view_entry.dart';

class JournalEntry extends StatelessWidget {
  final String title;
  final String body;
  final int rating;
  final String date;
  final Function()? onHoriTap;

  const JournalEntry({
    super.key,
    required this.title,
    required this.body,
    required this.rating,
    required this.date,
    this.onHoriTap,
  });

  // Getters
  String get getTitle => title;
  String get getBody => body;
  int get getRating => rating;
  String get getDate => date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Row(children: [
            Flexible(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ]),
          Row(
            children: [Flexible(child: Text(date))],
          )
        ],
      ),
      onTap: () {
        // Handle the tap action
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewEntry(title: title, body: body, date: date)));
      },
    );
  }

  // Convert a JournalEntry object into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'rating': rating,
      'date': date,
    };
  }
}
