import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initialisationDB() async {
  String path = join(await getDatabasesPath(), 'multitools.db');
  Database db = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db , int version) async {
        await db.execute(
            '''
            CREATE TABLE "Calculatrice_main"(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                argent REAL,
                argent_plus REAL,
                nombre_fois INTEGER
            );
            '''
        );
        await db.execute(
          '''
          CREATE TABLE "Transaction_main"(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            checked INTEGER DEFAULT 0,
            nom TEXT,
            somme REAL,
            cause TEXT
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE "ToDo_main"(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER,
            checked INTEGER DEFAULT 0,
            titre TEXT,
            note TEXT,
            FOREIGN KEY (category_id) REFERENCES ToDo_category(id)
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE "ToDo_category" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            checked INTEGER DEFAULT 0,
            color TEXT
          );
          '''
        );
    },
  );
  //On verifie si les tables existes tous :
    await _createdTableIfNotExist(db);
    return db;
}

Future<void> _createdTableIfNotExist(Database db) async {
  // Créez la table 'calculatrice' si elle n'existe pas
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS "Calculatrice_main"(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      argent REAL,
      argent_plus REAL,
      nombre_fois INTEGER
    );
    '''
  );
  await db.execute(
    '''
      CREATE TABLE IF NOT EXISTS "Transaction_main"(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        checked INTEGER DEFAULT 0,
        nom TEXT,
        somme REAL,
        cause TEXT
      );
    '''
  );
  await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS "ToDo_main"(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT,
          checked INTEGER DEFAULT 0,
          titre TEXT,
          note TEXT,
          FOREIGN KEY (category_id) REFERENCES ToDo_category(id)
        );
        '''
  );
  await db.execute(
      '''
          CREATE TABLE IF NOT EXISTS "ToDo_category" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            checked INTEGER DEFAULT 0,
            color TEXT
          );
          '''
  );
}