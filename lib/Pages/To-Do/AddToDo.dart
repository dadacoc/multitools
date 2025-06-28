import 'package:MultiTools/Pages/To-Do/ProviderToDo.dart';
import 'package:MultiTools/Pages/To-Do/categoryOption.dart';
import 'package:MultiTools/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CreateToDo extends StatefulWidget {

  const CreateToDo({super.key});

  @override
  State<CreateToDo> createState() => _CreateToDoState();
}

class _CreateToDoState extends State<CreateToDo> {

  late TodoProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<TodoProvider>(context,listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    titreTodo.dispose();
    categorie.dispose();
  }

  Future<void> addData() async {
    provider.addData;
  }

  final _formKey =GlobalKey<FormState>();
  TextEditingController titreTodo = TextEditingController();
  TextEditingController categorie = TextEditingController(text: 'Sans Catégorie');


  //Note
  String note = "";


  // Selection catégorie

  Future<String?> selectCategorie(BuildContext context) async {

    TextEditingController searchBar = TextEditingController();
    String categorieChoisie = categorie.text;

    return await showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true, //Permet de le rendre scrollable et étendable
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context){

          return StatefulBuilder(
              builder: (context , setState){
                TodoProvider provider = Provider.of<TodoProvider>(listen: true,context);
                List<Map<String, dynamic>> filteredCategories = List.from(provider.categories);

                return Container(
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20, bottom: MediaQuery.of(context).viewInsets.bottom), //Permet de mettre le padding du clavier
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height*0.7 //Permet de limiter la taille a 70% de l'ecran
                  ) ,
                  child: Column(
                    children: [
                      TextField( //Pour le code via searchBar , en bas de page
                        controller: searchBar,
                        decoration: InputDecoration(
                            hintText:"Rechercher",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                        onChanged: (recherche){
                          setState((){
                            filteredCategories = provider.categories.where((categorie) => categorie['name'].toLowerCase().contains(recherche.toLowerCase())).toList();
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index){

                              final category = filteredCategories[index];
                              final categoryId = category['id'];
                              final categoryName = category['name'];
                              final categoryColorString = category['color'];
                              Color categoryColor = ColorsManager.getColorFromString(categoryColorString);


                              return ListTile(
                                title: Text(categoryName,maxLines: 2,overflow: TextOverflow.ellipsis,),
                                onTap: (){
                                  categorieChoisie = categoryName;
                                  Navigator.pop(context,categorieChoisie);
                                },
                                trailing: PopupMenuButton(
                                    onSelected: (String choice) async {
                                      switch (choice) {
                                        case ('Afficher plus'):
                                          await afficherPlusCateogie(context, categoryName, categoryColorString,categoryColor);
                                          break;
                                        case ('Delete'):
                                          if (categorieChoisie==categoryName){
                                              categorieChoisie = 'Sans Catégorie';
                                              categorie.text = categorieChoisie;
                                          }
                                          await deleteCategory(context, categoryId, categoryName);
                                          break;
                                        case ('Edit'):
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
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer une tâche"),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16,),
                  Text("Tâche :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  const Divider(
                    height: 32,
                    thickness: 2,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Titre"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      controller: titreTodo,
                      validator: (value){
                        if (value==null || value.trim().isEmpty){
                          return "Entrez une valeur !";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 35,
                        child: TextButton(
                            onPressed: () async {

                              if (titreTodo.text.trim().isNotEmpty){
                                final String? noteUser = await context.push('/ToDoList/NoteToDo',extra: <String,String>{'titre' : titreTodo.text , 'note' : note }); //On précise que c'est un Map<String,String> pour éviter des erreurs de cast
                                if (noteUser!=null && noteUser.isNotEmpty){
                                  note = noteUser;
                                }
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez donner un titre avant d'ajouter une note")));
                              }

                            },
                            child: Row(
                              children: [
                                Text("Ajouter une note "),
                                Icon(Icons.add_circle)
                              ],
                            )
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16,),
                  Text("Catégorie :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  const Divider(
                    height: 32,
                    thickness: 2,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          label: Text("Nom"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          suffixIcon: Icon(Icons.arrow_drop_down)
                      ),
                      controller: categorie,
                      readOnly: true,
                      validator: (value){
                        if (value == null || value.trim().isEmpty){
                          return "Entrer une valeur !";
                        }
                        return null;
                      },
                      onTap: () async {
                        String? categorieName = await selectCategorie(context);
                        if (categorieName !=null){
                          categorie.text = categorieName;
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 35,
                        child: TextButton(
                            onPressed: () async {
                              final String? categorieCreer = await context.push('/ToDoList/CreateCategory');
                              if (categorieCreer!=null && categorieCreer.isNotEmpty){
                                categorie.text=categorieCreer;
                              }

                            },
                            child: Row(
                              children: [
                                Text("Créer une catégorie "),
                                Icon(Icons.add_circle)
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()){
                              final categoryId = await provider.getCategoryId(category: categorie.text);
                              provider.addData(titre: titreTodo.text, note : note, category_id: categoryId);
                              context.go('/ToDoList');
                            }
                          },
                          child: Row(
                            children: [
                              Text("Valider"),
                              SizedBox(width: 5,),
                              Icon(Icons.done_all)
                            ],
                          )
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      );
  }
}


/*

Code search bar:

                   SearchBar(
                        hintText: 'Rechercher',
                        leading: Icon(Icons.search),
                        elevation: WidgetStatePropertyAll(1),
                        onChanged: (recherche){
                          setState((){
                            filteredCategories = categories.where((categorie) => categorie.toLowerCase().contains(searchBar.text.toLowerCase())).toList();
                          });
                        },
                      ),




                      TextField( //Pour le code via searchBar , en bas de page
                        controller: searchBar,
                        decoration: InputDecoration(
                            hintText:"Rechercher",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                        onChanged: (recherche){
                          setState((){
                            filteredCategories = categories.where((categorie) => categorie.toLowerCase().contains(recherche.toLowerCase())).toList();
                          });
                        },
                      ),
 */
