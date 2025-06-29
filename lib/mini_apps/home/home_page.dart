import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Navigation
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index){
      case 0:
        context.go('/');
        break;

      case 1:
        break;
    }
  }

  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        _currentTime = DateTime.now();
      });
    });
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
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/BoiteAOutils.jpg"),
            const Text("Bienvenue sur Multitools !",
              style: TextStyle(
                  fontSize: 24
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                onPressed: (){
                  context.go('/Calculatrice');
                },
                label: const Text("Entrer dans l'application !",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.green
                  ),
                ),
                icon: const Icon(Icons.launch , size: 24,color: Colors.green,),
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.apps), label: 'Catalogue')
          ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped ,
      )
    );
  }
}
