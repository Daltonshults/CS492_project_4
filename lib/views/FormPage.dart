import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  bool? _theme;

  NewPage(this._theme);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'New Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('This is a new page'),
      ),
      backgroundColor: _theme! ? Colors.black : Colors.white,
    );
  }
}
