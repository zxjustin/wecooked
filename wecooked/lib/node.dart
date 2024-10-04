import 'package:hive/hive.dart';

part 'node.g.dart'; // Hive code generation

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> ingredients;

  @HiveField(2)
  List<String> steps;

  Recipe({required this.name, required this.ingredients, required this.steps});
}