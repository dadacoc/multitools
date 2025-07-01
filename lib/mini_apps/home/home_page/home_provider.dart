import 'package:flutter/foundation.dart';
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

  late List<Map<String,dynamic>> shortcuts;

  HomeProvider({required this.database}){
    loadData();
  }

  List<Map<String, dynamic>> allMiniApps = [];


  Future<void> loadData() async {
    isLoading = true;
    uiError = null;
    notifyListeners();
    try {
      home = await database.query('Home');

      shortcuts = await database.rawQuery(
        '''
        SELECT Home.numero, Catalogue.name, Catalogue.navigation, Catalogue.icon
        FROM Home
        LEFT JOIN Catalogue ON Home.catalogue_id = Catalogue.id
        ORDER BY Home.numero ASC;
        '''
      );
      allMiniApps = await database.query('Catalogue');

      notifyListeners();

    } catch (e,s) {
      logger.e("Une erreur est survenue lors du chargement des données dans le home",error: e,stackTrace: s);
      uiError = "Une erreur est survenue lors du chargement des données dans le home";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSelectShortcut({required Map<String,dynamic> miniApp, required int index}) async {
    isLoading = true;
    uiError = null;
    notifyListeners();
    try {
      await database.update(
          'Home',
          {'catalogue_id': miniApp['id'],},
          where: 'numero = ?',
          whereArgs: [index]
      );
    } catch (e,s) {
      logger.e("Une erreur est survenue lors de la mise à jour du raccourcis",error: e,stackTrace: s);
      uiError = "Une erreur est survenue lors de la mise à jour du raccourci";
    }finally {
      await loadData();
    }

  }

  void toggleEditMode(){
    isInEditMode = !isInEditMode;
    notifyListeners();
  }

  Future<void> deleteShortcut({required int index}) async {
    isLoading = true;
    uiError = null;
    notifyListeners();
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
      logger.e("Une erreur est survenue lors de la suppression du raccourci",error: e,stackTrace: s);
      uiError = "Une erreur est survenue lors de la suppression du raccourci";
    } finally {
      await loadData();
    }
  }

  void resetError(){
    uiError = null;
  }

}