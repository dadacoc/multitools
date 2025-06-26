import 'package:MultiTools/Pages/Transaction/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choix de l'ajout"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  bool? add = await context.push('/Transaction/A_donner');
                  if (add==true){
                    context.pop(true);
                  }
                },
                child: Text("A donner")
            ),
            ElevatedButton(
                onPressed: () async {
                  bool? add = await context.push('/Transaction/A_recevoir');
                  if (add==true){
                    context.pop(true);
                  }
                },
                child: Text("A recevoir")
            ),
          ],
        ),
      ),
    );
  }
}

class ADonner extends StatefulWidget {
  const ADonner({super.key});

  @override
  State<ADonner> createState() => _ADonnerState();
}

class _ADonnerState extends State<ADonner> {

  late TransactionsProvider provider;

  @override
  void initState() {
    super.initState();
    (() async {
      provider = Provider.of<TransactionsProvider>(context, listen: false);
    })();
  }

  @override
  void dispose() {
    super.dispose();
    nom.dispose();
    somme.dispose();
    cause.dispose();

  }

  Future<void> saveData({required TransactionsProvider provider,required double somme,required String nom,required String cause}) async {
    await provider.addData(category: 'ToGive', somme: somme, nom: nom, cause: cause);
  }
  //TextField a donner

  final _formKey =GlobalKey<FormState>();

  TextEditingController nom = TextEditingController();
  TextEditingController somme = TextEditingController();
  TextEditingController cause = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("A donner"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Nom"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: nom,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Somme"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: somme,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }else if(double.parse(value)<0){
                      return "Entrer une valeur positive !";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Cause"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: cause,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16,),
              IconButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      await saveData(provider: provider,somme: double.parse(somme.text),cause: cause.text,nom: nom.text);
                      context.pop(true);
                    }
                  },
                  icon: Icon(Icons.add_circle_outline)
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ARecevoir extends StatefulWidget {
  const ARecevoir({super.key});

  @override
  State<ARecevoir> createState() => _ARecevoirState();
}

class _ARecevoirState extends State<ARecevoir> {


  late TransactionsProvider provider;

  @override
  void initState() {
    super.initState();
    (() async {
      provider = Provider.of<TransactionsProvider>(context, listen: false);
    })();
  }

  @override
  void dispose() {
    super.dispose();
    nom.dispose();
    somme.dispose();
    cause.dispose();

  }

  //TextField a Recevoir

  Future<void> saveData({required TransactionsProvider provider,required double somme,required String nom,required String cause}) async {
    await provider.addData(category: 'ToGet', somme: somme, nom: nom, cause: cause);
  }

  final _formKey =GlobalKey<FormState>();

  TextEditingController nom = TextEditingController();
  TextEditingController somme = TextEditingController();
  TextEditingController cause = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("A recevoir"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Nom"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: nom,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Somme"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: somme,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }else if(double.parse(value)<0){
                      return "Entrer une valeur positive !";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                height: 60,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Cause"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: cause,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return "Entrer une valeur !";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16,),
              IconButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      await saveData(provider: provider,somme: double.parse(somme.text),cause: cause.text,nom: nom.text);
                      context.pop(true);
                    }
                  },
                  icon: Icon(Icons.add_circle_outline)
              ),
            ],
          ),
        ),
      ),
    );
  }
}