import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:emdad/utility/dimensions.dart';


Widget authHeaderWidget({BuildContext context, String title, String subTitle}) {
  return Container(
    margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT,right: Dimensions.PADDING_SIZE_DEFAULT),
    child: Column(
      children: [
        Text(title, style: khulaBold.copyWith(fontSize: 25, color: ColorResources.COLOR_LIGHT_BLACK)),
        SizedBox(height: 5),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: poppinsRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_SMALL),
        ),
      ],
    ),
  );
}
