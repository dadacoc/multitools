import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
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
    );
  }
}
