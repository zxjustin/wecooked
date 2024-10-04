import 'package:hive/hive.dart';

part 'node.g.dart'; // Hive code generation

@HiveType(typeId: 0)
class Recipe {
@HiveField(0)
String name;

@HiveField(1)
List<String> ingredients;

@HiveField(2)
List<StepScenario> stepScenarios;

Recipe({required this.name, required this.ingredients, required this.stepScenarios});
}

@HiveType(typeId: 1)
class StepScenario {
@HiveField(0)
String question;

@HiveField(1)
List<String> options;

@HiveField(2)
int correctOptionIndex;

StepScenario({required this.question, required this.options, required this.correctOptionIndex});
}