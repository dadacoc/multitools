import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:multitools/string_extensions.dart';
import 'package:sqflite/sqflite.dart';

Logger logger = Logger(
  level : kReleaseMode ? Level.off : Level.debug
);

class CatalogueProvider extends ChangeNotifier {

  late Database database;

  List<Map<String, dynamic>> allMiniApps = [];

  late List<Map<String, dynamic>> filteredApps;

  CatalogueProvider({required this.database}){
    loadData();
  }

  bool isLoading = false;
  String? uiError;

  Future<void> loadData() async {
    isLoading = true;
    uiError = null;
    notifyListeners();
    try {
      allMiniApps = await database.query('Catalogue');
      filteredApps = List.from(allMiniApps);

    } catch (e,s) {
      logger.e("Une erreur est survenue lors du chargement des données dans le home",error: e,stackTrace: s);
      uiError = "Une erreur est survenue lors du chargement des données dans le home" ;
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterApps(String research){
    filteredApps = allMiniApps.where((app) {
      final query = research.toLowerCase().trim().withoutDiacritics;
      final nameMatch = (app['name'].toLowerCase().trim()).contains(query);
      final keywords = app['keywords'] as String;
      final keywordsMatch = (keywords.toLowerCase().withoutDiacritics).contains(query);
      return nameMatch || keywordsMatch;
    }).toList();
    notifyListeners();
  }

  void resetError(){
    uiError = null;
  }




}