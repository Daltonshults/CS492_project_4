import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import './views/FormPage.dart';
import './helpers/databaseHelper.dart';
import './models/journalModel.dart';

final DatabaseHelper dbHelper = DatabaseHelper.instance;
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isSwitched;
  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _loadSwitchPreferences().then((value) {
      setState(() {
        _isSwitched = value;
        _themeData = _isSwitched! ? darkTheme() : lightTheme();
      });
    });
  }

  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue[800],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSwitched == null) {
      return MaterialApp(home: Scaffold(body: CircularProgressIndicator()));
    }
    return MaterialApp(
      title: 'Journal App',
      theme: _themeData,
      home: MyHomePage(_isSwitched!),
    );
  }

  Future<bool> _loadSwitchPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }
}

class MyHomePage extends StatefulWidget {
  bool? _isSwitched;

  MyHomePage(this._isSwitched);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? _isSwitched;
  List<JournalEntry> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadSwitchPreferences().then((value) => setState(() {
          _isSwitched = value;
        }));
    dbHelper.queryAllRows().then((entries) {
      setState(() {
        _journalEntries = entries;
      });
    });
    dbHelper.printAllRows();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSwitched == null) {
      return CircularProgressIndicator();
    } else if (_journalEntries.isEmpty) {
      return Scaffold(
        appBar: _journalAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Icon(Icons.book,
                    size: MediaQuery.of(context).size.height * 0.4)),
            Center(child: Text("Journal"))
          ],
        ),
        floatingActionButton: newEntryRoute(context),
      );
    }
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      darkTheme: ThemeData(
        // Define the default brightness and colors for dark mode.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
      ),
      themeMode: _isSwitched! ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
          key: _scaffoldKey,
          appBar: _journalAppBar(),
          body: ListView.builder(
            itemCount: _journalEntries.length, // Example item count
            itemBuilder: (context, index) {
              final entry = _journalEntries[index];
              return entry;
            },
          ),
          endDrawer: _endDrawer(context),
          floatingActionButton: newEntryRoute(context)),
    );
  }

  FloatingActionButton newEntryRoute(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => NewPage(_isSwitched, onNewEntryAdded)),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      shape: CircleBorder(),
    );
  }

  AppBar _journalAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title: const Text(
        'Journal Entries',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openEndDrawer, // Call _openEndDrawer when pressed
        ),
      ],
    );
  }

  Drawer _endDrawer(BuildContext context) {
    return Drawer(
      elevation: 100,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: _drawerHeader(context),
          ),
          Row(
            children: [_darkModeLabel(), _darkModeSwitch()],
          )
        ],
      ),
    );
  }

  Expanded _darkModeLabel() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Dark Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  DrawerHeader _drawerHeader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DrawerHeader(
      padding: EdgeInsets.fromLTRB(
          width * 0.025, // Left
          height * 0.005, // Top
          width * 0.025, // Right
          0), // bottom
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        'Settings',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Switch _darkModeSwitch() {
    return Switch(
      value: _isSwitched ?? false,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
          _saveSwitchPreferences(value);
        });
      },
      activeColor: Colors.amber,
      activeTrackColor: Colors.amberAccent,
    );
  }

  Future<void> _saveSwitchPreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<bool> _loadSwitchPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }

  void onNewEntryAdded() {
    dbHelper.queryAllRows().then((entries) {
      setState(() {
        _journalEntries = entries;
      });
    });
  }
}
