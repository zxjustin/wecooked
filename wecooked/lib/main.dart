import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_db.dart';
import 'WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDB.initHive();
  await HiveDB.loadCSVtoHive();
  runApp(RecipeGameApp());
}

class RecipeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'weCooked',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
