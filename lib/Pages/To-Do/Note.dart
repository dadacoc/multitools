import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Note extends StatefulWidget {
  
  final String titre;
  final String note;
  
  const Note({super.key,required this.titre,required this.note});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  
  late String titre;
  
  @override
  void initState() {
    super.initState();
    titre = widget.titre;
    noteController.text = widget.note;
  }

  TextEditingController noteController = TextEditingController();
  FocusNode noteFocus = FocusNode();
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une note"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: ()=>context.pop(noteController.text),
              icon: Icon(Icons.done_all),
              tooltip: 'Valider',
          )
        ],
      ),
      body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text(titre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 16,),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false, //Empeche l'utilisation du scroll interne au textfield
                          child: GestureDetector(
                            onTap: ()=> noteFocus.requestFocus(),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: TextField(
                                controller: noteController,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: "Ajouter une note...",
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}