import 'package:MultiTools/Pages/Transaction/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final int id;
  final String nom;
  final double somme;
  final String cause;

  const EditTransaction({
    super.key,
    required this.id,
    required this.nom,
    required this.somme,
    required this.cause,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {


  late TextEditingController nomController;
  late TextEditingController sommeController;
  late TextEditingController causeController;
  late TextEditingController sommePartielleController;
  late TextEditingController sommeRestante;
  late int id;
  late String nom;
  late double somme;
  late String cause;

  bool isPartielEnabled = true;
  bool isTotalEnabled = true;

  final _formKey = GlobalKey<FormState>();


  late TransactionsProvider provider;





  @override
  void initState() {
    super.initState();
    // Utilisation des valeurs de `widget`
    id = widget.id;
    somme = widget.somme;
    cause = widget.cause;
    nom = widget.nom;

    nomController = TextEditingController(text: nom);
    sommeController = TextEditingController(text: somme.toString());
    causeController = TextEditingController(text: cause);
    sommePartielleController = TextEditingController();
    sommeRestante = TextEditingController(text: somme.toString());
    //Provider
    provider = Provider.of<TransactionsProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Libère les ressources des contrôleurs
    nomController.dispose();
    sommeController.dispose();
    causeController.dispose();
    sommePartielleController.dispose();
    sommeRestante.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier la transaction :"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Text("Informations générales",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),
                Text("Nom :"),
                SizedBox(height: 8,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: nomController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return "Entrer une valeur !";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text("Cause :"),
                SizedBox(height: 8,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: causeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return "Entrer une valeur !";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                const Text("Montants",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),
                Text("Somme totale (€) :"),
                SizedBox(height: 8,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: sommeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    onChanged: (value){
                      if (double.parse(value) != somme){
                        setState(() {
                          isPartielEnabled = false;
                          sommeRestante.text = value;
                        });
                      }else{
                        setState(() {
                          isPartielEnabled = true;
                          sommeRestante.text = value;
                        });
                      }

                    },

                    enabled: isTotalEnabled,
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
                SizedBox(height:16),
                Text("Somme données ou remboursée (€) :"),
                SizedBox(height: 8,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: sommePartielleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    enabled: isPartielEnabled,
                    onChanged: (value){
                      if (value != ""){
                        setState(() {
                          isTotalEnabled = false;
                          sommeRestante.text = (somme-double.parse(value)).toString();
                        });
                      }else {
                        setState(() {
                          isTotalEnabled = true;
                          sommeRestante.text = somme.toString();
                        });
                      }
                    },
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return null;
                      }else if(double.parse(value)>somme){
                        return "La valeur est selectionné est trop grande !";
                      }else if(double.parse(value)<0){
                        return "Entrer une valeur positive";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                  ),
                ),
                SizedBox(height:16),
                Text("Nouvelle somme restante (€) :"),
                SizedBox(height: 8,),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    readOnly: true,
                    controller: sommeRestante,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/Transaction'),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()){
                  provider.editData(id: id, nom: nomController.text, somme: double.parse(sommeRestante.text), cause: causeController.text);
                  context.go('/Transaction');
                }else {
                  print("Formulaire invalide");
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}

