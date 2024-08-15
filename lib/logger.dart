import 'package:logger/logger.dart';
import 'dart:io';

class LogService {
  late Logger logger;
  final String logFilePath = 'E:\\FlutterProjects\\mynewproject4\\logs\\app_logs.txt';

  LogService() {
    var customPrinter = PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    );
    logger = Logger(printer: customPrinter);

    // Ensure the log directory exists
    _createLogDirectory();
  }

  Future<void> _createLogDirectory() async {
    final directory = Directory('E:\\FlutterProjects\\mynewproject4\\logs');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  Future<void> logToFile(String message, Level level) async {
    try {
      final file = File(logFilePath);
      final timestamp = DateTime.now().toIso8601String();

      final logMessage = '[$timestamp] [${level.toString().toUpperCase()}] $message\n';

      await file.writeAsString(logMessage, mode: FileMode.append, flush: true);
    } catch (e) {
      logger.e('Failed to log to file: $e');
    }
  }

  void debug(String message) {
    logger.d(message);
    logToFile(message, Level.debug);
  }

  void info(String message) {
    logger.i(message);
    logToFile(message, Level.info);
  }

  void warning(String message) {
    logger.w(message);
    logToFile(message, Level.warning);
  }

  void error(String message) {
    logger.e(message);
    logToFile(message, Level.error);
  }

  void wtf(String message) {
    logger.wtf(message);
    logToFile(message, Level.wtf);
  }
}
