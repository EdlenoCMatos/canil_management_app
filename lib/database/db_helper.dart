import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'medicamentos.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE medicamentos(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, dosagem TEXT, intervalo TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertMedicamento(Map<String, dynamic> medicamento) async {
    final db = await DBHelper.database();
    await db.insert('medicamentos', medicamento, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getMedicamentos() async {
    final db = await DBHelper.database();
    return db.query('medicamentos');
  }
}
