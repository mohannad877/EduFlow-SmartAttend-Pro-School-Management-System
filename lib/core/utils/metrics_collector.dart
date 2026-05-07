import 'package:injectable/injectable.dart';

@lazySingleton
class MetricsCollector {
  void record(String k, dynamic v, [Map<String, dynamic>? args]) {
    print('METRIC: $k = $v $args');
  }
  
  void increment(String metricName) {
    print('METRIC INC: $metricName');
  }
  
  void startTimer(String timerName) {
    print('METRIC TIMER START: $timerName');
  }
  
  void stopTimer(String timerName) {
    print('METRIC TIMER STOP: $timerName');
  }

  void endTimer(String timerName) => stopTimer(timerName);
}
