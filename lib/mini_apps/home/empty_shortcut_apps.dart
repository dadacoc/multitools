import 'package:flutter/material.dart';

import '../../app_sizes.dart';

class EmptyShortcutTitle extends StatefulWidget {
  const EmptyShortcutTitle({super.key});

  @override
  State<EmptyShortcutTitle> createState() => _EmptyShortcutTitleState();
}

class _EmptyShortcutTitleState extends State<EmptyShortcutTitle> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
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
    return Container(
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
    );
  }
}
