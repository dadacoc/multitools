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

  CatalogueProvider({required this.database});

  Future<void> loadData() async {
    try {
      allMiniApps = await database.query('Catalogue');
      notifyListeners();

    } catch (e,s) {
      logger.e("Une erreur est survenue lors du chargement des données dans le home",error: e,stackTrace: s);
      rethrow;
    }
  }

  late List<Map<String, dynamic>> filteredApps;

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



}