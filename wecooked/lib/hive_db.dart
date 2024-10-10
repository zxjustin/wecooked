import 'package:hive_flutter/hive_flutter.dart';
import 'node.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

class HiveDB {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(StepScenarioAdapter());
    await Hive.openBox<Recipe>('recipes');
  }

  static Future<void> loadCSVtoHive() async {
    var recipeBox = Hive.box<Recipe>('recipes');

    // Load CSV file
    String csvData = await rootBundle.loadString('assets/recipes.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvData);

    // Assuming the CSV has headers and the first row contains the headers
    for (var row in rowsAsListOfValues.skip(1)) { // Skip header row
      String name = row[0]; // Assuming the name is in the first column
      List<String> ingredients = List<String>.from(row[1].split(';')); // Assuming ingredients are separated by semicolons
      List<StepScenario> stepScenarios = [];

      // Create StepScenario instances from the remaining columns
      for (int i = 2; i < row.length; i += 3) { // Adjust to handle more questions
        if (i + 2 < row.length) {
          String question = row[i];
          List<String> options = List<String>.from(row[i + 1].split(';')); // Assuming options are separated by semicolons
          int correctOptionIndex = row[i + 2];
          stepScenarios.add(StepScenario(question: question, options: options, correctOptionIndex: correctOptionIndex));
        }
      }

      // Add Recipe to Hive
      recipeBox.add(Recipe(name: name, ingredients: ingredients, stepScenarios: stepScenarios));
    }
  }
}
