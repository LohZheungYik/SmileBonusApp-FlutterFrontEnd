import 'package:flutter/material.dart';

class WinkTheme {
  static final Color color = Color.fromRGBO(233, 51, 150, 1);
  static final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: color);

  static final blackText = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  );

  static final blackText2 = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  );

  static var pinkText = TextStyle(
    color: WinkTheme.color,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  );

  static var blackHeaderText = TextStyle(
    color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  );

  static InputDecoration inputStyle(String label, var icon) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: WinkTheme.color,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.white, // Change error text color
        fontSize: 14, // Change error text size
        fontWeight: FontWeight.bold, // Make it bold
        fontFamily: 'Roboto', // Change font family
      ),
    );
  }

  static InputDecoration hpInputStyle(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: WinkTheme.color,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            "+65",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.white, // Change error text color
        fontSize: 14, // Change error text size
        fontWeight: FontWeight.bold, // Make it bold
        fontFamily: 'Roboto', // Change font family
      ),
    );
  }

  static final themeData = ThemeData(
    colorScheme: colorScheme,
    buttonTheme: ButtonThemeData(buttonColor: color, hoverColor: color),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: color,
      foregroundColor: Colors.white,
      toolbarHeight: 80,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(color: color),
      unselectedIconTheme: IconThemeData(color: color),
      selectedLabelStyle: TextStyle(color: color),
      unselectedLabelStyle: TextStyle(color: color),
      selectedItemColor: color,
      unselectedItemColor: color,
    ),
  );
}
