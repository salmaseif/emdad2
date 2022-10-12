import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/Palette.dart';
import 'package:emdad/utility/app_strings.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


/// Helper class for device related operations.
///
class DeviceUtils {

  ///
  /// hides the keyboard if its already open
  ///
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// orientation
  ///
  static double getScaledSize(BuildContext context, double scale) =>
      scale *
          (MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height);

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// width
  ///
  static double getScaledWidth(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.width;

  ///
  /// accepts a double [scale] and returns scaled sized based on the screen
  /// height
  ///
  static double getScaledHeight(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.height;

  static Function get err => () => Get.snackbar('Error Title', 'Failed: Change Theme');

  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Theme.of(Get.context).errorColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
    );
  }

  static bool isValidEmail(String value) {
    final emailRegExp =  RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    return emailRegExp.hasMatch(value);
  }


  static Future<bool> checkNetwork() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      toastMessage("No Internet Connection");
      return false;
    }
  }

  static Future<bool> checkServiceEnable() async {
    var isEnable = await Geolocator.isLocationServiceEnabled();
    return isEnable;
  }

  static toastMessage(String msg) {

  }

  static checkForPermission() async {

    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){

      permission = await Geolocator.requestPermission();
      print("denied");
      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());


    }else if(permission == LocationPermission.whileInUse){
      print("whileInUse56362");

      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());
      //  Constants.currentlatlong().whenComplete(() => Constants.currentlatlong().then((value){print("origin123:$value");}));
      //  Constants.cuttentlocation().whenComplete(() => Constants.cuttentlocation().then((value){}));

    }else if(permission == LocationPermission.always){

      print("always");
      // Constants.CheckNetwork().whenComplete(() =>    callApiForsetting());
      //Constants.currentlatlong().whenComplete(() => Constants.currentlatlong().then((value){print("origin123:$value");}));
      //  Constants.cuttentlocation().whenComplete(() => Constants.cuttentlocation().then((value){}));

    }




  }

  static Widget showProgress(isShowProgress) {
    return ModalProgressHUD(
      inAsyncCall: isShowProgress,
      color: Colors.transparent,
      progressIndicator: SpinKitFadingCircle(color: Palette.green),
      child: Container(),
    );
  }

  static void displayAlert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(0),
                color: Palette.loginhead,
                child: Center(
                    child: Text(
                      'اشعار مهم',
                      style: TextStyle(
                          fontFamily: proxima_nova_bold,
                          color: Colors.white,
                          fontSize: 14),
                    )),
              ),
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  //height: MediaQuery.of(context).size.height / 2.5,
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              getTranslated('coming_soon', context),
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 16,
                                  fontFamily: proxima_nova_bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Palette.green),
              child: Text(
                'تمام',
                style: TextStyle(
                    fontFamily: proxima_nova_bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          ],
        );
      },
    );
  }

}