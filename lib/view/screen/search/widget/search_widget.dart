import 'package:emdad/utility/styles.dart';
import 'package:emdad/view/screen/search/search_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';


class SearchWidget extends StatelessWidget {
  final String hintText;
  SearchWidget({this.hintText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreenTwo())),
      child: Container(
        height: 55,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          color: ColorResources.COLOR_Lavender,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(hintText??"",style: poppinsRegular,),
            Image.asset('assets/images/logo.png',color: ColorResources.COLOR_PRIMARY,),
            //Icon(Icons.search,color: ColorResources.COLOR_CARROT_ORANGE,)
          ],
        ),
      ),
    );
  }
}
