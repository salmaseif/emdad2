import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
class PromiseScreen extends StatelessWidget {
  const PromiseScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double  width = MediaQuery.of(context).size.width/8.5;
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Expanded(
        child: Column(children: [
          Container(width: width,
          child: Image.asset(Images.seven_day_easy_return),),
          Text(getTranslated('seven_days_return', context),maxLines: 1,
            overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
        ],),
      ),
      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
        Expanded(
        child: Column(children: [
          Container(width: width,
            child: Image.asset(Images.safe_payment),),
          Text(getTranslated('safe_payment', context),
              maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
        ],),
      ),
      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
        Expanded(
        child: Column(children: [
          Container(width: width,
            child: Image.asset(Images.hundred_par_authentic),),
          Text(getTranslated('authentic_product', context),
            maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
        ],),
      ),
    ],);
  }
}
