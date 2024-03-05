import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import '../models/journal_model.dart';

class DatabaseHelper {
  static const _databaseName = "NotesData.db";
  static const _databaseVersion = 1;

  static const table = 'journal_entries';

  static const columnId = '_id';
  static const title = 'title';
  static const body = 'body';
  static const rating = 'rating';
  static const date = 'date';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String createTableQuery = await getQueryFromAsset('schema.sql');
    await db.execute(createTableQuery);
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    final Database db = await database;

    String insertQuery = await getQueryFromAsset('insert.sql');
    await db.rawInsert(
        insertQuery, [data[title], data[body], data[rating], data[date]]);
  }

  Future<List<JournalEntry>> queryAllRows() async {
    Database db = await instance.database;
    String selectQuery = await getQueryFromAsset('selectAll.sql');

    var res = await db.rawQuery(selectQuery);
    List<JournalEntry> entries = res.map((row) {
      return JournalEntry(
        title: row['title'] as String? ?? '',
        body: row['body'] as String? ?? '',
        rating: row['rating'] as int? ?? 0,
        date: row['date'] as String? ?? '',
      );
    }).toList();
    return entries;
  }

  Future<String> getQueryFromAsset(String fileName) async {
    try {
      final contents = await rootBundle.loadString('assets/sql/$fileName');
      return contents;
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
  }

  Future<void> printAllRows() async {
    Database db = await instance.database;
    String selectQuery = await getQueryFromAsset('selectAll.sql');
    var res = await db.rawQuery(selectQuery);
    print('All rows:');
    res.forEach((row) => print(row));
  }

  Future<void> deleteAllRows() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $table');
  }
}
