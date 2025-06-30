import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CatalogueProvider extends ChangeNotifier {

  late Database database;

  CatalogueProvider({required this.database}){
    filteredApps = List.from(allMiniApps);
  }

  ///Données de test
  final List<Map<String, dynamic>> allMiniApps = [
    {'name': 'Calculatrice', 'icon': Icons.calculate, 'navigation':'calculatrice'},
    {'name': 'Transactions', 'icon': Icons.receipt_long,'navigation':'transaction'},
    {'name': 'To-Do List', 'icon': Icons.check_box_outlined,'navigation': 'todo-list'},
    {'name': 'Épargne', 'icon': Icons.savings_outlined,'navigation':'epargne'},
    {'name': 'Chronomètre', 'icon': Icons.timer_outlined,'navigation':'chronomètre'},
  ];

  late List<Map<String, dynamic>> filteredApps;

  void filterApps(String research){
    filteredApps = allMiniApps.where((app) => (app['name'].toLowerCase().trim()).contains(research.toLowerCase().trim())).toList();
    notifyListeners();
  }



}