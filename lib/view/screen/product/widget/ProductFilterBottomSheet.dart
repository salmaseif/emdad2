
import 'package:emdad/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/search_provider.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';

class ProductFilterBottomSheet extends StatefulWidget {
  @override
  _ProductFilterBottomSheetState createState() => _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet> {
  final TextEditingController _firstPriceController = TextEditingController();
  //final FocusNode _firstFocus = FocusNode();
  //final TextEditingController _lastPriceController = TextEditingController();
  //final FocusNode _lastFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Consumer<SearchProvider>(
          builder: (context, search, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getTranslated('SORT_BY', context),
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
              Divider(),

              MyCheckBox(title: getTranslated('productFeature', context), index: 1),
              MyCheckBox(title: getTranslated('low_to_high_price', context), index: 2),
              MyCheckBox(title: getTranslated('high_to_low_price', context), index: 3),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  height: MediaQuery.of(context).size.width /6,
                child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /2.5,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              border: Border.all(width: 0.5,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              getTranslated('cancel', context),
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /2.5,
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {
                            Provider.of<ProductProvider>(context, listen: false).sortProductList();
                            Navigator.pop(context);
                            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(width: 0.5,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              getTranslated('goOn', context),
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).highlightColor,),
                            ),
                          ),
                        ),

                      ),
                    ])
              ),
            ],
          ),
        ),

      ]),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final String title;
  final int index;
  MyCheckBox({@required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
      checkColor: Theme.of(context).primaryColor,
      activeColor: Colors.transparent,
      value: Provider.of<ProductProvider>(context).filterIndex == index,
      onChanged: (isChecked) {
        if(isChecked) {
          Provider.of<ProductProvider>(context, listen: false).setFilterIndex(index);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

