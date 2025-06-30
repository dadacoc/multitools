import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:multitools/mini_apps/home/shortcut_apps.dart';

import '../../app_sizes.dart';


class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {

  ///Données de test
  final List<Map<String, dynamic>> allMiniApps = [
    {'name': 'Calculatrice', 'icon': Icons.calculate, 'navigation':'calculatrice'},
    {'name': 'Transactions', 'icon': Icons.receipt_long,'navigation':'transaction'},
    {'name': 'To-Do List', 'icon': Icons.check_box_outlined,'navigation': 'todo-list'},
    {'name': 'Épargne', 'icon': Icons.savings_outlined,'navigation':'epargne'},
    {'name': 'Chronomètre', 'icon': Icons.timer_outlined,'navigation':'chronomètre'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Catalogue"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body:GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding.l ,vertical: AppSizes.padding.m), //Ancienne valeur 24 et 20 , nouvelle 24 (l) et 16 (m) ,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160.0,
                mainAxisSpacing: AppSizes.gap.m,
                crossAxisSpacing: AppSizes.gap.m
            ),
            itemCount: allMiniApps.length,
            itemBuilder: (BuildContext context , int index){
              return ShortcutApps(miniApp: allMiniApps[index]);
            },
      ),
    );
  }
}
