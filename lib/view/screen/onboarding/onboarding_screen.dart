import 'package:emdad/view/screen/auth/auth_phone_screen.dart';
import 'package:flutter/material.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/onboarding_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final Color indicatorColor;
  final Color selectedIndicatorColor;

  OnBoardingScreen({
    this.indicatorColor = Colors.grey,
    this.selectedIndicatorColor = Colors.black,
  });

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);


    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Provider.of<ThemeProvider>(context).darkTheme ? SizedBox() : Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(Images.background1, fit: BoxFit.fill),
          ),
          Consumer<OnBoardingProvider>(
            builder: (context, onBoardingList, child) => ListView(
              children: [
                SizedBox(
                  height: _height*0.8,
                  child: PageView.builder(
                    itemCount: onBoardingList.onBoardingList.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return  Column(
                          children: [
                            Image.asset(onBoardingList.onBoardingList[index].imageUrl, height: _height*0.8),
                          ],
                      );
                    },
                    onPageChanged: (index) {
                      onBoardingList.changeSelectIndex(index);
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _pageIndicators(onBoardingList.onBoardingList, context),
                      ),
                    ),
                    Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(horizontal: 70, vertical: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor,
                          ])),
                      child: TextButton(
                        onPressed: () {
                          if (Provider.of<OnBoardingProvider>(context, listen: false).selectedIndex == onBoardingList.onBoardingList.length - 1) {
                            Provider.of<SplashProvider>(context, listen: false).disableIntro();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPhoneScreen()));
                          } else {
                            _pageController.animateToPage(Provider.of<OnBoardingProvider>(context, listen: false).selectedIndex+1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(onBoardingList.selectedIndex == onBoardingList.onBoardingList.length - 1
                              ? getTranslated('reg_by_phone', context) : getTranslated('NEXT', context),
                              style: titilliumSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.FONT_SIZE_LARGE)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 18 : 7,
          height: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
