import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initialiseDatabase() async {
  String path = join(await getDatabasesPath(), 'multitools.db');
  return openDatabase(
    path,
    version: 2,
    onCreate: (Database db , int version) async {
        await db.execute(
            '''
            CREATE TABLE "ChoreTracker_main"(
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
      //On gère les mise à jour future
    onUpgrade: (Database db ,int oldVersion , int newVersion) async {
      /*
      Par exemple :
      Le Scénario est le suivant :
      Tu as sorti la V1 de ton application. Des utilisateurs l'utilisent.
      Tu te rends compte qu'il te manque une information essentielle pour tes transactions :
      la date à laquelle elles ont été effectuées.
      Tu veux donc ajouter une colonne date à ta table Transaction_main.

      D'abord on remplace la version du open en 2
      ensuite on reviens ici et :

      if (oldVersion<2) {
        await db.execute(
          '''
          ALTER TABLE Transaction_main ADD COLUMN date TEXT DEFAULT CURRENT_TIMESTAMP;
          '''
        );
      }
      }
       */
      if (oldVersion<2){
        db.execute(
          '''
          ALTER TABLE Calculatrice_main RENAME TO ChoreTracker_main;
          '''
        );
      }
    }
  );
}