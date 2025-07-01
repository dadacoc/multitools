import 'package:multitools/apps.dart';
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
        await db.execute(
          '''
          CREATE TABLE "Home" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numero INTEGER,
            FOREIGN KEY (catalogue_id) REFERENCE Catalogue(id)
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE "Catalogue" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon TEXT,
            navigation TEXT,
            keywords TEXT
          );
          '''
        );

        //Ajout des données de base :

        final batch = db.batch(); //Permet de faire des groupe d'action (pour contacter la db une seul fois)

        for (int i = 1; i != 6 ; i++) {
          batch.insert('Home', {'numero': i, 'catalogue_id':null});
        }

        for (final app in Apps.allMiniApps) {
          batch.insert('Catalogue', {
           'name' :  app['name'],
            'navigation' : app['navigation'],
            'keywords' : (app['keywords'] as List<String>).join(',')
          });
        }
        await batch.commit(noResult: true);
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
        await db.execute(
          '''
          CREATE TABLE "Home" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numero INTEGER NOT NULL UNIQUE,
            FOREIGN KEY (catalogue_id) REFERENCES Catalogue(id)
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE "Catalogue" (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon TEXT,
            navigation TEXT,
            keywords TEXT
          );
          '''
        );

        //Ajout des données de base :

        final batch = db.batch(); //Permet de faire des groupe d'action (pour contacter la db une seul fois)

        for (int i = 1; i != 6 ; i++) {
          batch.insert('Home', {'numero': i, 'catalogue_id':null});
        }

        for (final app in Apps.allMiniApps) {
          batch.insert('Catalogue', {
            'name' :  app['name'],
            'navigation' : app['navigation'],
            'keywords' : (app['keywords'] as List<String>).join(',')
          });
        }
        await batch.commit(noResult: true);
      }
    }
  );
}