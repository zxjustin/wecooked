import 'package:flutter/material.dart';
import 'RecipeListScreen.dart';
import 'hive_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDB.initHive();  // Initializes Hive
  HiveDB.loadCSVtoHive();   // Loads recipes into Hive
  runApp(RecipeGameApp());
}

class RecipeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeListScreen(),
    );
  }
}
