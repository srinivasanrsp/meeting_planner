import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String PATTERN_SERVER_DATE_TIME = "dd-MM-yyyy HH:mm";
  static const String PATTERN_DMY = "dd/MM/yyyy";
  static const String PATTERN_H24M = "HH:mm";
  static const String PATTERN_H12MA = "hh:mm a";
  static const String PATTERN_DMY_H12MA = "dd/MM/yyyy HH:mm a";
  static const String PATTERN_HM = "HH:mm";

  static DateTime getLocalDateTimeFromServer(String dateTimeStr,
      {String inputPattern = PATTERN_SERVER_DATE_TIME}) {
    return DateFormat(inputPattern).parse(dateTimeStr, true).toLocal();
  }

  static String getLocalDateTimeFromServerDateTime(DateTime dateTime,
      {String dateFormat = PATTERN_SERVER_DATE_TIME}) {
    dateTime = dateTime.toLocal();
    return DateFormat(dateFormat).format(dateTime);
  }

  static String covertToServerDateTime(DateTime dateTime, String inputFormat) {
    DateTime utcTime = dateTime.toUtc();
    return DateFormat(PATTERN_SERVER_DATE_TIME).format(utcTime);
  }

  static DateTime covertToServerDateTimeFromDateString(
      String dateTimeStr, String inputFormat) {
    return DateFormat(inputFormat).parse(dateTimeStr).toUtc();
  }

  static int getDurationInMinutes(DateTime startTime, DateTime endTime) {
    return startTime.difference(endTime).inMinutes;
  }
}
