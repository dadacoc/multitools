import 'package:MultiTools/Pages/To-Do/ProviderToDo.dart';
import 'package:MultiTools/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {

  late TodoProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<TodoProvider>(context,listen: false);
  }
  
  @override
  void dispose() {
    super.dispose();
    name.dispose();
    couleur.dispose();
  }



  final _formKey =GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController couleur = TextEditingController(text: 'white');


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
        title: Text("Créer une catégorie"),
        automaticallyImplyLeading: true,
        centerTitle: true,
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
                      validator: (value){
                        if (value == null || value.trim().isEmpty){
                          return "Entrez une valeur !";
                        }else if(provider.categoriesMap.keys.any((key)=> key.trim().toLowerCase() == value.trim().toLowerCase())){
                          return "La catégorie existe déjà";
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
                              provider.addCategory(name: name.text, color: couleur.text);
                              context.pop(name.text);
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
