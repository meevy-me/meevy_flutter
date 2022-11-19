import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static void log_error(String name, Map<String, Object> parameters) {
    name = name.replaceAll(' ', '_');
    analytics.logEvent(name: name, parameters: parameters);
  }
}
