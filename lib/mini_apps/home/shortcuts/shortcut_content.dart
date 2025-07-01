import 'package:flutter/material.dart';
import 'package:multitools/app_sizes.dart';

class ShortcutContent extends StatelessWidget {

  final Map<String, dynamic> miniApp;

  const ShortcutContent({super.key,required this.miniApp});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        )
    );
  }
}

