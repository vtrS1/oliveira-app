import 'package:sentry_flutter/sentry_flutter.dart';

double? parseFloat(String value) {
  value = value.replaceAll(".", "");
  value = value.replaceAll(",", ".");
  value = value.replaceAll("R\$", "");
  try {
    return double.parse(value);
  } catch (e, stackTrace) {
    Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
    return null;
  }
}
