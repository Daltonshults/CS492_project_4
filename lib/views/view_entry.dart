import 'package:flutter/material.dart';

class ViewEntry extends StatelessWidget {
  final String title;
  final String body;
  final String date;

  const ViewEntry({
    super.key,
    required this.title,
    required this.body,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          date,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: viewEntryBody(),
    );
  }

  Padding viewEntryBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 24)),
              Text(body),
            ],
          ),
        ],
      ),
    );
  }
}
