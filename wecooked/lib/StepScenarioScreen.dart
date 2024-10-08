import 'package:flutter/material.dart';
import 'node.dart';


class StepScenarioScreen extends StatefulWidget {
  final Recipe recipe;

  StepScenarioScreen({required this.recipe});

  @override
  _StepScenarioScreenState createState() => _StepScenarioScreenState();
}

class _StepScenarioScreenState extends State<StepScenarioScreen> with SingleTickerProviderStateMixin {
  int currentStep = 0;
  bool completed = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();  // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();  // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.recipe.name)),
        body: Center(
          child: Text("Congratulations! You've completed the recipe.",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      );
    }

    StepScenario step = widget.recipe.stepScenarios[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getBackgroundImageForRecipe(widget.recipe.name)),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: LinearProgressIndicator(
                  value: (currentStep + 1) / widget.recipe.stepScenarios.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Text(step.question, style: TextStyle(fontSize: 22, color: Colors.white)),
              ),
              SizedBox(height: 20),
              buildAnimatedButton(step, 0),
              SizedBox(height: 10),
              buildAnimatedButton(step, 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedButton(StepScenario step, int optionIndex) {
    return SlideTransition(
      position: _slideAnimation,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onPressed: () {
          if (step.correctOptionIndex == optionIndex) {
            moveToNextStep();
          } else {
            showError(context);
          }
        },
        child: Text(step.options[optionIndex], style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void moveToNextStep() {
    setState(() {
      if (currentStep < widget.recipe.stepScenarios.length - 1) {
        currentStep++;
        _controller.reset();  // Reset the animation for the new step
        _controller.forward();
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

  String getBackgroundImageForRecipe(String recipeName) {
    switch (recipeName) {
      case 'Classic Pasta':
        return 'assets/pasta_bg.jpg';  // Add image for pasta
      case 'Spaghetti Bolognese':
        return 'assets/bolognese_bg.jpg';  // Add image for Bolognese
      case 'Alfredo Pasta':
        return 'assets/alfredo_bg.jpg';  // Add image for Alfredo
      default:
        return 'assets/default_bg.jpg';  // Default image
    }
  }
}