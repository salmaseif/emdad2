import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:emdad/provider/brand_provider.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/home_category_product_provider.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/view/screen/auth/auth_phone_screen.dart';
import 'package:emdad/view/screen/tread_info/treadInfo.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/view/basewidget/no_internet_screen.dart';
import 'package:emdad/view/screen/dashboard/dashboard_screen.dart';
import 'package:emdad/view/screen/maintenance/maintenance_screen.dart';
import 'package:emdad/view/screen/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getAddressInfo();
    Provider.of<AuthProvider>(context, listen: false).getTreadInfo();
    setState(() {});
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((bool isSuccess) {
      if(isSuccess) {
        Provider.of<SplashProvider>(context, listen: false).initSharedPrefData();
        Timer(Duration(seconds: 1), () {
           if (Provider.of<AuthProvider>(context, listen: false).treadInfoPageCheck == true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => TreadInfo(start: false)));
          } else if (Provider.of<SplashProvider>(context, listen: false).configModel.maintenanceMode) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MaintenanceScreen()));
          } else {
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken(context);
              print('=========>Device Token splash======');
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DashBoardScreen()));
            } else {
              if (!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) =>
                        OnBoardingScreen(indicatorColor: ColorResources.GREY, selectedIndicatorColor: Theme.of(context).primaryColor,)));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AuthPhoneScreen()));
              }
            }
          }
        });
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
        Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
        Provider.of<HomeCategoryProductProvider>(context, listen: false).getHomeCategoryProductList(true, context);
        Provider.of<CategoryProvider>(context, listen: false).getCategoryList(false, context);
        Provider.of<ProductProvider>(context, listen: false).getCategoryListForMe(context);
        Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context);
        Provider.of<ProductProvider>(context, listen: false).getRecommendedProduct(context);
        Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, '1', context);
        Provider.of<BrandProvider>(context, listen: false).getBrandList(false, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection ? Stack(
        clipBehavior: Clip.none, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
            child: Center(
              child: Image.asset('assets/images/background.png'),
            ),
          ),
        ],
      ) : NoInternetOrDataScreen(isNoInternet: true, child: SplashScreen()),
    );
  }

}
