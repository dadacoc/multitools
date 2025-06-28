import 'package:MultiTools/Pages/To-Do/provider_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> afficherPlusCateogie(BuildContext context,String nom,String colorString,Color color) async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Afficher plus :",style: TextStyle(fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Nom :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),
                Text(nom),
                const SizedBox(height: 16,),
                Text("Couleur :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const Divider(
                  height: 32,
                  thickness: 2,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(colorString,),
                    const SizedBox(width: 8,),
                    Container(
                      height: 20,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: color,
                          border: Border.all(color: Colors.black26,width: 2)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Fermer"))
          ],
        );
      }
  );
}

Future<void> deleteCategory(BuildContext context, int id,String name) async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Suppression d'une catégorie",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Vous êtes sur le point de supprimer la catégorie :",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("\n$name",maxLines: 4,overflow: TextOverflow.ellipsis,),
                Text("\nVoulez-vous supprimer toutes les tâches existantes associées à cette catégorie ?", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await confirmationDeleteCategory(context, id, name, true);
                },
                child: Text("Oui")),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await confirmationDeleteCategory(context, id, name, false);
                },
                child: Text("Non"))
          ],
        );
      }
  );
}

Future<void> confirmationDeleteCategory(BuildContext context,int id,String name, bool supprimerTaches)async {
  TodoProvider provider = Provider.of<TodoProvider>(context , listen: false);
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Confirmation",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Cette action est définitive. \nÊtes-vous sûr de vouloir supprimer la catégorie :",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("\n$name",maxLines: 4,overflow: TextOverflow.ellipsis,),
                supprimerTaches ? Text("\nAinsi que les tâches associées à cette dernière",style: TextStyle(fontWeight: FontWeight.bold),) : Text("\nLes tâches existantes seront déplacées dans la catégorie : \"Sans Catégorie\".",style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await provider.deleteCategorie(id: id, supprimerTaches: supprimerTaches);
                },
                child: Text("Valider")),
            TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Annuler"))
          ],
        );
      }
  );
}
