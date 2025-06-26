import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class TodoProvider extends ChangeNotifier {

  //Data

  List<Map<String,dynamic>> data = [];
  List<Map<String,dynamic>> categories = [];
  Map<String,dynamic> categoriesMap = {};
  late Database database;

  TodoProvider({required this.database});


  Future<void> loadData({needReloadCategories=false}) async {
    //data = await database.query('ToDo_main');

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

  }

  Future<void> loadCategory() async{
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
    /*
    for (final category in categories) {
      categoriesMap[category['id']] = category['name'];
    }*/
  }

  Future<void> updateState(bool value , int id) async {
    await database.update(
        'ToDo_main',
        {'checked': value ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id]
    );
    await loadData();
  }

  Future<void> updateCategoryState(bool value,int id) async {
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

    await loadData(needReloadCategories: true);
  }

  Future<void> clear() async{
    database.delete(
        'ToDo_main',
        where: null,
    );
    await loadData();
  }

  Future<int> getCategoryId({required String category}) async{
    List<Map<String,dynamic>> result = await database.query(
        'ToDo_category',
        columns: ['id'],
        where: 'name=?',
        whereArgs: [category],
      );
    return result[0]['id'];
  }

  Future<String> getCategoryName({required int id}) async{
    List<Map<String,dynamic>> result = await database.query(
        'ToDo_category',
        columns: ['name'],
        where: 'id = ?',
        whereArgs: [id]
    );
    return result[0]['name'];
  }


  Future<void> addData({required String titre, required String note , required int category_id}) async {
    await database.insert(
        'ToDo_main', {
          'titre' : titre,
          'note' : note,
          'category_id' : category_id,
          'checked' : 0
    }
    );
    await loadData();
  }

  Future<void> deleteData({required int id}) async {
    await database.delete(
        'ToDo_main',
        where: 'id = ?',
        whereArgs: [id]
    );
    await loadData();
  }

  Future<void> updateData({required String titre , required String note,required int id,required categoryId}) async {
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
    await loadData();
  }

  Future<void> addCategory({required String name, required String color}) async{
    await database.insert(
        'ToDo_category',
        {
          'name':name,
          'color' : color,
          'checked': 0
        }
    );
    await loadData(needReloadCategories: true);
  }

  Future<void> updateCategory({required String name, required String color,required int id}) async{
    await database.update(
        'ToDo_category',
        {
          'name':name,
          'color' : color
        },
        where: 'id = ?',
        whereArgs: [id]
    );
    await loadData(needReloadCategories: true);
  }

  Future<void> deleteCategorie({required int id,required bool supprimerTaches}) async {

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

    await loadData(needReloadCategories: true);
  }


  

}