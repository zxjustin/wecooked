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

    // Check if the box is empty
    if (recipeBox.isNotEmpty) {
      print("Recipes are already loaded. Skipping CSV import.");
      return; // Exit if recipes already exist
    }

    // Load CSV file
    String csvData = await rootBundle.loadString('assets/recipes.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(
        csvData);

    // Assuming the CSV has headers and the first row contains the headers
    for (var row in rowsAsListOfValues.skip(1)) { // Skip header row
      String name = row[0]; // Recipe name
      List<String> ingredients = List<String>.from(
          row[1].split(';')); // Ingredients
      List<StepScenario> stepScenarios = [];

      // Create StepScenario instances from the remaining columns
      for (int i = 2; i < row.length; i += 4) { // Adjust for flexible flag
        if (i + 3 < row.length) {
          String question = row[i]; // Question
          List<String> options = List<String>.from(row[i + 1].split(';')); // Options
          int? correctOptionIndex = row[i + 2] != ''
              ? int.tryParse(row[i + 2].toString()) // Convert to int safely
              : null; // Nullable index
          bool isFlexible = row[i + 3].toLowerCase() == 'true'; // Flexible flag

          stepScenarios.add(StepScenario(
            question: question,
            options: options,
            correctOptionIndex: correctOptionIndex,
            isFlexible: isFlexible,
          ));
        }
      }


      // Add Recipe to Hive
      recipeBox.add(Recipe(
          name: name, ingredients: ingredients, stepScenarios: stepScenarios));
    }

    print("CSV data loaded into Hive.");
  }
}