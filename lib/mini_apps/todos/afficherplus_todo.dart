import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AfficherPlusTodo extends StatefulWidget {

  final Map<String,dynamic> todo;

  const AfficherPlusTodo({super.key, required this.todo});

  @override
  State<AfficherPlusTodo> createState() => _AfficherPlusTodoState();
}

class _AfficherPlusTodoState extends State<AfficherPlusTodo> {

  late Map<String,dynamic> todo;
  late int id;
  late String titre;
  late String note;
  late bool checked;
  late String categoryName;

  @override
  void initState() {
    super.initState();
    todo = widget.todo;
    todo['returnTodoEdit'] = true; //On change la valeur en true car on veux avoir la modification si il y a de todo
    loadDataTodo();
  }

  void loadDataTodo() {
    id = todo['id'];
    titre = todo['titre'];
    note = todo['note'];
    checked = todo['checked']==1;
    categoryName = todo['categoryName'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Afficher Plus"),
        actions: [
          IconButton(
              onPressed: () async {
                Map<String,dynamic>? result = await context.pushNamed('edit-todo',extra: todo);
                if (result!=null){
                  setState(() {
                    todo = result;
                    loadDataTodo();
                  });
                }
              },
              icon: Icon(Icons.edit_note),
              tooltip: "Modifier la tâche",
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            Text(titre),

            SizedBox(height: 16,),
            Text("Category :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            const Divider(
              height: 32,
              thickness: 2,
              color: Colors.grey,
            ),
            Text(categoryName),

            SizedBox(height: 16,),
            Text("Note :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            const Divider(
              height: 32,
              thickness: 2,
              color: Colors.grey,
            ),
            note.trim().isEmpty ? Text("Aucune note n'a été ajouté") : Text(note)
          ],
        ),
      ),
    );
  }
}
