import 'package:flutter/material.dart';
import '../views/ViewEntry.dart';

class JournalEntry extends StatelessWidget {
  final String title;
  final String body;
  final int rating;
  final String date;

  const JournalEntry({
    Key? key,
    required this.title,
    required this.body,
    required this.rating,
    required this.date,
  }) : super(key: key);

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
                child:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
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
