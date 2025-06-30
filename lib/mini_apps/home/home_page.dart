import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multitools/app_sizes.dart';
import 'package:multitools/mini_apps/home/empty_shortcut_apps.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Le temps

  late Timer _timer;
  late DateTime _currentTime;
  final String localLanguageUser = 'fr_FR'; //On note la langue du user en dure pour le premier dev

  late DateFormat jourFormat;
  late DateFormat horlogeFormat;


  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    jourFormat = DateFormat.yMMMMEEEEd(localLanguageUser);
    horlogeFormat  = DateFormat('HH:mm:ss',localLanguageUser);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.padding.l ,vertical: AppSizes.padding.m),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(horlogeFormat.format(_currentTime),style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w300,color: Theme.of(context).colorScheme.onSurface)),
              Text(jourFormat.format(_currentTime).toUpperCase(),style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: AppSizes.gap.xl,),
              Text("MES RACCOURCIS",style: Theme.of(context).textTheme.titleMedium,),
              AppDividers.standard,
              Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {

                      const int crossAxisCount = 2;
                      final double crossAxisSpacing = AppSizes.gap.m;
                      final double mainAxisSpacing = AppSizes.gap.m;

                      final double itemWidth = (constraints.maxWidth - crossAxisSpacing ) / crossAxisCount;

                      final int rowCount = ((constraints.maxHeight) / (itemWidth + mainAxisSpacing)).floor();

                      if (rowCount<=0) {
                        return const SizedBox.shrink();
                      }

                      final int dynamicItemCount = rowCount * crossAxisCount;

                      // Hauteur totale occupée par les espacements ENTRE les rangées.
                      // Pour 3 rangées, il y a 2 espacements, donc (3 - 1) * spacing.
                      final double totalSpacing = mainAxisSpacing * (rowCount - 1);
                      // Hauteur disponible pour les tuiles elles-mêmes.
                      final double availableHeightForItems = constraints.maxHeight - totalSpacing;
                      // Hauteur exacte que chaque tuile doit avoir pour remplir l'espace.
                      final double perfectItemHeight = availableHeightForItems / rowCount;

                      final double perfectAspectRatio = itemWidth / perfectItemHeight;

                      return GridView.builder(
                          itemCount: dynamicItemCount,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: crossAxisSpacing,
                              crossAxisSpacing: mainAxisSpacing,
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: perfectAspectRatio
                          ),
                          itemBuilder: (BuildContext context, index) {
                            return EmptyShortcutTitle();
                          }
                      );
                    })
              )
            ],
          ),
      ),
    );
  }
}
