import 'package:flutter/material.dart';
import 'RecipeListScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kitchen.gif'), // Background GIF
                fit: BoxFit.cover, // Makes the gif cover the entire screen
              ),
            ),
          ),
          // Optional tint to make text more readable over the gif
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3), // Tint over background
          ),
          // Content (Text, Circular Image, Button)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular home image
                ClipOval(
                  child: Image.asset(
                    'assets/home_image.jpg', // The circular home image
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to weCooked!',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Learn recipes through fun, interactive scenarios. Test your knowledge about ingredients and steps as you go!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
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
                  child: Text(
                    'Start Cooking',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2F4F4F), // Dark green or gray for text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA8D5BA), // Soft green button background
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                )
                ,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
