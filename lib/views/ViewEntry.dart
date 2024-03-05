import 'package:flutter/material.dart';

class ViewEntry extends StatelessWidget {
  final String title;
  final String body;
  final String date;

  ViewEntry({
    Key? key,
    required this.title,
    required this.body,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          date,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: viewEntryBody(),
    );
  }

  Padding viewEntryBody() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24)),
              Text(body),
            ],
          ),
        ],
      ),
    );
  }
}
