import 'package:multitools/mini_apps/todos/provider_todo.dart';
import 'package:multitools/mini_apps/transactions/provider.dart';
import 'package:multitools/router.dart';
import 'package:multitools/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final database = await initialisationDB();
  runApp(MyApp(database : database));
}
class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>.value(value: database),
        ChangeNotifierProvider(create: (_) => TransactionsProvider(database)),
        ChangeNotifierProvider(create: (_) => TodoProvider(database: database)),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}