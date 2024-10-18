import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'StepScenarioScreen.dart';
import 'node.dart';

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('weCooked')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kitchen.gif'), // Fixed the background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Adds the tint
          ),
          Column(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: ClipOval(
                  child: Image.asset(
                    'assets/home_image.jpg',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Recipe>('recipes').listenable(),
                  builder: (context, Box<Recipe> recipeBox, _) {
                    if (recipeBox.isEmpty) {
                      return Center(child: Text('No recipes found.'));
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10, // Adjust spacing between buttons
                          mainAxisSpacing: 10,  // Adjust vertical spacing
                          childAspectRatio: 6, // Adjust the aspect ratio to make buttons smaller in width
                        ),
                        padding: const EdgeInsets.all(10),
                        itemCount: recipeBox.length,
                        itemBuilder: (context, index) {
                          Recipe? recipe = recipeBox.getAt(index);
                          return Container(
                            constraints: BoxConstraints(
                              minWidth: 80, // Minimum width for the button
                              maxWidth: 150, // Maximum width for the button
                            ),
                            child: Card(
                              color: Color(0xFFA8D5BA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              child: InkWell(
                                onTap: () {
                                  if (recipe != null) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            StepScenarioScreen(recipe: recipe!),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
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
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      recipe?.name ?? 'Unnamed Recipe',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2F4F4F),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
