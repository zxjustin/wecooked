import 'package:flutter/material.dart';
import 'node.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _currentStep = 0;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    StepScenario currentScenario = widget.recipe.stepScenarios[_currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentScenario.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Wrong choice, try again!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          // Display two options as buttons
          for (int i = 0; i < currentScenario.options.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _handleOptionSelection(i),
                child: Text(currentScenario.options[i]),
              ),
            ),
        ],
      ),
    );
  }

  void _handleOptionSelection(int selectedIndex) {
    StepScenario currentScenario = widget.recipe.stepScenarios[_currentStep];

    if (selectedIndex == currentScenario.correctOptionIndex) {
      // Move to the next step
      setState(() {
        _currentStep += 1;
        _hasError = false;
      });

      // Check if the user completed all steps
      if (_currentStep >= widget.recipe.stepScenarios.length) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe Completed!')));
        Navigator.pop(context);
      }
    } else {
      // Show error and stay on the same step
      setState(() {
        _hasError = true;
      });
    }
  }
}
