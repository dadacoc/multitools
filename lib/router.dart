import 'package:multitools/mini_apps/chore_trackers/chore_tracker.dart';
import 'package:multitools/mini_apps/home/catalogue_page/catalogue.dart';
import 'package:multitools/mini_apps/todos/add_todo.dart';
import 'package:multitools/mini_apps/todos/afficherplus_todo.dart';
import 'package:multitools/mini_apps/todos/edit_todo.dart';
import 'package:multitools/mini_apps/todos/note.dart';
import 'package:multitools/mini_apps/todos/todo.dart';
import 'package:multitools/mini_apps/todos/edit_category.dart';
import 'package:multitools/mini_apps/transactions/add_transaction.dart';
import 'package:multitools/mini_apps/transactions/edit_transaction.dart';
import 'package:multitools/mini_apps/transactions/transaction.dart';
import 'package:multitools/mini_apps/home/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multitools/mini_apps/todos/add_category.dart';
import 'mini_apps/chore_trackers/chore_tracker_settings.dart';
import 'mini_apps/home/home_shell.dart';

final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      ShellRoute(
          builder: (BuildContext context,GoRouterState state,Widget child){
            return HomeShell(child:child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              name: 'home',
              builder: (BuildContext context, GoRouterState state) {
                return const HomePage();
              },
            ),
            GoRoute(
              path: '/catalogue',
              name: 'catalogue',
              builder: (BuildContext context,GoRouterState state){
                final bool data = state.extra as bool;
                return Catalogue(isPickerMode: data,);
              }
            )
          ]
      ),
      GoRoute(
        path: '/chore-tracker',
        name: 'chore-tracker',
        builder: (BuildContext context , GoRouterState state) {
          return const ChoreTracker();
        },
        routes: <RouteBase>[
          GoRoute(
            path: "settings",
            name: 'chore-tracker-settings',
            builder: (BuildContext context , GoRouterState state){
              return const ChoreTrackerSettings();
            }
          ),
        ],
      ),
      GoRoute(
        path: '/transaction',
        name: 'transaction',
        builder: (BuildContext context , GoRouterState state){
          return const Transaction();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'add-transaction',
              name: 'add-transaction',
              builder: (BuildContext context , GoRouterState state) {
                return const AddTransaction();
              }
          ),
          GoRoute(
              path: 'a-donner',
              name: 'transaction-a-donner',
              builder: (BuildContext context , GoRouterState state) {
                return const ADonner();
              }
          ),
          GoRoute(
              path: 'a-recevoir',
              name: 'transaction-a-recevoir',
              builder: (BuildContext context , GoRouterState state) {
                return const ARecevoir();
              }
          ),
          GoRoute(
              path: 'edit',
              name: 'edit-transaction',
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
          path: '/todo-list',
          name: 'todo-list',
          builder: (BuildContext context , GoRouterState state) {
            return const ToDo();
          },
        routes: <RouteBase>[
          GoRoute(
            path: 'create-todo',
            name: 'create-todo',
            builder: (BuildContext context , GoRouterState state){
              return CreateToDo();
            },
          ),
          GoRoute(
            path: 'create-category',
            name: 'create-category-todo',
            builder: (BuildContext context, GoRouterState state){
              return const CreateCategory();
            }
          ),
          GoRoute(
              path: 'note-todo',
              name: 'note-todo',
              builder: (BuildContext context , GoRouterState state){
                final Map<String,String> data = state.extra as Map<String,String>;
                final String titre = data['titre'] ?? "";
                final String note = data["note"] ?? "";
                return Note(titre:titre,note: note,);
              }
          ),
          GoRoute(
              path: 'edit-category',
              name: 'edit-category-todo',
              builder: (BuildContext context, GoRouterState state){
                final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                return EditCategory(categorie: data);
              }
          ),
          GoRoute(
              path: 'edit-todo',
              name: 'edit-todo',
              builder: (BuildContext context,GoRouterState state){
                final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                return EditTodo(todo: data);
              }
          ),
          GoRoute(
              path: 'afficher-plus-todo',
              name: 'afficher-plus-todo',
              builder: (BuildContext context, GoRouterState state){
                final Map<String,dynamic> data = state.extra as Map<String,dynamic>;
                return AfficherPlusTodo(todo: data);
              }
          )
        ]
      )
    ]
);