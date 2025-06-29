import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug
);

class TransactionsProvider extends ChangeNotifier {


  //Variable
  double totalToGive = 0.0;
  double totalToGet = 0.0;

  //Data

  List<Map<String,dynamic>> data = [];
  late Database database;
  List<Map<String,dynamic>> toGive = [];
  List<Map<String,dynamic>> toGet = [];

  TransactionsProvider(this.database);

  Future<void> loadData() async {
    try {
      data = await database.query('Transaction_main');
      await loadToGive();
      await loadToGet();
      await loadSommeTotal();
      notifyListeners();
    } catch (e){
      rethrow;
    }
  }

  Future<void> loadToGive() async {
    try {
      toGive = await database.query(
          'Transaction_main',
          where: 'category = ?',
          whereArgs: ['ToGive']
      );
    }catch (e,s) {
      logger.e(
          "Une erreur est survenue lors du chargement de 'ToGive",
          error: e,
          stackTrace: s
      );
      toGive =[];
      rethrow;
    }
  }

  Future<void> loadToGet() async {
    try {
      toGet = await database.query(
          'Transaction_main',
          where: 'category = ?',
          whereArgs: ['ToGet']
      );
    }catch (e,s) {
      logger.e(
        "Une erreur est survenue lors du chargement de 'ToGet",
        error: e,
        stackTrace: s
      );
      toGet =[];
      rethrow;
    }
  }

  Future<void> loadSommeTotal() async {
    try {
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
      totalToGive = totalGive;
      totalToGet = totalGet;

      }catch (e, s) {
      logger.e("Erreur lors du calcul de la somme totale", error: e, stackTrace: s);
      rethrow;
      }
    }

  Future<void> deleteData(int id) async {
    try {
      await database.delete(
          'Transaction_main',
          where: 'id = ?',
          whereArgs: [id]
      );
    }catch (e, s) {
      logger.e("Erreur lors de la suppression de la donnée id: $id", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateStateCheck(bool value,int id) async {
    try {
      await database.update(
        'Transaction_main',
        {'checked': value ? 1 : 0}, // Convertit le booléen en 0/1
        where: 'id = ?',
        whereArgs: [id],
      );
      }catch (e,s){
      logger.e("Un problème à eu lieu lors du updateStateCheck id: $id",error: e,stackTrace: s);
      rethrow;
    }
    }



  //Ajout :

  Future<void> addData({required String category,required double somme,required String nom, required String cause}) async {
    try {
      await database.insert(
          'Transaction_main',{
        'category' : category,
        'somme' : somme,
        'nom' : nom,
        'cause' : cause
      }
      );
    } catch (e,s){
      logger.e("Une erreur a eu lieu lors du addData ",error: e,stackTrace: s);
      rethrow;
    }
  }

  //Edit

  Future<void> editData({required int id , required String nom , required double somme,required String cause})async {
    try {
      print('id:$id');
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
    }catch (e,s) {
      logger.e("Une erreur a eu lieu lors de editData , id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

}