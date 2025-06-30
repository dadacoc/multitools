import 'package:flutter/material.dart';
import 'package:multitools/string_extensions.dart';
import 'package:sqflite/sqflite.dart';

class CatalogueProvider extends ChangeNotifier {

  late Database database;

  CatalogueProvider({required this.database}){
    filteredApps = List.from(allMiniApps);
  }

  ///Données de test
  final List<Map<String, dynamic>> allMiniApps = [
    {'name': 'Suivi Tâches', 'icon': Icons.cleaning_services, 'navigation':'chore-tracker','keywords':['calcul','tache','finance','argent']},
    {'name': 'Transactions', 'icon': Icons.receipt_long,'navigation':'transaction','keywords':['finance','argent','money','emprunt','pret']},
    {'name': 'To-Do List', 'icon': Icons.check_box_outlined,'navigation': 'todo-list','keywords':['planning','tache','rappel']},
    {'name': 'Épargne', 'icon': Icons.savings_outlined,'navigation':'epargne','keywords':['finance','argent','money','gestion']},
    {'name': 'Chronomètre', 'icon': Icons.timer_outlined,'navigation':'chronomètre','keywords':['temps', 'course', 'timer', 'montre', 'stopwatch']},
  ];

  late List<Map<String, dynamic>> filteredApps;

  void filterApps(String research){
    filteredApps = allMiniApps.where((app) {
      final query = research.toLowerCase().trim().withoutDiacritics;
      final nameMatch = (app['name'].toLowerCase().trim()).contains(query);
      final keywords = (app['keywords'] as List<String>).join(' '); // On joint les mots-clés en une seule chaîne
      final keywordsMatch = (keywords.toLowerCase().withoutDiacritics).contains(query);
      return nameMatch || keywordsMatch;
    }).toList();
    notifyListeners();
  }



}