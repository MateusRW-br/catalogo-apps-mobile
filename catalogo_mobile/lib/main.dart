import 'package:flutter/material.dart';
import 'pesquisar_apps/pesquisar_apps.dart';

void main() {
  runApp(const ButiaAppsApp());
}

class ButiaAppsApp extends StatelessWidget {
  const ButiaAppsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3CE86B),
      primary: const Color(0xFF1B8A3D),
      primaryContainer: const Color(0xFF3CE86B),
      onPrimaryContainer: const Color(0xFF0A2E14),
      secondary: const Color(0xFFF28C28),
      secondaryContainer: const Color(0xFFFFE5CC),
      onSecondaryContainer: const Color(0xFF4A2500),
      tertiary: const Color(0xFFDCE043),
      surface: Colors.white,
      surfaceContainerLow: const Color(0xFFF7FBF8),
      surfaceContainer: const Color(0xFFF0F6F1),
    );

    return MaterialApp(
      title: 'Butiápps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7FBF8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF3CE86B),
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shadowColor: Colors.black26,
          height: 72,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A2E14),
              );
            }
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF0A2E14), size: 26);
            }
            return IconThemeData(color: Colors.grey.shade700, size: 24);
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFF3CE86B), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFF1B8A3D), width: 2),
          ),
        ),
      ),
      home: const PesquisarAppsPage(),
    );
  }
}