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
          child: Text("Congratulations! You've completed the recipe.",
              style: TextStyle(fontSize: 20)),
        ),
      );
    }

    StepScenario step = widget.recipe.stepScenarios[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),  // Add background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: (currentStep + 1) / widget.recipe.stepScenarios.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 20),
            Text(step.question, style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                if (step.correctOptionIndex == 0) {
                  moveToNextStep();
                } else {
                  showError(context);
                }
              },
              child: Text(step.options[0], style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                if (step.correctOptionIndex == 1) {
                  moveToNextStep();
                } else {
                  showError(context);
                }
              },
              child: Text(step.options[1], style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wrong Choice, Try again!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}