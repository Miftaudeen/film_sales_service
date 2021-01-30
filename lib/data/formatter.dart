import 'package:flutter_currency_formatter/flutter_currency_formatter.dart';

class Formatter {
  static List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  static List<String> weekList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  static String getInMonthName(DateTime dateTime) {
    return dateTime.day.toString() +
        "-" +
        getMonth(dateTime.month) +
        "-" +
        dateTime.year.toString();
  }

  static String getWeekName(int number) {
    return weekList[number - 1];
  }

  static String getMonth(int number) {
    return monthList[number - 1];
  }

  static String getTime(DateTime date) {
    if ((date.hour + 1) == 0 && (date.minute + 1) == 0) {
      return "12:00 am";
    }
    return "${((date.hour + 1) % 12).toString().padLeft(2, '0')}:${(date.minute).toString().padLeft(2, '0')} ${(date.hour + 1) / 12 < 1 ? 'am' : 'pm'}";
  }

  static String getStringTime(String time) {
    List<String> times = time.split(":");
    return "${int.parse(times[0].trim().padLeft(2, '0')) % 12}:${times[1].trim().padLeft(2, '0')} ${int.parse(times[0].trim().padLeft(2, '0')) / 12 < 1 ? 'am' : 'pm'}";
  }

  static String getAgo(String timestamp) {
    int time = DateTime.now()
        .difference(DateTime.parse(timestamp.toString()))
        .inMinutes;
    String ago;
    if ((time ~/ 60) < 1) {
      ago = time.toString() + "m ago";
    } else if ((time ~/ 60) < 24) {
      ago = (time ~/ 60).toString() + "h ago";
    } else if ((time ~/ (60 * 24)) < 31) {
      ago = (time ~/ (60 * 24)).toString() + "d ago";
    } else {
      ago = getInMonthName(DateTime.parse(timestamp));
    }
    return ago;
  }

  static Duration getCountdown(String timestamp) {
    Duration time =
        DateTime.parse(timestamp.toString()).difference(DateTime.now());

    return time;
  }

  static String getInNaira(String money) {
    return FlutterMoneyFormatter(
            amount: double.parse(money),
            settings:
                MoneyFormatterSettings(symbol: "N", decimalSeparator: "."))
        .output
        .symbolOnLeft;
  }

  static String getDateAndTime(String s) {
    DateTime dateTime = DateTime.parse(s);

    return "${dateTime.day.toString()}-${monthList[dateTime.month - 1]}-${dateTime.year.toString()} ${(dateTime.hour + 1) % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${(dateTime.hour + 1) / 12 < 1 ? 'am' : 'pm'}";
  }

  static String getLocalDateAndTime(String s) {
    DateTime dateTime = DateTime.parse(s);

    return "${dateTime.day.toString()}-${monthList[dateTime.month - 1]}-${dateTime.year.toString()} ${(dateTime.hour) % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${(dateTime.hour) / 12 < 1 ? 'am' : 'pm'}";
  }

  static String getPosition(int i) {
    if ([11, 12, 13].contains(i)) {
      return "${i}th";
    }
    switch (i % 10) {
      case 1:
        return "${i}st";
        break;
      case 2:
        return "${i}nd";
        break;
      case 3:
        return "${i}rd";
        break;
      default:
        return "${i}th";
    }
  }

  static String getAPITime(DateTime date) {
    return "${(date.hour).toString().padLeft(2, '0')}:${(date.minute).toString().padLeft(2, '0')}:${(date.second).toString().padLeft(2, '0')}";
  }

  static getDate(String date) {
    List<String> dateItems = date.split("-");
    return "${dateItems[2]}-${monthList[int.parse(dateItems[1]) - 1]}-${dateItems[0]}";
  }
}
