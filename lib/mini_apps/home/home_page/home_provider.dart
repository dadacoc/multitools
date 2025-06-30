import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug
);

class HomeProvider extends ChangeNotifier{

  late Database database;

  List<Map<String,dynamic>> fakedatabase = [];

  List<Map<String,dynamic>?> shortcuts = [];

  HomeProvider({required this.database}){
    loadData();
  }

  ///Base de données de catalogue pour dev
  final List<Map<String, dynamic>> allMiniApps = [
    {'id':0,'name': 'Suivi Tâches', 'icon': Icons.cleaning_services, 'navigation':'chore-tracker','keywords':['calcul','tache','finance','argent']},
    {'id':1,'name': 'Transactions', 'icon': Icons.receipt_long,'navigation':'transaction','keywords':['finance','argent','money','emprunt','pret']},
    {'id':2,'name': 'To-Do List', 'icon': Icons.check_box_outlined,'navigation': 'todo-list','keywords':['planning','tache','rappel']},
    {'id':3,'name': 'Épargne', 'icon': Icons.savings_outlined,'navigation':'epargne','keywords':['finance','argent','money','gestion']},
    {'id':4,'name': 'Chronomètre', 'icon': Icons.timer_outlined,'navigation':'chronomètre','keywords':['temps', 'course', 'timer', 'montre', 'stopwatch']},
  ];


  void loadData(){
    ///Faux retour de database home les shortcuts id sont la référence vers l'id des apps de catalogue
    fakedatabase = [
      {'numero':1,'shortcuts_id':1},
      {'numero':2,'shortcuts_id':0},
      {'numero':3,'shortcuts_id':3},
      {'numero':4,'shortcuts_id':null},
      {'numero':5,'shortcuts_id':null},
      {'numero':6,'shortcuts_id':null},
    ];

    //Pour quand on aura la database , il faudra faire un join dans le but d'obtenir ce qui s'associe avec les shortcuts id
    //On imagine que l'on obtient ça supposé order by numero:
    shortcuts = [
      {'name': 'Suivi Tâches', 'icon': Icons.cleaning_services, 'navigation':'chore-tracker','keywords':['calcul','tache','finance','argent']},
      {'name': 'To-Do List', 'icon': Icons.check_box_outlined,'navigation': 'todo-list','keywords':['planning','tache','rappel']},
      {'name': 'Transactions', 'icon': Icons.receipt_long,'navigation':'transaction','keywords':['finance','argent','money','emprunt','pret']},
      null,
      null
    ];
  }



  void onSelectShortCut(Map<String,dynamic> miniApp, int index){
    fakedatabase[index] = {'numero':index,'shortcuts_id':miniApp['id']};
    shortcuts[index] = miniApp;
    notifyListeners();
  }

}