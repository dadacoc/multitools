import 'package:flutter/material.dart';
import 'package:multitools/app_sizes.dart';
import 'package:multitools/mini_apps/home/home_page/clock_widget.dart';
import 'package:multitools/mini_apps/home/shortcuts/empty_shortcut_apps.dart';
import 'package:multitools/mini_apps/home/home_page/home_provider.dart';
import 'package:multitools/mini_apps/home/shortcuts/shortcut_home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    final HomeProvider provider = context.watch<HomeProvider>();

    if (provider.uiError != null && context.mounted ){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.uiError!)));
        provider.resetError();
      });
    }

    return GestureDetector(
        onTap: () async {
          if (provider.isInEditMode) {
            provider.toggleEditMode();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: provider.isInEditMode ? Text("Mode édition") : Text(
                "Home Page"),
            backgroundColor: Colors.blue,
          ),
          body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.padding.l, vertical: AppSizes.padding.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClockWidget(),
                  SizedBox(height: AppSizes.gap.xl,),
                  Text("MES RACCOURCIS", style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,),
                  AppDividers.standard,
                  Expanded(
                      child: GestureDetector(
                          onLongPress: () async {
                            provider.toggleEditMode();
                          },
                          child: GridView.builder(
                              itemCount: provider.shortcuts.length,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 160.0,
                                mainAxisSpacing: AppSizes.gap.m,
                                crossAxisSpacing: AppSizes.gap.m,
                              ),
                              itemBuilder: (BuildContext context, index) {
                                if (provider.shortcuts[index]['name'] == null) {
                                  return EmptyShortcutTitle(index: index);
                                } else {
                                  return ShortcutHome(
                                    miniApp: provider.shortcuts[index],
                                    index: index,);
                                }
                              }
                          )
                      )
                  )
                ],
              ),
            ),
        ),
    );
  }
}

/*
A la place de clock widget :
                  Text(horlogeFormat.format(_currentTime), style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.w300, color: Theme
                      .of(context)
                      .colorScheme
                      .onSurface)),
                  Text(jourFormat.format(_currentTime).toUpperCase(), style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Theme
                      .of(context)
                      .colorScheme
                      .onSurfaceVariant))
 */