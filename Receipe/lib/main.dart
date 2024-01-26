import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:receipe/ui/pages/home.page.dart';
import 'package:get_it/get_it.dart';


import 'data/database.dart';

final database = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Recipe> test = await database.allRecipes;
  log(test.toString());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recip\'Healthy',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
