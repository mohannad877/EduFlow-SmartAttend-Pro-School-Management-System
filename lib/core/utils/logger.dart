import 'package:injectable/injectable.dart';

@lazySingleton
class Logger {
  static final Logger defaultLogger = Logger();

  void info(String m, [dynamic args]) {
    print('INFO: $m $args');
  }

  void warning(String m, [dynamic args]) {
    print('WARNING: $m $args');
  }

  void error(String m, [dynamic args]) {
    print('ERROR: $m $args');
  }

  void debug(String m, [dynamic args]) {
    print('DEBUG: $m $args');
  }
}
