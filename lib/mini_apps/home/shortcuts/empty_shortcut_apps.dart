import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multitools/mini_apps/home/home_page/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../app_sizes.dart';

class EmptyShortcutTitle extends StatefulWidget {

  final int index;

  const EmptyShortcutTitle({super.key,required this.index});

  @override
  State<EmptyShortcutTitle> createState() => _EmptyShortcutTitleState();
}

class _EmptyShortcutTitleState extends State<EmptyShortcutTitle> with SingleTickerProviderStateMixin {

  late HomeProvider provider;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    provider = context.read<HomeProvider>();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 1500));
    _opacityAnimation = Tween<double>(begin: 0.4,end:1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.corners.m),
      onTap: () async {
        final Map<String, dynamic>? miniApp = await context.pushNamed(
            'catalogue', extra: true) as Map<String, dynamic>?;
        if (miniApp != null && context.mounted) {
          await provider.onSelectShortcut(
              miniApp: miniApp, index: widget.index);
        }
      },
      child: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.corners.m)),
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Icon(
                Icons.add, color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: AppSizes.icon.xl,
              ),
            )
      ),
    );
  }
}
