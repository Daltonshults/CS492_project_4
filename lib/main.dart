import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'views/form_page.dart';
import 'helpers/database_helper.dart';
import 'models/journal_model.dart';

final DatabaseHelper dbHelper = DatabaseHelper.instance;
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
      return const MaterialApp(
          home: Scaffold(body: CircularProgressIndicator()));
    } else {
      return MaterialApp(
        title: 'Journal App',
        theme: _themeData,
        home: const MyHomePage(),
      );
    }
  }

  Future<bool> _loadSwitchPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? _isSwitched;
  List<JournalEntry> _journalEntries = [];
  JournalEntry? selectedEntry;
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
    selectedEntry = null;
    dbHelper.printAllRows();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    if (_isSwitched == null) {
      return const CircularProgressIndicator();
    } else if (_journalEntries.isEmpty) {
      return Theme(
        data: _isSwitched! ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _journalAppBar("Welcome"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Icon(Icons.book,
                      size: MediaQuery.of(context).size.height * 0.4)),
              const Center(child: Text("Journal"))
            ],
          ),
          floatingActionButton: newEntryRoute(context),
          endDrawer: _endDrawer(context),
        ),
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
        home: screenWidth >= 800
            ? landscapeView(context)
            : portraitView(context));
  }

  Scaffold portraitView(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _journalAppBar("Journal Entries"),
        body: portraitListBuilder(),
        endDrawer: _endDrawer(context),
        floatingActionButton: newEntryRoute(context));
  }

  ListView portraitListBuilder() {
    return ListView.builder(
      itemCount: _journalEntries.length, // Example item count
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        return entry;
      },
    );
  }

  Widget landscapeView(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _journalAppBar("Journal Entries"),
      body: Row(
        children: [
          Expanded(
            // Add this
            child: landscapeListBuilder(),
          ),
          landscapeSummary(),
        ],
      ),
      endDrawer: _endDrawer(context),
      floatingActionButton: newEntryRoute(context),
    );
  }

  Expanded landscapeSummary() {
    return Expanded(
        child: selectedEntry != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedEntry!.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 26)),
                  Text(selectedEntry!.body,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ))
                ],
              )
            : const Text("No Entry Selected"));
  }

  ListView landscapeListBuilder() {
    return ListView.builder(
      itemCount: _journalEntries.length, // Example item count
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(entry.date)
              ],
            ),
            onTap: () {
              setState(() {
                selectedEntry = entry;
              });
            });
      },
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
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  AppBar _journalAppBar(String title) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: _openEndDrawer, // Call _openEndDrawer when pressed
        ),
      ],
    );
  }

  Drawer _endDrawer(BuildContext context) {
    return Drawer(
      elevation: 100,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.landscape
                ? MediaQuery.of(context).size.height *
                    0.2 // 20% of screen height in landscape mode
                : MediaQuery.of(context).size.height *
                    0.1, // 10% of screen height in portrait mode
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
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
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
      activeColor: Colors.blue,
      activeTrackColor: Colors.grey,
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
