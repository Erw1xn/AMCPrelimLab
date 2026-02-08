// lib/main.dart

import 'package:flutter/material.dart';
import 'package:chat_ui_lab/screens/expert_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

// ✨ 1. Convert MyApp to a StatefulWidget to manage theme state.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ✨ 2. State variable to hold the current theme mode.
  ThemeMode _themeMode = ThemeMode.dark;

  // ✨ 3. Method to toggle the theme and rebuild the UI.
  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 4. Define light and dark themes.
    final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.blueGrey,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[600],
      ),
      // ✨ Define card color for light theme
      cardColor: Colors.white,
      // ✨ Define text and icon themes for light theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
    );

    final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.blueGrey,
      brightness: Brightness.dark,
      scaffoldBackgroundColor:
      const Color(0xFF1A2128), // A slightly softer dark background
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[900],
      ),
      // ✨ Define card color for dark theme
      cardColor: Colors.blueGrey[800],
      // ✨ Define text and icon themes for dark theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
    );

    return MaterialApp(
      title: 'Persona App',
      // ✨ 5. Apply the themes to the MaterialApp.
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode, // This controls which theme is active.
      home: HomeScreen(
        // ✨ PASS the _toggleTheme function to HomeScreen.
        toggleTheme: _toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Dashboard'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the AI Expert Chat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExpertSelectionScreen(
                      // ✨ FIX: Pass the toggleTheme function to the ExpertSelectionScreen.
                      toggleTheme: toggleTheme,
                    ),
                  ),
                );
              },
              child: const Text('Choose an Expert'),
            ),
          ],
        ),
      ),
    );
  }
}
