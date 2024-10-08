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
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          buttonColor: Colors.green,
        ),
      ),
      home: RecipeListScreen(),
    );
  }
}
