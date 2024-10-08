import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'StepScenarioScreen.dart';
import 'node.dart';

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Game')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Recipe>('recipes').listenable(),
        builder: (context, Box<Recipe> recipeBox, _) {
          if (recipeBox.isEmpty) {
            return Center(child: Text('No recipes found.'));
          } else {
            return ListView.builder(
              itemCount: recipeBox.length,
              itemBuilder: (context, index) {
                Recipe? recipe = recipeBox.getAt(index);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(recipe?.name ?? 'Unnamed Recipe',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        if (recipe != null) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => StepScenarioScreen(recipe: recipe!),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);  // Transition from bottom to top
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );

                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}