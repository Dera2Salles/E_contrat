import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'E-Contrat';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const int apiTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;
  
  // Database Configuration
  static const String databaseName = 'e_contrat.db';
  static const int databaseVersion = 1;
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  
  // Colors
  static const Color primaryColor = Color(0xFF6A1B9A);
  static const Color secondaryColor = Color(0xFF9C27B0);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkError = 'Erreur de connexion. Veuillez vérifier votre connexion internet.';
  static const String apiError = 'Une erreur est survenue. Veuillez réessayer.';
  static const String databaseError = 'Une erreur est survenue lors de l\'accès à la base de données.';
} 