import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
    buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
      appBar: AppBar(
        title: Text(widget.recipe.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        // Blue and white gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],  // Blue at the top, white at the bottom
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular image made slightly bigger
            _buildCircularRecipeImage(),
            SizedBox(height: 20),
            _buildProgressIndicator(),
            SizedBox(height: 20),
            Text(
              step.question,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            _buildOptionButtons(step),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularRecipeImage() {
    return Center(
      child: ClipOval(
        child: Container(
          color: Colors.white,  // Adding white border to make it pop
          padding: EdgeInsets.all(8),
          child: Image.asset(
            getBackgroundImageForRecipe(widget.recipe.name),
            height: 400,  // Increased size
            width: 400,  // Slightly larger width for better visibility
            fit: BoxFit.cover,
          ),
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
              ClipOval(
                child: Image.asset(
                  'assets/congrats_image.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Congratulations! You've completed the recipe.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
      backgroundColor: Colors.white,  // White background for better contrast with the blue bar
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),  // Blue progress color
    );
  }

  Widget _buildOptionButtons(StepScenario step) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOptionButton(step, 0),
              _buildOptionButton(step, 1),
            ],
          ),
          if (step.options.length > 2)
            SizedBox(height: 15),
          if (step.options.length > 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(step, 2),
                if (step.options.length > 3) _buildOptionButton(step, 3),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(StepScenario step, int optionIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        elevation: 5,
      ),
      onPressed: () => _handleOptionSelected(step, optionIndex),
      child: Text(
        step.options[optionIndex],
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
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
