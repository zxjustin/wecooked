import 'package:flutter/material.dart';
import 'node.dart';

class StepScenarioScreen extends StatefulWidget {
  final Recipe recipe;

  StepScenarioScreen({required this.recipe});

  @override
  _StepScenarioScreenState createState() => _StepScenarioScreenState();
}

class _StepScenarioScreenState extends State<StepScenarioScreen> {
  int currentStep = 0;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.recipe.name)),
        body: Center(
          child: Text("Congratulations! You've completed the recipe."),
        ),
      );
    }

    StepScenario step = widget.recipe.stepScenarios[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(step.question, style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (step.correctOptionIndex == 0) {
                moveToNextStep();
              } else {
                showError(context);
              }
            },
            child: Text(step.options[0]),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (step.correctOptionIndex == 1) {
                moveToNextStep();
              } else {
                showError(context);
              }
            },
            child: Text(step.options[1]),
          ),
        ],
      ),
    );
  }

  void moveToNextStep() {
    setState(() {
      if (currentStep < widget.recipe.stepScenarios.length - 1) {
        currentStep++;
      } else {
        completed = true;
      }
    });
  }

  void showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wrong Choice'),
        content: Text('Try again!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}