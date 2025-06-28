import 'package:MultiTools/Pages/Transaction/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';



class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> with SingleTickerProviderStateMixin {

  //Route

  final int _selectedIndex = 1;

  void _onItemTapped(int index){
    switch (index) {
      case 0:
        context.go('/Calculatrice');
        break;
      case 1:
        context.go('/Transaction');
        break;
      case 2:
        context.go('/ToDoList');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Page non existante ou en production'))
        );
    }
  }

  //Alert Dialog

  Future<void> ShowText({nom,somme,cause,color}) async{
    Color colortype = Colors.black;

    switch (color){
      case "red":
        colortype = Colors.redAccent;
        break;
      case "green":
        colortype = Colors.greenAccent;
    }
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Afficher plus :"),
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(nom , style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 16),
                    Text("Somme : $somme €", style: TextStyle(color: colortype, fontWeight: FontWeight.bold,),maxLines: 1,overflow: TextOverflow.clip,),
                    SizedBox(height:16),
                    Text("Cause : $cause",style: TextStyle(fontStyle: FontStyle.italic),)
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer"))
            ],
          );
        }
    );
  }

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final provider = Provider.of<TransactionsProvider>(context, listen: false); // Pas besoin d'écouter ici
    provider.loadData(); // Charge les données une seule fois
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TransactionsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
        backgroundColor: Colors.blue ,
        automaticallyImplyLeading: false,
        bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.payment),text: "A donner",),
              Tab(icon: Icon(Icons.sell),text: "A recevoir",)
            ]
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  (provider.toGive.isEmpty)
                      ? const Center(
                    child: Text("Aucune données de transaction n'a été enregister"),
                  )
                      : Column(
                    children: [
                      SizedBox(height: 16,),
                      SizedBox(
                          height: 120,
                          child: TextField(
                            decoration: const InputDecoration(
                              label: Text('Somme total selectionner :'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              suffix: Text("€"),
                            ),
                            style: const TextStyle(fontSize: 50),
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: provider.sommeTotalADonner,

                          )
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 50),
                            itemCount: provider.toGive.length,
                            itemBuilder: (BuildContext context , int index) {
                                  final transaction = provider.toGive[index];
                                  final nom = transaction['nom'].toString();
                                  final somme = transaction['somme'].toString();
                                  final cause = transaction['cause'].toString();
                                  final id = transaction['id'].toString();
                                  final checked = transaction['checked']==1; //Remplace le 1 par true et inversement

                                  return Card(
                                    child: ListTile(
                                        leading:
                                        Checkbox(
                                          onChanged: (bool? value) async {
                                            await provider.updateSomme(value,int.parse(id),provider.sommeTotalADonner, double.parse(somme));
                                          },
                                          value: checked,
                                        ),
                                        title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(nom,style: const TextStyle(fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis,),
                                              Text("${(double.parse(somme)).toStringAsFixed(2)} €", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis,)
                                            ]
                                        ),
                                        subtitle: Text("Cause : $cause",style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),maxLines: 2, overflow: TextOverflow.ellipsis,),
                                        trailing: PopupMenuButton<String>(
                                            onSelected: (String choice) async {
                                              switch (choice) {
                                                case ('Afficher plus'):
                                                  await ShowText(nom: nom,somme: somme,cause: cause,color: "red");
                                                  break;
                                                case ('Delete'):
                                                  await provider.deleteData(checked,int.parse(id),provider.sommeTotalADonner,double.parse(somme));
                                                  break;
                                                case ('Edit'):
                                                  context.go('/Transaction/Edit',
                                                      extra : {
                                                        'id': int.parse(id),
                                                        'nom': nom,
                                                        'somme': double.parse(somme),
                                                        'cause': cause
                                                    }
                                                  );
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                              const PopupMenuItem(
                                                value: 'Afficher plus',
                                                child: Row(
                                                    children: [
                                                      Text('Afficher plus')
                                                    ]
                                                ),
                                              ),
                                              const PopupMenuDivider(),
                                              const PopupMenuItem(
                                                  value: 'Edit',
                                                  child: Row(
                                                    children: [
                                                      Text("Edit"),
                                                      SizedBox(width: 8,),
                                                      Icon(Icons.edit)
                                                    ],
                                                  )
                                              ),
                                              const PopupMenuDivider(),

                                              const PopupMenuItem(
                                                  value: 'Delete',
                                                  child: Row(
                                                      children: [
                                                        Text('Delete',style: TextStyle(color: Colors.redAccent),),
                                                        SizedBox(width: 8,),
                                                        Icon(Icons.delete,color: Colors.redAccent,)
                                                      ]
                                                  )
                                              ),
                                            ]
                                        )
                                    ),
                                  );
                            }
                        ),
                      ),
                    ],
                  ),
                  provider.toGet.isEmpty
                      ? const Center(
                    child: Text("Aucune données de transaction n'a été enregister"),
                  )
                      : Center(
                      child: Column(
                        children: [
                          SizedBox(height: 16,),
                          SizedBox(
                              height: 120,
                              child: TextField(
                                decoration: const InputDecoration(
                                  label: Text('Somme total selectionner :'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  suffix: Text("€"),
                                ),
                                style: const TextStyle(fontSize: 50),
                                readOnly: true,
                                textAlign: TextAlign.center,
                                controller: provider.sommeTotalARecevoir,
                              )
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 50),
                                itemCount: provider.toGet.length,
                                itemBuilder: (BuildContext context , int index) {
                                  final nom = provider.toGet[index]['nom'].toString();
                                  final somme = provider.toGet[index]['somme'].toString();
                                  final cause = provider.toGet[index]['cause'].toString();
                                  final id = provider.toGet[index]['id'].toString();
                                  final checked = provider.toGet[index]['checked']==1; //Remplace le 1 par true et inversement


                                  return Card(
                                    child: ListTile(
                                        leading:
                                        Checkbox(value: checked,
                                            onChanged: (bool? value) async {
                                              await provider.updateSomme(value,int.parse(id),provider.sommeTotalARecevoir, double.parse(somme));
                                            }
                                        ),
                                        title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(nom,style: const TextStyle(fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis,),
                                              Text("${(double.parse(somme)).toStringAsFixed(2)} €", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis,)
                                            ]
                                        ),
                                        subtitle: Text("Cause : $cause",style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),maxLines: 2, overflow: TextOverflow.ellipsis,),
                                        trailing: PopupMenuButton<String>(
                                            onSelected: (String choice) async {
                                              switch (choice) {
                                                case ('Afficher plus'):
                                                  await ShowText(nom: nom,somme: somme,cause: cause,color: "green");
                                                  break;
                                                case ('Delete'):
                                                  await provider.deleteData(checked,int.parse(id),provider.sommeTotalARecevoir,double.parse(somme));
                                                  break;
                                                case ('Edit'):
                                                  context.go('/Transaction/Edit',
                                                      extra : {
                                                        'id': int.parse(id),
                                                        'nom': nom,
                                                        'somme': double.parse(somme),
                                                        'cause': cause
                                                      }
                                                  );
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                              const PopupMenuItem(
                                                value: 'Afficher plus',
                                                child: Row(
                                                    children: [
                                                      Text('Afficher plus')
                                                    ]
                                                ),
                                              ),
                                              const PopupMenuDivider(),
                                              const PopupMenuItem(
                                                  value: 'Edit',
                                                  child: Row(
                                                    children: [
                                                      Text("Edit"),
                                                      SizedBox(width: 8,),
                                                      Icon(Icons.edit)
                                                    ],
                                                  )
                                              ),
                                              const PopupMenuDivider(),

                                              const PopupMenuItem(
                                                  value: 'Delete',
                                                  child: Row(
                                                      children: [
                                                        Text('Delete',style: TextStyle(color: Colors.redAccent),),
                                                        SizedBox(width: 8,),
                                                        Icon(Icons.delete,color: Colors.redAccent,)
                                                      ]
                                                  )
                                              ),
                                            ]
                                        )
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      )
                  ),
                ]
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          onPressed: () async {
            bool? add = await context.push('/Transaction/AddTransaction');
            if (add==true){
              provider.loadData();
            }
          },
          child: Icon(Icons.add),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(icon: Icon(Icons.calculate), label: "Calculatrice"),
          const NavigationDestination(icon: Icon(Icons.price_check), label: "Transaction"),
          const NavigationDestination(icon: Icon(Icons.check_box), label: "To-Do List"),
          const NavigationDestination(icon: Icon(Icons.dehaze_outlined), label: "Plus")
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}



