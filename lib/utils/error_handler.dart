import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/app_config.dart';

class ErrorHandler {
  static final _logger = Logger();

  static void handleError(dynamic error, {String? customMessage}) {
    _logger.e('Error occurred: $error');

    String message = customMessage ?? AppConfig.apiError;

    if (error is TimeoutException) {
      message = 'La requête a expiré. Veuillez réessayer.';
    } else if (error is NetworkError) {
      message = AppConfig.networkError;
    } else if (error is DatabaseError) {
      message = AppConfig.databaseError;
    }

    _showErrorToast(message);
  }

  static void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppConfig.errorColor,
      textColor: Colors.white,
    );
  }

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logWarning(String message) {
    _logger.w(message);
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}

class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);

  @override
  String toString() => message;
}

class DatabaseError implements Exception {
  final String message;
  DatabaseError(this.message);

  @override
  String toString() => message;
} 