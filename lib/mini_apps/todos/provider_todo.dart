import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.off : Level.debug
);

class TodoProvider extends ChangeNotifier {

  //Data

  List<Map<String,dynamic>> data = [];
  List<Map<String,dynamic>> categories = [];
  Map<String,dynamic> categoriesMap = {};
  late Database database;

  TodoProvider({required this.database});


  Future<void> loadData({bool needReloadCategories=false}) async {
    //data = await database.query('ToDo_main');

    try {
      if (needReloadCategories){
        await loadCategory();
      }

      data = await database.rawQuery(
      '''
      SELECT ToDo_main.id , ToDo_main.titre , ToDo_main.note , ToDo_main.checked , ToDo_category.name AS categoryName
      FROM ToDo_main
      JOIN ToDo_category ON ToDo_category.id = ToDo_main.category_id
      '''
      );
      categoriesMap = {};
      for (final tuple in data) {
        Map<String, dynamic> modifiableTuple = Map<String, dynamic>.from(tuple); //  Crée une copie modifiable
        modifiableTuple['returnTodoEdit'] = false; //  Ajoute la clé returnTodoEdit qui permet de décider si on return la todo lors de la modification de cette denière

        if (!categoriesMap.containsKey(modifiableTuple['categoryName'])) {
          categoriesMap[modifiableTuple['categoryName']] = [];
        }
        categoriesMap[modifiableTuple['categoryName']].add(modifiableTuple);
      }

      notifyListeners();
    } catch (e,s) {
      logger.e("Erreur avec loadData de Todo",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> loadCategory() async{
    try {
      categories = await database.query('ToDo_category');
      if (categories.isEmpty) {
        await database.insert(
            'ToDo_category',
            {
              'id' : 0,
              'name': 'Sans Catégorie',
              'color' : 'white',
              'checked' : 0
            }
        );
        categories = await database.query('ToDo_category');
      }
    } catch (e,s) {
      logger.e("Erreur avec loadCategory de Todo",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateState(bool value , int id) async {
    try {
      await database.update(
          'ToDo_main',
          {'checked': value ? 1 : 0},
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec updateState de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateCategoryState(bool value,int id) async {
    try {
      await database.update(
          'ToDo_category',
          {'checked' : value ? 1 : 0},
          where: 'id = ?',
          whereArgs: [id]
      );
      await database.update(
          'ToDo_main',
          {'checked' : value ? 1 : 0},
          where: 'category_id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec updateCategory  de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

  /*
  Future<void> clear() async{
    database.delete(
        'ToDo_main',
        where: null,
    );
    await loadData();
  }
   */

  Future<int> getCategoryId({required String category}) async{
    try {
      List<Map<String,dynamic>> result = await database.query(
          'ToDo_category',
          columns: ['id'],
          where: 'name=?',
          whereArgs: [category],
        );
      return result[0]['id'];
    } catch (e,s) {
      logger.e("Erreur avec getCategoryId de Todo, category: $category",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<String> getCategoryName({required int id}) async{
    try {
      List<Map<String,dynamic>> result = await database.query(
          'ToDo_category',
          columns: ['name'],
          where: 'id = ?',
          whereArgs: [id]
      );
      return result[0]['name'];
    } catch (e,s) {
      logger.e("Erreur avec getCategoryName de Todo, category: $id",error: e,stackTrace: s);
      rethrow;
    }
  }


  Future<void> addData({required String titre, required String note , required int categoryId}) async {
    try {
      await database.insert(
          'ToDo_main', {
            'titre' : titre,
            'note' : note,
            'category_id' : categoryId,
            'checked' : 0
      }
      );
    } catch (e,s) {
      logger.e("Erreur avec addData de Todo",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteData({required int id}) async {
    try {
      await database.delete(
          'ToDo_main',
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec deleteData de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateData({required String titre , required String note,required int id,required categoryId}) async {
    try {
      await database.update(
          'ToDo_main',
          {
            'titre': titre,
            'note': note,
            'category_id': categoryId
          },
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec updateData de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> addCategory({required String name, required String color}) async{
    try {
      await database.insert(
          'ToDo_category',
          {
            'name':name,
            'color' : color,
            'checked': 0
          }
      );
    } catch (e,s) {
      logger.e("Erreur avec addCategory de Todo",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateCategory({required String name, required String color,required int id}) async{
    try {
      await database.update(
          'ToDo_category',
          {
            'name':name,
            'color' : color
          },
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec updateCategory de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteCategorie({required int id,required bool supprimerTaches}) async {

    try {
      if (supprimerTaches){
        await database.delete(
            'ToDo_main',
            where: "category_id = ?",
            whereArgs: [id]
        );
      }else{
        await database.update(
            'ToDo_main',{
              'category_id' : 0
        },
            where: 'category_id = ?',
            whereArgs: [id]
        );
      }

      await database.delete(
          'ToDo_category',
          where: 'id = ?',
          whereArgs: [id]
      );
    } catch (e,s) {
      logger.e("Erreur avec deleteCategory de Todo, id: $id",error: e,stackTrace: s);
      rethrow;
    }
  }


  

}