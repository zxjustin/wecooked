import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'RecipeListScreen.dart';
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
        backgroundColor: Color(0xFFA8D5BA),
      ),
      body: Stack(
        children: [
          // Background GIF
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cooking.gif'), // Background GIF
                fit: BoxFit.cover, // Makes the GIF cover the entire screen
              ),
            ),
          ),
          // Optional tint to make text/buttons more readable
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
          ),
          // The rest of the UI
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular recipe image
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
        ],
      ),
    );
  }

  Widget _buildCircularRecipeImage() {
    return Center(
      child: ClipOval(
        child: Container(
          color: Colors.white, // Adding white border for better contrast
          padding: EdgeInsets.all(8),
          child: Image.asset(
            getBackgroundImageForRecipe(widget.recipe.name),
            height: 400,  // Increased size for visibility
            width: 400,   // Width slightly larger for better display
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        backgroundColor: Color(0xFFA8D5BA), // Matching app theme color
      ),
      body: Stack(
        children: [
          // Background GIF
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kitchen.gif'), // Background GIF
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3), // Tint over background
          ),
          // Completion message, image, and button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular congratulation image
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
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeListScreen()),
                    );
                  },
                  child: Text("Try Other Recipes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA8D5BA), // Match the theme
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (currentStep + 1) / widget.recipe.stepScenarios.length,
      backgroundColor: Colors.white.withOpacity(0.5),
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA8D5BA)),
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
          if (step.options.length > 2) SizedBox(height: 15),
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
        foregroundColor: Color(0xFF2F4F4F), // Dark text color
        backgroundColor: Color(0xFFA8D5BA), // Soft green button background
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
    if (step.isFlexible) {
      // For flexible questions, provide feedback and move to the next step
      _showFlexibleFeedback();
      _moveToNextStep(); // Move to the next step after a flexible choice
    } else {
      // For strict questions, check against correctOptionIndex
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
  }


  void _showFlexibleFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Good choice!'),
        backgroundColor: Colors.green,
      ),
    );
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
