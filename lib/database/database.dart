// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   int dbVersion = 1;
//   static Database? _database;

//   static final DatabaseHelper _singletonInstance = DatabaseHelper._internal();
//   DatabaseHelper._internal();

//   factory DatabaseHelper() {
//     return _singletonInstance;
//   }

//   //getter sa database
//   //mag check if naa nay database nga instance
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // Initialize Database
//   Future<Database> _initDatabase() async {
//     //// deleteDatabaseFile();
//     String path = join(await getDatabasesPath(), "database.db");
//     return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       -- CREATE TABLE IF NOT EXISTS users (
//       --  id INTEGER PRIMARY KEY AUTOINCREMENT,
//       --   name TEXT NOT NULL,
//       --   email TEXT NOT NULL UNIQUE,
//       --   password TEXT NOT NULL
//       -- );

//       CREATE TABLE gasolinahan(
//         id integer PRIMARY KEY AUTOINCREMENT,
//         gastType TEXT NOT NULL,
//         price REAL NOT NULL,
//         isRecent INTEGER NOT NULL DEFAULT 0,
//       )
//     ''');
//   }

//   Future<int> insertGasolinahan(Map<String, dynamic> row) async {
//     Database db = await database;
//     return await db.insert('gasolinahan', row);
//   }

//   Future<List<Map<String, dynamic>>> viewData() async {
//     Database db = await database;
//     return await db.query("victories");
//   }

//   Future<Map<String, dynamic>> viewSpecificData(int id) async {
//     Database db = await database;
//     List<Map<String, dynamic>> result = await db.query(
//       'gasolinahan',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     return result.isNotEmpty ? result.first : {};
//   }

//   Future<int> updatePrice(int id, Map<String, dynamic> row) async {
//     Database db = await database;
//     return await db.update(
//       'gasolinahan',
//       row,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
// }
