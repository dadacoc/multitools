import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multitools/app_sizes.dart';
import 'package:multitools/mini_apps/home/home_page/home_provider.dart';
import 'package:multitools/mini_apps/home/shortcuts/shortcut_content.dart';
import 'package:provider/provider.dart';

class ShortcutHome extends StatelessWidget {

  final Map<String, dynamic> miniApp;
  final int index;

  const ShortcutHome({super.key,required this.miniApp,required this.index});

  @override
  Widget build(BuildContext context) {

    void showSnack(String message){
      if (context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }

    HomeProvider provider = context.watch<HomeProvider>();

    return InkWell(
      onTap: () async {
        Map<String, dynamic>? miniAppPick;
        if (provider.isInEditMode) {

          miniAppPick = await context.pushNamed('catalogue',extra: true);
          if (miniAppPick != null && context.mounted){
            try {
              await provider.onSelectShortcut(miniApp: miniAppPick, index: index);
            } catch (e) {
              showSnack("Une erreur est survenue lors de la selection du raccourci");
            }
            try {
              await provider.loadData();
            }catch (e) {
              showSnack("Une erreur est survenu lors du raffrachissement des données, tentez de relancer la page");
            }

          }
        }else {
          context.pushNamed(miniApp['navigation']);
        }
      },
      borderRadius: BorderRadius.circular(AppSizes.corners.m),
      child: Stack(
          fit: StackFit.expand ,
          children: [
            ShortcutContent(miniApp: miniApp),
            if (provider.isInEditMode)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                onPressed: () async {
                  try {
                    await provider.deleteShortcut(index: index);
                  } catch (e) {
                    showSnack("Un problème est survenu lors de la suppression du raccourci");
                  }
                  try {
                    await provider.loadData();
                  }catch (e) {
                    showSnack("Une erreur est survenu lors du raffrachissement des données, tentez de relancer la page");
                  }
                },
                icon: Icon(Icons.cancel,size: AppSizes.icon.l,),padding: EdgeInsets.zero,constraints: BoxConstraints(),),
              )
          ]
      ),
    );
  }
}

