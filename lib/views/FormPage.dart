import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

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
    return Theme(
      data: ThemeData(
        brightness: widget._theme! ? Brightness.dark : Brightness.light,
        primaryColor: widget._theme! ? Colors.lightBlue[800] : Colors.blue,
      ),
      child: Scaffold(
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
    double wPadding = width * 0.05;

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
                  labelText: 'Title',
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
                  labelText: 'Body',
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
                  labelText: 'Rating (1-4)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    final int potentialNewValue = int.parse(newValue.text);
                    if (potentialNewValue >= 1 && potentialNewValue <= 5) {
                      return newValue;
                    } else {
                      return oldValue;
                    }
                  }),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  } else {
                    final int potentialValue = int.parse(value);
                    if (potentialValue < 1 || potentialValue > 4) {
                      return 'Please enter a number between 1 and 5';
                    }
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: wPadding, right: wPadding),
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
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: wPadding, right: wPadding),
                  child: Align(
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
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
