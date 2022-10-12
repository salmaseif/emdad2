import 'package:emdad/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';


class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  NoDataScreen({this.isCart = false, this.isNothing = false, this.isOrder = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

        Image.asset(isOrder ? Images.clock : isCart ? Images.shopping_cart : Images.binoculars, width: 150, height: 150, color: Theme.of(context).primaryColor),
        SizedBox(height: 30),

        Text(
          getTranslated(isOrder ? 'no_order_history_available' : isCart ? 'empty_cart' : 'nothing_found', context),
          style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),

        Text(
          isOrder ? getTranslated('buy_something_to_see', context) : isCart ? getTranslated('look_like_have_not_added', context) : '',
          style: rubikMedium, textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}
