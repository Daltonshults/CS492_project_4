import 'package:flutter/material.dart';
import 'package:project_4/helpers/database_helper.dart';
import 'package:project_4/models/journal_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewPage extends StatefulWidget {
  final bool? _theme;
  final Function onNewEntryAdded;

  const NewPage(this._theme, this.onNewEntryAdded, {super.key});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
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
          title: const Text(
            'New Page',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: MyJournalForm(
            onNewEntryAdded: widget.onNewEntryAdded,
          ),
        ),
      ),
    );
  }
}

class MyJournalForm extends StatefulWidget {
  final Function onNewEntryAdded;
  const MyJournalForm({super.key, required this.onNewEntryAdded});

  @override
  State<MyJournalForm> createState() => _MyJournalFormState();
}

class _MyJournalFormState extends State<MyJournalForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hPadding = height * 0.01;
    double wPadding = width * 0.05;

    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: journalForm(hPadding, wPadding, context),
      ),
    );
  }

  Form journalForm(double hPadding, double wPadding, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          titleField(hPadding),
          bodyField(hPadding),
          ratingField(hPadding),
          buttonRow(wPadding, context),
        ],
      ),
    );
  }

  Row buttonRow(double wPadding, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cancelButton(wPadding, context),
        submitButton(wPadding, context),
      ],
    );
  }

  Padding submitButton(double wPadding, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: wPadding, right: wPadding),
      child: Align(
        child: ElevatedButton(
          onPressed: () async {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState?.validate() == true) {
              // If the form is valid, display a Snackbar.
              JournalEntry entry = JournalEntry(
                  title: titleController.text,
                  body: bodyController.text,
                  rating: int.parse(ratingController.text),
                  date:
                      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()));

              final DatabaseHelper db = DatabaseHelper.instance;

              await db.insertData(entry.toMap()).then((_) {
                widget.onNewEntryAdded();
                setState(() {});
                Navigator.pop(context);
              });
            }
          },
          style:
              ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
          child: const Text('Submit'),
        ),
      ),
    );
  }

  Padding cancelButton(double wPadding, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: wPadding, right: wPadding),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
        child: const Text('Cancel'),
      ),
    );
  }

  Padding ratingField(double hPadding) {
    return Padding(
      padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
      child: TextFormField(
        controller: ratingController,
        decoration: decorations(),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) {
              return newValue;
            }
            final int potentialNewValue = int.parse(newValue.text);
            if (potentialNewValue >= 1 && potentialNewValue <= 4) {
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
    );
  }

  Padding bodyField(double hPadding) {
    return Padding(
      padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
      child: TextFormField(
        controller: bodyController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Body',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the body';
          }
          return null;
        },
      ),
    );
  }

  Padding titleField(double hPadding) {
    return Padding(
      padding: EdgeInsets.only(top: hPadding, bottom: hPadding),
      child: TextFormField(
        controller: titleController,
        decoration: const InputDecoration(
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
    );
  }

  InputDecoration decorations() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Rating (1-4)',
    );
  }
}
