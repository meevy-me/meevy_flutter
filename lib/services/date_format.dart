import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, {String? pattern}) {
  return DateFormat(pattern).format(dateTime);
}
