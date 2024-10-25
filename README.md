# wecooked: Interactice Cooking Recipe App

## Project Overview
weCooked is an interactive recipe app designed to make learning new recipes fun and engaging. It guides users through each step with decision points, allowing them to select ingredients and cooking methods. The app gives feedback on correct and incorrect choices and encourages users to improve their culinary skills, unlocking more challenging recipes as they progress.

## Features
- Interactive Recipe Steps: Guided scenarios with questions and options for each recipe.
- Feedback System: Correct choices give positive feedback and sound, while incorrect choices prompt the user to try again.
- Engaging User Interface: Includes GIFs for background, animated buttons, and custom recipe images for an immersive experience.

## Getting Started
Follow these steps to set up the project on your local machine.

### Prerequisites
- Flutter SDK (version 2.0 or higher)
- Dart SDK (version 2.12 or higher)
- IDE: IntelliJ IDEA or Visual Studio Code

### Installation
- Add to pubspec.yaml file:
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.0.4
  hive_flutter: ^1.1.0
  csv: ^5.0.0
  audioplayers: ^1.0.1

flutter:
  assets:
    - assets/recipes.csv
    - assets/pasta_bg.jpg
    - assets/bolognese_bg.jpg
    - assets/alfredo_bg.jpg
    - assets/default_bg.jpg
    - assets/correct.mp3
    - assets/wrong.mp3
    - assets/congrats_image.jpg
    - assets/home_image.jpg
    - assets/kitchen.gif
    - assets/cooking.gif
    - assets/carbonara.jpg

### Launch the App: test it on an emulator 
flutter run 
