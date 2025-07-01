import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

//Logger

final Logger logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug
);
//Coquille (Shell route) de home

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    //Navigation

    int calculateSelectedIndex(){
      final String location = GoRouterState.of(context).matchedLocation;
      switch (location) {
        case '/':
          return 0;
        case '/catalogue':
          return 1;
        default: //Si aucun d'eux on met le home
          logger.e("Une erreur à eu lieu lors de la mise à jour de la navbar du home , la page est introuvable");
          return 0;
      }
    }

    void onItemTapped(int index) {
      switch (index){
        case 0:
          context.goNamed('home');
          break;

        case 1:
          context.goNamed('catalogue',extra: false);
          break;
      }
    }

    return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.apps), label: 'Catalogue')
          ],
          selectedIndex: calculateSelectedIndex(),
          onDestinationSelected: onItemTapped ,
        )
    );
  }
}