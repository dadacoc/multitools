import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multitools/app_sizes.dart';

class ShortcutApps extends StatelessWidget {

  final Map<String, dynamic> miniApp;

  const ShortcutApps({super.key,required this.miniApp});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { context.pushNamed(miniApp['navigation']); },
      borderRadius: BorderRadius.circular(AppSizes.corners.m),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.corners.m),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Icon(miniApp['icon'],color: Theme.of(context).colorScheme.primary,size: AppSizes.icon.l,),
          SizedBox(height: AppSizes.gap.s,),
          Text(miniApp['name'],style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}

