import 'package:flutter/material.dart'; // Import the material design package
import 'welcome_screen.dart'; // Import the welcome screen

// The main function is the entry point of the app
void main() {
  runApp(const MyApp()); // Runs the app by creating an instance of MyApp
}

// MyApp is a stateless widget that serves as the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // The build method creates the widget tree
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'ToDo App', // Sets the title of the app
      theme: ThemeData(
        brightness: Brightness.dark, // Sets the overall theme to dark mode
        scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Background color of the app
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 65, 65, 105), // Background color of the AppBar
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6C63FF), // Color of FloatingActionButtons
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Text color of TextButtons
            backgroundColor: const Color(0xFF6C63FF), // Background color of TextButtons
          ),
        ),
        cardColor: const Color(0xFF2D2D44), // Background color of Cards
      ),
      home: const WelcomeScreen(), // Sets the home screen to WelcomeScreen
    );
  }
}
