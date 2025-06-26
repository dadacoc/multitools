import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class TransactionsProvider extends ChangeNotifier {

  //Controller
  late TextEditingController sommeTotalADonner;
  late TextEditingController sommeTotalARecevoir ;

  //Data

  List<Map<String,dynamic>> data = [];
  late Database database;
  List<Map<String,dynamic>> toGive = [];
  List<Map<String,dynamic>> toGet = [];

  TransactionsProvider(this.database);

  Future<void> loadData() async {
    data = await database.query('Transaction_main');
    await loadToGive();
    await loadToGet();
    await loadSommeTotal();

    notifyListeners();

  }

  Future<void> loadToGive() async {
    try {
      toGive = await database.query(
          'Transaction_main',
          where: 'category = ?',
          whereArgs: ['ToGive']
      );
    }catch (e){
      print("Une exception est lever : $e");
      toGive =[];
    }
  }

  Future<void> loadToGet() async {
    try {
      toGet = await database.query(
          'Transaction_main',
          where: 'category = ?',
          whereArgs: ['ToGet']
      );
    }catch (e) {
      print("Une exception est lever : $e");
      toGet =[];
    }
  }

  Future<void> loadSommeTotal() async {
    List<Map<String,dynamic>> getCheckGive = await database.query(
        'Transaction_main',
        where: 'category = ? AND checked = ?',
        whereArgs: ['ToGive', 1]
    );
    List<Map<String,dynamic>> getCheckGet = await database.query(
        'Transaction_main',
        where: 'category = ? AND checked = ?',
        whereArgs: ['ToGet', 1]
    );
    double totalGive = 0.0;
    double totalGet = 0.0;

    for (var item in getCheckGive){
      totalGive+= item['somme'];
    }

    for (var item in getCheckGet){
      totalGet+= item['somme'];
    }
    sommeTotalADonner = TextEditingController(text: totalGive.toStringAsFixed(2));
    sommeTotalARecevoir = TextEditingController(text: totalGet.toStringAsFixed(2));
  }

  Future<void> deleteData(bool value,int id,TextEditingController controller,double somme) async {
    try {
      await database.delete(
          'Transaction_main',
          where: 'id = ?',
          whereArgs: [id]
      );
      if (value){
        controller.text = (double.parse(controller.text) - somme).toStringAsFixed(2);
      }
    }catch (e){
      print("Une erreur est survenu : $e");
    }
    await loadData();
  }

  Future<void> updateStateCheck(bool value,int id) async {
    await database.update(
      'Transaction_main',
      {'checked': value ? 1 : 0}, // Convertit le booléen en 0/1
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSomme(bool? value,int id,TextEditingController controller , double somme) async{
    double value_controller = double.parse(controller.text);
    if (value==true){
      controller.text = (value_controller+somme).toStringAsFixed(2);
    }else {
      controller.text = (value_controller-somme).toStringAsFixed(2);
    }
    await updateStateCheck(value!, id);
    await loadData();

  }


  //Ajout :

  Future<void> addData({required String category,required double somme,required String nom, required String cause}) async {
    await database.insert(
        'Transaction_main',{
      'category' : category,
      'somme' : somme,
      'nom' : nom,
      'cause' : cause
    }
    );
    await loadData();
  }

  //Edit

  Future<void> editData({required int id , required String nom , required double somme,required String cause})async {
    await database.update(
      'Transaction_main',
      {
        'nom' : nom,
        'somme' : somme,
        'cause' : cause
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadData();
  }


}