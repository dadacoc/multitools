import 'package:multitools/mini_apps/todos/provider_todo.dart';
import 'package:multitools/mini_apps/todos/category_option.dart';
import 'package:multitools/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';


class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {

  //Route

  final int _selectedIndex = 2;

  void _onItemTapped(int index) {
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

  void _showErrorSnackbar(String message){
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _handleupdateCategoryState(bool value,int id) async {
    final provider = Provider.of<TodoProvider>(context,listen: false);
    try {
      await provider.updateCategoryState(value, id);
    }catch (e){
      _showErrorSnackbar("Erreur durant le changement de l'état de la catégory");
    }
    try {
      await provider.loadData(needReloadCategories: true);
    }catch (e){
      _showErrorSnackbar("Erreur durant le raffraichissement des données, tentez de relancer la page");
    }
  }

  Future<void> _handleupdateState(bool value,int id) async {
    final provider = Provider.of<TodoProvider>(context,listen: false);
    try {
      await provider.updateState(value, id);
    }catch (e){
      _showErrorSnackbar("Erreur durant le changement de l'état de la tâche");
    }
    try {
      await provider.loadData();
    }catch (e){
      _showErrorSnackbar("Erreur durant le raffraichissement des données, tentez de relancer la page");
    }
  }

  Future<void> _handleDeleteData({required int id}) async {
    final provider = Provider.of<TodoProvider>(context,listen: false);
    try {
      provider.deleteData(id: id);
    }catch (e){
      _showErrorSnackbar("Erreur lors de la suppression de la tâche");
    }
    try {
      await provider.loadData();
    }catch (e){
      _showErrorSnackbar("Erreur durant le raffraichissement des données, tentez de relancer la page");
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TodoProvider>(context , listen: false);
    provider.loadData(needReloadCategories: true).catchError((e){
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur durant le chargement des données")));
      }
    });
    //provider.clear();
    //provider.testCreation();
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: (provider.data.isEmpty)
          ? Text("Aucune tâche n'a été crée")
          :ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          itemCount: provider.categories.length,
          itemBuilder: (BuildContext context , int index){
            final category = provider.categories[index];
            final categoryId = category['id'];
            final categoryName = category['name'];
            final categoryChecked = category['checked']==1;
            final categoryColorString = category['color'];
            final todos = provider.categoriesMap[categoryName] ?? [];
            Color categoryColor = ColorsManager.getColorFromString(categoryColorString);

            if (todos.isEmpty) return SizedBox.shrink(); // permet d'ignorer les catégorie sans todos , en ne prenant aucune place

            return Container(
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: EdgeInsets.only(top: 4),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    title: Row(
                      children: [
                        Checkbox(
                            value: categoryChecked,
                            onChanged: (bool? value) async {
                              await _handleupdateCategoryState(value!,categoryId);
                            }
                            ),
                        Expanded(
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: categoryChecked ? TextDecoration.lineThrough : TextDecoration.none
                            ) ,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton(
                            onSelected: (String choice) async {
                              switch (choice) {
                                case ('Afficher plus'):
                                  await afficherPlusCateogie(context, categoryName, categoryColorString,categoryColor);
                                  break;
                                case ('Delete'):
                                  await deleteCategory(context, categoryId, categoryName);
                                  break;
                                case ('Edit'):
                                  await context.push('/ToDoList/EditCategory',extra: category);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              List<PopupMenuEntry<String>> menuItems = [
                                const PopupMenuItem(
                                  value: 'Afficher plus',
                                  child: Text("Afficher plus"),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                    value: 'Edit',
                                    child: Row(
                                      children: [
                                        Text("Edit"),
                                        SizedBox(width: 8,),
                                        Icon(Icons.edit,color: Colors.black,)
                                      ],
                                    )
                                ),
                              ];
                              if (categoryName!='Sans Catégorie'){
                                menuItems.add(const PopupMenuDivider());
                                menuItems.add(const PopupMenuItem(
                                    value: 'Delete',
                                    child: Row(children: [
                                      Text("Delete",style: TextStyle(color: Colors.redAccent),),
                                      SizedBox(width: 8,),
                                      Icon(Icons.delete,color: Colors.redAccent,)
                                    ],)
                                )
                                );
                              }
                              return menuItems;
                            }
                        ),
                      ],
                    ),
                    children: todos.map<Widget>((todo){
                      final id = todo['id'];
                      final titre = todo['titre'];
                      final checked = todo['checked']==1;

                      return ListTile(
                        leading: Checkbox(
                          onChanged: (bool? value) async {
                            await _handleupdateState(value!, id);
                          },
                          value: checked,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$titre',style: TextStyle(
                              decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                            onSelected: (String choice) async {
                              switch (choice) {
                                case ('Afficher plus'):
                                  context.go('/ToDoList/AfficherPlusTodo',extra: todo);
                                  break;
                                case ('Delete'):
                                  await _handleDeleteData(id: id);
                                  break;
                                case ('Edit'):
                                  context.push('/ToDoList/EditTodo',extra: todo);
                                  break;
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
                      );
                    }).toList()
                ),
              )
            );
          },
      ),

      floatingActionButton: SizedBox(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          onPressed: () => context.go("/ToDoList/CreateToDo"),
          child: Icon(Icons.edit_note),
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