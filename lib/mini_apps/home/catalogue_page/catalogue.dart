import 'package:flutter/material.dart';
import 'package:multitools/mini_apps/home/catalogue_page/catalogue_provider.dart';
import 'package:multitools/mini_apps/home/shortcut_apps.dart';
import 'package:provider/provider.dart';

import '../../../app_sizes.dart';


class Catalogue extends StatefulWidget {

  final bool isPickerMode;

  const Catalogue({super.key, required this.isPickerMode});

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {

  @override
  Widget build(BuildContext context) {

    final CatalogueProvider provider = context.watch<CatalogueProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text( widget.isPickerMode ? "Sélectionner une application" : "Catalogue"),
        automaticallyImplyLeading: widget.isPickerMode,
        backgroundColor: Colors.blue,
      ),
      body:Column(
        children: [
          SizedBox(height: AppSizes.gap.m,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding.l ,vertical: AppSizes.padding.m),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.corners.l)),
                hint: Text("Rechercher"),
                prefixIcon: Icon(Icons.search)
              ),
              onChanged: (research) => provider.filterApps(research),
            ),
          ),
          Expanded(
            child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.padding.l ,vertical: AppSizes.padding.m), //Ancienne valeur 24 et 20 , nouvelle 24 (l) et 16 (m) ,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160.0,
                      mainAxisSpacing: AppSizes.gap.m,
                      crossAxisSpacing: AppSizes.gap.m
                  ),
                  itemCount: provider.filteredApps.length,
                  itemBuilder: (BuildContext context , int index){
                    return ShortcutApps(miniApp: provider.filteredApps[index],isPickerMode: widget.isPickerMode,);
                  },
            ),
          ),
        ],
      ),
    );
  }
}
