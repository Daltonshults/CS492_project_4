import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// class NewPage extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   final bool? _theme;

//   NewPage(this._theme);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         title: Text(
//           'New Page',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Center(
//         child: Text('This is a new page'),
//       ),
//     );
//   }
// }

class NewPage extends StatefulWidget {
  final bool? _theme;

  NewPage(this._theme, {super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
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
        child: MyJournalForm(),
      ),
    );
  }
}

class MyJournalForm extends StatefulWidget {
  MyJournalForm({super.key});

  @override
  State<MyJournalForm> createState() => _MyJournalFormState();
}

class _MyJournalFormState extends State<MyJournalForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hPadding = height * 0.01;

    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            Padding(
              padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your first name',
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your last name',
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState?.validate() == true) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
