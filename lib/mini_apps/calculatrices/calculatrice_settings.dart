import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

class CalculatriceSettings extends StatefulWidget {
  const CalculatriceSettings({super.key});

  @override
  State<CalculatriceSettings> createState() => _CalculatriceSettingsState();
}

class _CalculatriceSettingsState extends State<CalculatriceSettings> {

  List<Map<String,dynamic>> data = [];
  late Database database;
  bool isLoading = false;


  TextEditingController varArgentPlus = TextEditingController();


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
    List<Map<String,dynamic>> dataQuery = await database.query('Calculatrice_main');
    data = dataQuery;
    await updateVar();
  }

  Future<void> updateData(double argentPlus) async {
    await database.update(
        'Calculatrice_main',
        {
          'argent_plus' : argentPlus,
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
        varArgentPlus.text = (data[0]['argent_plus']).toString();
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
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              updateData(double.parse(varArgentPlus.text));
              context.pop();
            },
            icon: const Icon(Icons.done_all),
            color: Colors.black,
            tooltip: "Done",
          )
        ],
      ),
      body: Container(
          margin: const EdgeInsets.only(top:50),
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                      label: Text("Argent Plus :"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [
                    TextInputFormatter.withFunction(
                            (TextEditingValue oldValue , TextEditingValue newValue) {
                          return RegExp(r"^\d*\.?\d*$").hasMatch(newValue.text) ? newValue : oldValue;
                        }
                    )
                  ],
                  textAlign: TextAlign.center,
                  controller: varArgentPlus,
                  onChanged: (value){
                    if (value.isEmpty) {
                      varArgentPlus.text ='0.0';
                    }
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
