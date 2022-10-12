import 'package:emdad/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/screen/home/home_screen.dart';
import 'package:emdad/view/screen/more/more_screen.dart';
import 'package:emdad/view/screen/order/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;

  List<Widget> _screens ;

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    _screens = [
      HomePage(),
      OrderScreen(isBacButtonExist: false),
      //CartScreen(),
      //AllCategoryScreen(),
      MoreScreen(),
    ];
    //NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodyText1.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index) {
    return BottomNavigationBarItem(

      icon: Image.asset(
        icon, color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
        height: 25, width: 25,
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> _list = [];
    _list.add(_barItem(Images.myShop, getTranslated('market', context), 0));
    _list.add(_barItem(Images.shopping_image, getTranslated('orders', context), 2));
    //_list.add(_barItem(Images.cart_image, getTranslated('cart', context), 2));
    //_list.add(_barItem(Images.settings, getTranslated('CATEGORY', context), 2));
    _list.add(_barItem(Images.person, getTranslated('more', context), 4));
    return _list;
  }

}