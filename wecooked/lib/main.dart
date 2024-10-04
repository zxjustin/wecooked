import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'RecipeListScreen.dart';
import 'node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(StepScenarioAdapter());
  await Hive.openBox('recipeBox');
  loadInitialData();  // Preload scenarios
  runApp(RecipeGameApp());
}

void loadInitialData() async {
  var box = Hive.box('recipeBox');
  if (box.isEmpty) {
    Recipe sampleRecipe = Recipe(
      name: "Pasta",
      ingredients: ["Tomatoes", "Pasta", "Cheese"],
      stepScenarios: [
        StepScenario(
          question: "Choose an ingredient to start cooking:",
          options: ["Tomatoes", "Apples"],
          correctOptionIndex: 0,
        ),
        StepScenario(
          question: "What should you add next?",
          options: ["Pasta", "Cheese"],
          correctOptionIndex: 0,
        ),
        StepScenario(
          question: "Final touch, what will you add?",
          options: ["Cheese", "Ketchup"],
          correctOptionIndex: 0,
        ),
      ],
    );
    await box.put('sample_recipe', sampleRecipe);
  }
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
