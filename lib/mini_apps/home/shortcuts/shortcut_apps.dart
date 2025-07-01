import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multitools/app_sizes.dart';
import 'package:multitools/mini_apps/home/shortcuts/shortcut_content.dart';

class ShortcutApps extends StatelessWidget {

  final Map<String, dynamic> miniApp;
  final bool isPickerMode;

  const ShortcutApps({super.key,required this.miniApp,required this.isPickerMode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isPickerMode ? context.pop(miniApp) : context.pushNamed(miniApp['navigation']);
      },
      borderRadius: BorderRadius.circular(AppSizes.corners.m),
      child: ShortcutContent(miniApp: miniApp,),
    );
  }
}

