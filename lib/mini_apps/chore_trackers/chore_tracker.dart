import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

class ChoreTracker extends StatefulWidget {
  const ChoreTracker({super.key});

  @override
  State<ChoreTracker> createState() => _ChoreTrackerState();
}

class _ChoreTrackerState extends State<ChoreTracker> {

  //Data
  List<Map<String,dynamic>> data = [];
  late Database database;
  bool isLoading = false;


  TextEditingController varArgentPlus = TextEditingController();
  TextEditingController varArgent = TextEditingController();
  TextEditingController varNombreFois = TextEditingController();



  @override
  void initState() {
    super.initState();
    (() async {
      database = Provider.of<Database>(context, listen:false);
      await loadData();
    })();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String,dynamic>> dataQuery = await database.query('ChoreTracker_main');
    if (dataQuery.isEmpty){
      await database.insert(
        'ChoreTracker_main',{
          'argent' : 0.0,
          'argent_plus' : 0.0,
          'nombre_fois' : 0
      });
      dataQuery = await database.query('ChoreTracker_main');
    }
    data = dataQuery;
    await updateVar();
  }

  Future<void> updateData(double argent ,double argentPlus , int nombreFois) async {
    await database.update(
        'ChoreTracker_main',
        {
          'argent' : argent,
          'argent_plus' : argentPlus,
          'nombre_fois' : nombreFois
        },
        where: 'id = ?',
        whereArgs: [1]
    );
    await loadData();
  }

  Future<void> updateVar() async{
    int retryCount = 0;
    const maxRetries = 5;

    while (retryCount < maxRetries) {
      try {
        varArgent.text = ((data[0]['argent']) as double).toStringAsFixed(2);
        varArgentPlus.text = ((data[0]['argent_plus']) as double).toStringAsFixed(2);
        varNombreFois.text = (data[0]['nombre_fois']).toString();
        setState(() {
          isLoading = false;
        });
        break;
      } catch (e) {
        retryCount++;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    if (retryCount>=maxRetries) {
      setState(() {
        isLoading = false;
        data;
      });
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Echec de la mise à jour des données , veillez réessayer ultiérieurement'))
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
       title: const Text("Suivi Tâches"),
       backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                            await context.pushNamed<bool>("chore-tracker-settings");
                            loadData();
                        },
                        icon: const Icon(Icons.settings),
                        tooltip: "Settings",
                      )
                    ],
                  ),
                  Container(
                    width: 300,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.all(10),
                      child: TextField(
                          decoration: const InputDecoration(
                            label: Text('Valeur total :'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            suffix: Text("€"),
                          ),
                          style: const TextStyle(fontSize: 50),
                          readOnly: true,
                          textAlign: TextAlign.center,
                          controller: varArgent,

                      )
                  ),
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text("Nombre de fois"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      style: const TextStyle(),
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: varNombreFois,
                      onChanged: (value) async {
                        final valueAdd = int.tryParse(value) ?? 0;
                        double newValue = double.parse(varArgentPlus.text)*valueAdd;
                        newValue = double.parse(newValue.toStringAsFixed(2));
                        await updateData(newValue,double.parse(varArgentPlus.text),valueAdd);
                      },
                    )
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      double newValue = double.parse(varArgent.text) +double.parse(varArgentPlus.text);
                      newValue = double.parse(newValue.toStringAsFixed(2));
                      await updateData(newValue,double.parse(varArgentPlus.text),(int.parse(varNombreFois.text)+1));
                      },
                    child: const Text("Tache effectué"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await updateData(0,double.parse(varArgentPlus.text),0);
                      },
                      child: const Text("Reset")
                  )
              ]
            ),
          ),
          Visibility(
              visible: isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              )
          )
        ]
      ),
    );
  }
}


