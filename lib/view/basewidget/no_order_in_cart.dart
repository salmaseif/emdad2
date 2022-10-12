import 'package:connectivity/connectivity.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/requstOrder/order_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';

class NoOrderInCartScreen extends StatelessWidget {
  final bool isNoInternet;
  final Widget child;
  NoOrderInCartScreen({@required this.isNoInternet, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/no_items.jpg"),
        fit: BoxFit.cover,
        ),
        ),
        child:Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                CustomButton(
                    buttonText: 'اطلب منتجك الأن',
                    onTap: () {
                      showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => OrderBottomSheet(callback: (){
                        showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                      },));
                    }),
                /*
              OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => OrderBottomSheet(callback: (){
                      showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                    },));
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorResources.primaryColor.withOpacity(0.8),
                      ),
                      child: Text('اطلب منتجك الأن',
                          style: robotoRegular.copyWith(color: ColorResources.getTextTitle(context))
                      )
                  ),
                ),
               */

                SizedBox(height: 40),
                isNoInternet ? Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ColorResources.getYellow(context)),
                  child: TextButton(
                    onPressed: () async {
                      if(await Connectivity().checkConnectivity() != ConnectivityResult.none) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => child));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(getTranslated('RETRY', context), style: titilliumSemiBold.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ),
                  ),
                ) : SizedBox.shrink(),

          ],
        ),
      ),
      ),
    );
  }
}
