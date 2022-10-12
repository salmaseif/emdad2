
import 'package:emdad/data/model/body/dateModel.dart';
import 'package:intl/intl.dart';

class Utils {
  static String dateFormatStyle1() {
    String date = DateFormat('d').format(DateTime.now());
    String monthDay = DateFormat('MMM, EEEE').format(DateTime.now());
    return date + 'th ' + monthDay;
  }

  static String dateFormatStyle2() {
    String date = DateFormat('d MMMM, yyyy').format(DateTime.now());
    return date ;
  }

  static String monthName() {
    String date = DateFormat('MMM').format(DateTime.now());
    return date;
  }
  static String dayName(DateTime dateTime) {
    String date = DateFormat('EEE').format(dateTime);
    return date;
  }

  static List<DateModel> calculateDaysInterval() {
    var myDate= DateTime.now();
    DateTime startTime = DateTime.now();
    DateTime endDateTIme =myDate.add(Duration(days: 10,hours: 5));
    List<DateModel> days = [];
    for (int i = 0; i <= endDateTIme.difference(startTime).inDays; i++) {
      days.add(DateModel(
        day: startTime.add(Duration(days: i)).day,
        dayName: dayName(startTime.add(Duration(days: i)))
      ));
    }
    return days;
  }
}
