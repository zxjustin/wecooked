import 'package:audioplayers/audioplayers.dart';
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
  late AudioPlayer audioPlayer;
  late Animation<double> buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    audioPlayer = AudioPlayer();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return _buildCompletionScreen();
    }

    StepScenario step = widget.recipe.stepScenarios[currentStep];

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackgroundImageForRecipe(widget.recipe.name)),
            fit: BoxFit.cover, // Ensure the image covers the entire container
          ),
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.5), Colors.white.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProgressIndicator(),
            SizedBox(height: 20),
            Text(step.question, style: TextStyle(fontSize: 22, color: Colors.white)),
            SizedBox(height: 20),
            ScaleTransition(
              scale: buttonScaleAnimation,
              child: _buildOptionButton(step, 0),
            ),
            SizedBox(height: 10),
            ScaleTransition(
              scale: buttonScaleAnimation,
              child: _buildOptionButton(step, 1),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCompletionScreen() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/congrats_image.jpg',
                width: 500,
                height: 500,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                "Congratulations! You've completed the recipe.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (currentStep + 1) / widget.recipe.stepScenarios.length,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  Widget _buildOptionButton(StepScenario step, int optionIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      onPressed: () => _handleOptionSelected(step, optionIndex),
      child: Text(step.options[optionIndex], style: TextStyle(fontSize: 18)),
    );
  }

  void _handleOptionSelected(StepScenario step, int optionIndex) {
    if (step.correctOptionIndex == optionIndex) {
      _controller.forward(from: 0.0);
      _playSound('correct.mp3');
      _moveToNextStep();
    } else {
      _controller.forward(from: 0.0);
      _playSound('wrong.mp3');
      _showError();
    }
  }

  void _moveToNextStep() {
    setState(() {
      if (currentStep < widget.recipe.stepScenarios.length - 1) {
        currentStep++;
      } else {
        completed = true;
      }
    });
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wrong Choice, Try again!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _playSound(String filePath) async {
    try {
      await audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  String getBackgroundImageForRecipe(String recipeName) {
    switch (recipeName) {
      case 'Classic Pasta':
        return 'assets/pasta_bg.jpg';
      case 'Spaghetti Bolognese':
        return 'assets/bolognese_bg.jpg';
      case 'Alfredo Pasta':
        return 'assets/alfredo_bg.jpg';
      default:
        return 'assets/default_bg.jpg';
    }
  }
}
