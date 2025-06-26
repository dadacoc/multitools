import 'package:MultiTools/Pages/Calculatrice.dart';
import 'package:MultiTools/Pages/To-Do/AddToDo.dart';
import 'package:MultiTools/Pages/To-Do/AfficherPlusTodo.dart';
import 'package:MultiTools/Pages/To-Do/EditTodo.dart';
import 'package:MultiTools/Pages/To-Do/Note.dart';
import 'package:MultiTools/Pages/To-Do/To-Do.dart';
import 'package:MultiTools/Pages/To-Do/EditCategory.dart';
import 'package:MultiTools/Pages/Transaction/AddTransaction.dart';
import 'package:MultiTools/Pages/Transaction/EditTransaction.dart';
import 'package:MultiTools/Pages/Transaction/Transaction.dart';
import 'package:MultiTools/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:MultiTools/Pages/To-Do/AddCategory.dart';

final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'Calculatrice',
              builder: (BuildContext context , GoRouterState state) {
                return const Calculatrice();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: "Settings",
                  builder: (BuildContext context , GoRouterState state){
                    return const CalculatriceSettings();
                  }
                ),
              ],
            ),
            GoRoute(
              path: 'Transaction',
              builder: (BuildContext context , GoRouterState state){
                return const Transaction();
              },
              routes: <RouteBase>[
                GoRoute(
                    path: 'AddTransaction',
                    builder: (BuildContext context , GoRouterState state) {
                      return const AddTransaction();
                    }
                ),
                GoRoute(
                    path: 'A_donner',
                    builder: (BuildContext context , GoRouterState state) {
                      return const ADonner();
                    }
                ),
                GoRoute(
                    path: 'A_recevoir',
                    builder: (BuildContext context , GoRouterState state) {
                      return const ARecevoir();
                    }
                ),
                GoRoute(
                    path: 'Edit',
                    builder: (BuildContext context , GoRouterState state){
                      final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                      return EditTransaction(
                          id: data['id'],
                          nom: data['nom'],
                          somme: data['somme'],
                          cause: data['cause']
                      );
                    }
                )
              ]
            ),
            GoRoute(
                path: 'ToDoList',
                builder: (BuildContext context , GoRouterState state) {
                  return const ToDo();
                },
              routes: <RouteBase>[
                GoRoute(
                  path: 'CreateToDo',
                  builder: (BuildContext context , GoRouterState state){
                    return CreateToDo();
                  },
                ),
                GoRoute(
                  path: 'CreateCategory',
                  builder: (BuildContext context, GoRouterState state){
                    return const CreateCategory();
                  }
                ),
                GoRoute(
                    path: 'NoteToDo',
                    builder: (BuildContext context , GoRouterState state){
                      final Map<String,String> data = state.extra as Map<String,String>;
                      final String titre = data['titre'] ?? "";
                      final String note = data["note"] ?? "";
                      return Note(titre:titre,note: note,);
                    }
                ),
                GoRoute(
                    path: 'EditCategory',
                    builder: (BuildContext context, GoRouterState state){
                      final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                      return EditCategory(categorie: data);
                    }
                ),
                GoRoute(
                    path: 'EditTodo',
                    builder: (BuildContext context,GoRouterState state){
                      final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                      return EditTodo(todo: data);
                    }
                ),
                GoRoute(
                    path: 'AfficherPlusTodo',
                    builder: (BuildContext context, GoRouterState state){
                      final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                      return AfficherPlusTodo(todo: data);
                    }
                )
              ]
            )
          ],
      )
    ]
);