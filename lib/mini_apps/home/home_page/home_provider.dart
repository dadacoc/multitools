import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug
);

class HomeProvider extends ChangeNotifier{

  //EDIT
  bool isInEditMode = false;

  //Gestion de chargement et d'erreur

  bool isLoading = false;
  String? uiError;

  late Database database;

  List<Map<String,dynamic>> home = [];

  List<Map<String,dynamic>?> shortcuts = [];

  HomeProvider({required this.database});

  List<Map<String, dynamic>> allMiniApps = [];


  Future<void> loadData() async {
    try {
      home = await database.query('Home');

      shortcuts = await database.rawQuery(
        '''
        SELECT Home.numero AND name AND navigation AND icon
        FROM Catalogue
        JOIN Home ON Home.catalogue_id = Catalogue.id
        ORDER BY Home.numero ASC;
        '''
      );
      allMiniApps = await database.query('Catalogue');

      notifyListeners();

    } catch (e,s) {
      logger.e("Une erreur est survenue lors du chargement des données dans le home",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> onSelectShortcut({required Map<String,dynamic> miniApp, required int index}) async {
    try {
      await database.update(
          'Home',
          {'catalogue_id': miniApp['id'],},
          where: 'numero = ?',
          whereArgs: [index]
      );
    } catch (e,s) {
      logger.e("Une erreur est survenue lors de la mise à jour du raccourcis",error: e,stackTrace: s);
      rethrow;
    }

  }

  void toggleEditMode(){
    isInEditMode = !isInEditMode;
    notifyListeners();
  }

  Future<void> deleteShortcut({required int index}) async {
    try {
      await database.update(
        'Home',
        {
          'catalogue_id':null
        },
        where: 'numero = ?',
        whereArgs: [index]
      );
    } catch (e,s) {
      logger.e("Une erreur est survenue lors de la suppression du raccourcis",error: e,stackTrace: s);
      rethrow;
    }
  }

}