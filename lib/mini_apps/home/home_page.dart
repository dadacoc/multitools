import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
        centerTitle: true,
      ),
      body: Column(
          children: [
            Text(jourFormat.format(_currentTime),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            Text(horlogeFormat.format(_currentTime),style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
            const Text("Bienvenue sur Multitools !",
              style: TextStyle(
                  fontSize: 24
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                onPressed: (){
                  context.goNamed('calculatrice');
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
    );
  }
}
