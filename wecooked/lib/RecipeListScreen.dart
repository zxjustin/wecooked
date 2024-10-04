import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'node.dart';
import 'RecipeDetailScreen.dart';

class RecipeListScreen extends StatelessWidget {
  final recipeBox = Hive.box('recipeBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Game')),
      body: ValueListenableBuilder(
        valueListenable: recipeBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No recipes yet!'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final recipe = box.getAt(index) as Recipe;
              return Card(
                child: ListTile(
                  title: Text(recipe.name),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
