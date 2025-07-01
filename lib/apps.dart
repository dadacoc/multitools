import 'package:flutter/material.dart';

class Apps {

  static final List<Map<String, dynamic>> allMiniApps = [
    {'name': 'Suivi Tâches', 'icon': "cleaning_services", 'navigation':'chore-tracker','keywords':['calcul','tache','finance','argent']},
    {'name': 'Transactions', 'icon': "receipt_long",'navigation':'transaction','keywords':['finance','argent','money','emprunt','pret']},
    {'name': 'To-Do List', 'icon': "check_box_outlined",'navigation': 'todo-list','keywords':['planning','tache','rappel']},
  ];

  static final Map<String, IconData> _iconMap = {
    'cleaning_services': Icons.cleaning_services,
    'receipt_long': Icons.receipt_long,
    'check_box_outlined': Icons.check_box_outlined,
  };

  static final Map<IconData, String> _stringIconMap = {
    Icons.cleaning_services : 'cleaning_services' ,
    Icons.receipt_long : 'receipt_long',
    Icons.check_box_outlined : 'check_box_outlined',
  };

  // La fonction retourne maintenant un IconData?
  static IconData? stringToIcon(String iconName) {
    return _iconMap[iconName]; // Si la clé n'existe pas, retourne null automatiquement
  }

  static String? convertIconToString(IconData icon) {
    return _stringIconMap[icon];
  }
}
/* Documentation des apps et TODO

-Home

  La page d'accueil offrant un visuel du jour et de l'heure actuelle en permettant
  à l'utilisateur de selectionner des applications qu'il à mis en raccourcis

  TODO : -Ajouter une logique de raccourcis dynamique choisie par le user au travers de differente possibilité

-Catalogue :

  Offre un visuel de toutes les applications permettant à l'utilisateur de
  choisir celle qu'il veut

  TODO : -Ajouter une logique de catégories

-Suivie Tâches :

  Permet de comptabiliser l'argent gagner à mesure que l'on réalise des tâche
  (ici ménagères principalement) qui nous rapporte un même prix

  TODO : -Ajouter une logique pour faire plusieurs tâches de prix différent (une liste à créer)

-Transaction :

  Permet de suivre l'ensemble des emprunt donner ou demander par l'utilisateur

  TODO : -Un moyen de recherche ou de tri

-To Do list :

  Permet de suivre les objectifs de l'utilisateur (les tâche/ todos)

  TODO : -Offrir un moyen de tâche journalier et de recherche

 */