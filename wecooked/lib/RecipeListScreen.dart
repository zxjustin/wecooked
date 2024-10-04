import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'RecipeDetailScreen.dart';
import 'node.dart';  // Import your models here

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the Hive box where recipes are stored
    var recipeBox = Hive.box<Recipe>('recipes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: recipeBox.listenable(),
        builder: (context, Box<Recipe> box, _) {
          // Check if the box is empty
          if (box.isEmpty) {
            return Center(
              child: Text('No recipes available.'),
            );
          }

          // Display the list of recipes
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Recipe recipe = box.getAt(index) as Recipe;

              return ListTile(
                title: Text(recipe.name),
                onTap: () {
                  // Navigate to the recipe detail screen (implement separately)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
