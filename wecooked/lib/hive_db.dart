import 'package:hive_flutter/hive_flutter.dart';
import 'node.dart';

class HiveDB {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(StepScenarioAdapter());
    await Hive.openBox<Recipe>('recipes');
  }

  static void loadCSVtoHive() async {
    var recipeBox = Hive.box<Recipe>('recipes');

    if (recipeBox.isEmpty) {
      // Load multiple recipes into Hive
      recipeBox.add(
        Recipe(
          name: 'Classic Pasta',
          ingredients: ['Pasta', 'Tomato Sauce', 'Cheese'],
          stepScenarios: [
            StepScenario(
              question: 'Choose the main ingredient.',
              options: ['Pasta', 'Rice'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the sauce.',
              options: ['Tomato Sauce', 'Soy Sauce'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the topping.',
              options: ['Cheese', 'Ketchup'],
              correctOptionIndex: 0,
            ),
          ],
        ),
      );

      recipeBox.add(
        Recipe(
          name: 'Spaghetti Bolognese',
          ingredients: ['Spaghetti', 'Ground Beef', 'Tomato Sauce', 'Garlic'],
          stepScenarios: [
            StepScenario(
              question: 'Choose the pasta.',
              options: ['Spaghetti', 'Macaroni'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the meat.',
              options: ['Ground Beef', 'Chicken'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the sauce.',
              options: ['Tomato Sauce', 'Pesto Sauce'],
              correctOptionIndex: 0,
            ),
          ],
        ),
      );

      recipeBox.add(
        Recipe(
          name: 'Alfredo Pasta',
          ingredients: ['Fettuccine', 'Cream', 'Parmesan Cheese'],
          stepScenarios: [
            StepScenario(
              question: 'Choose the type of pasta.',
              options: ['Fettuccine', 'Spaghetti'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the sauce.',
              options: ['Alfredo Sauce', 'Tomato Sauce'],
              correctOptionIndex: 0,
            ),
            StepScenario(
              question: 'Choose the topping.',
              options: ['Parmesan Cheese', 'Cheddar Cheese'],
              correctOptionIndex: 0,
            ),
          ],
        ),
      );
    }
  }
}
