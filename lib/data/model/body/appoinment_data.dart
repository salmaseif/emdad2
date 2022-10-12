import 'package:emdad/data/model/body/apoinment_time.dart';
import 'package:emdad/utility/strings.dart';

class AppointmentData {
  static List<ApoinmentTime> morningData = [
    ApoinmentTime(
        name: Strings.TIME_9_00_AM,
      isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_10_30_AM,
      isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_11_00_AM,
      isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_11_30_AM,
      isActive: false
    ),
  ];
  static List<ApoinmentTime> eveningData = [
    ApoinmentTime(
        name: Strings.TIME_9_00_PM,
        isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_9_30_PM,
        isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_10_00_PM,
        isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_10_30_PM,
        isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_11_00_PM,
        isActive: false
    ),
    ApoinmentTime(
        name: Strings.TIME_11_30_PM,
        isActive: false
    ),
  ];
}
