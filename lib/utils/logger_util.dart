import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class LoggerUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
