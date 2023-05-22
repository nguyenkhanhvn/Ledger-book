import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime? time) {
    if(time == null) return '-';
    return DateFormat('EEEE, dd/MM/yyyy', 'vi').format(time);
  }
  static String formatShortDateTime(DateTime? time) {
    if(time == null) return '-';
    return DateFormat('dd/MM/yyyy', 'vi').format(time);
  }
}
