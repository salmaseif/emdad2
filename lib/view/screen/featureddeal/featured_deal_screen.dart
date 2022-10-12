import 'package:flutter/material.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/featured_deal_provider.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/custom_app_bar.dart';
import 'package:emdad/view/screen/home/widget/featured_deal_view.dart';
import 'package:provider/provider.dart';

class FeaturedDealScreen extends StatefulWidget {
  @override
  State<FeaturedDealScreen> createState() => _FeaturedDealScreenState();
}

class _FeaturedDealScreenState extends State<FeaturedDealScreen> {

  void initState() {
    super.initState();
    Provider.of<FeaturedDealProvider>(context, listen: false).getFeaturedDealList(true, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: getTranslated('featured_deals', context)),

        Expanded(child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<FeaturedDealProvider>(context, listen: false).getFeaturedDealList(true, context);
          },
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: FeaturedDealsView(isHomePage: false),
          ),
        )),

      ]),
    );
  }
}
