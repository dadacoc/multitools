import 'package:multitools/mini_apps/todos/provider_todo.dart';
import 'package:multitools/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class EditCategory extends StatefulWidget {

  final Map<String,dynamic> categorie;

  const EditCategory({super.key,required this.categorie});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  late TodoProvider provider;
  late Map<String,dynamic> category;
  late int categoryId;
  late String categoryName;
  late bool categoryChecked;
  late String categoryColorString;
  late Color categoryColor;
  late TextEditingController name;
  late TextEditingController couleur;

  void _showErrorSnackbar(String message){
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _handleupdateCategory({required String name, required String color,required int id}) async {
    final provider = Provider.of<TodoProvider>(context,listen: false);
    try {
      await provider.updateCategory(name: name, color: color, id: id);
    }catch (e){
      _showErrorSnackbar("Erreur durant l'édit de la catégory");
    }
    try {
      await provider.loadData(needReloadCategories: true);
    }catch (e){
      _showErrorSnackbar("Erreur durant le raffraichissement des données, tentez de relancer la page");
    }
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<TodoProvider>(context,listen: false);
    category = widget.categorie;
    name = TextEditingController();
    couleur = TextEditingController();
    loadDataCategory();
  }

  @override
  void dispose() {
    name.dispose();
    couleur.dispose();
    super.dispose();
  }

  void loadDataCategory(){

    categoryId = category['id'];
    categoryName = category['name'];
    categoryChecked = category['checked']==1;
    categoryColorString = category['color'];
    categoryColor = ColorsManager.getColorFromString(categoryColorString);

    couleur.text = categoryColorString;
    name.text = categoryName;

  }



  final _formKey =GlobalKey<FormState>();


  Future<String?> selectColor(BuildContext context) async {
    List<Color> colors = ColorsManager.colorToString.keys.toList();

    return await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext context){
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Choisir une couleur : ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 16,),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8
                    ),
                    itemCount: colors.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context , index){
                      final color = colors[index];
                      return GestureDetector(
                        onTap: (){
                          final colorString = ColorsManager.getStringFromColor(color);
                          Navigator.pop(context,colorString);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(color: Colors.black26,width: 2)
                          ),
                        ),
                      );
                    }
                )
              ],
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier une catégorie"),
        backgroundColor: Colors.blue,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16,),
                Text("Nom de la catégorie :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),

                SizedBox(
                    height: 70,
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          label: const Text("Nom"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      enabled: categoryName=='Sans Catégorie'? false : true ,
                      validator: (value){
                        if (value == null || value.trim().isEmpty){
                          return "Entrez une valeur !";
                        }
                        return null;
                      },
                    )
                ),

                SizedBox(height: 16,),

                Text("Couleur de la catégorie :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),

                SizedBox(
                  height: 70,
                  child: TextFormField(
                    controller: couleur,
                    decoration: InputDecoration(
                        label: const Text("Couleur"),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Icon(Icons.palette)
                    ),
                    readOnly: true,
                    onTap: () async {
                      String? color = await selectColor(context);
                      if (color!=null){
                        couleur.text = color;
                      }
                    },
                    validator: (value){
                      if(value ==null || value.isEmpty){
                        return "Choisissez une couleur !";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()){
                            await _handleupdateCategory(name: name.text, color: couleur.text,id: categoryId);
                            if (context.mounted) {
                              context.pop();
                            }
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
            ),
          )
      ),
    );
  }
}

