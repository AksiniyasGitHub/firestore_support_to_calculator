import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'calculation_history.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'calculator.db');
    return await openDatabase(path, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE calculations(id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result TEXT, timestamp INTEGER)",
      );
    }, version: 1);
  }

  Future<int> insertCalculation(CalculationHistory history) async {
    final db = await database;
    return await db.insert('calculations', history.toMap());
  }

  Future<List<CalculationHistory>> getCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calculations');
    return List.generate(maps.length, (i) {
      return CalculationHistory.fromMap(maps[i]);
    });
  }
}