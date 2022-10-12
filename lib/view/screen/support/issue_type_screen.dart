
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/custom_expanded_app_bar.dart';
import 'package:emdad/view/screen/support/add_ticket_screen.dart';

class IssueTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> issueTypeList = ['مشكلة في الطلب', 'مشكلة في التوصيل', 'مشكلة في التطبيق', 'أريد توثيق حسابي', 'التوريد مع إمداد', 'سؤال عام'];


    return CustomExpandedAppBar(
      title: getTranslated('support_ticket', context),
      isGuestCheck: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Padding(
        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE, left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE),
        child: Text(getTranslated('selectTicketType', context), style: titilliumSemiBold.copyWith(fontSize: 20)),
      ),

      Expanded(child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        itemCount: issueTypeList.length,
        itemBuilder: (context, index) {
          return Container(
            color: ColorResources.getLowGreen(context),
            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            child: ListTile(
              leading: Icon(Icons.query_builder, color: ColorResources.getPrimary(context)),
              title: Text(issueTypeList[index], style: robotoBold),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AddTicketScreen(type: issueTypeList[index])));
              },
            ),
          );
        },
      )),
    ]),
    );
  }
}
