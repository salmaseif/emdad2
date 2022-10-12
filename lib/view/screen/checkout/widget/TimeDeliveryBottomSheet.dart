import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/styles.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class TimeDeliveryBottomSheet extends StatefulWidget {
  final String groupId;
  final int sellerId;
  final int sellerIndex;
  TimeDeliveryBottomSheet({@required this.groupId, @required this.sellerId, @required this.sellerIndex});

  @override
  _TimeDeliveryBottomSheetState createState() => _TimeDeliveryBottomSheetState();
}

class _TimeDeliveryBottomSheetState extends State<TimeDeliveryBottomSheet> {
  int selectedDate = -1;
  bool isChecked = false;
  bool isMorning = true;

  bool isVoiceCall = true;
  bool isMessage = false;
  bool isVideoCall = false;

  bool isTime = false;

  int timeSelectedIndex = -1;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  List weekdays = [
    'السبت',
    'الاحد',
    'الاثنين',
    'الثلاثاء',
    'الاربعاء',
    'الخمسي',
    'الجمعة'
  ];

  List timeToDelivery = [
    'من 8 الى 12 صباحاً',
    'من 5 الى 9 مساء',
  ];

  @override
  void initState() {
    //Provider.of<CartProvider>(context,listen: false).getShippingMethod(context, widget.cart.sellerId,widget.sellerIndex);
    timeSelectedIndex = Provider.of<OrderProvider>(context, listen: false).timeDeliveryIndex;
    selectedDate = Provider.of<OrderProvider>(context, listen: false).dayDeliveryDataIndex;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height *0.60,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Column( mainAxisSize: MainAxisSize.min, children: [

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).highlightColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 1, blurRadius: 10)]),
                  child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
                ),
              ),
            ),

            Text(getTranslated('chooseTime', context), style: titilliumSemiBold.copyWith(fontSize: 20)),
            Container(
              margin: EdgeInsets.only(right: Dimensions.MARGIN_SIZE_DEFAULT, left: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Text("إختار اليوم",
                style: khulaSemiBold.copyWith(color: ColorResources.COLOR_GREY, fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: weekdays.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = index;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/4,
                    height: 60,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: selectedDate == index ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_WHITE,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(weekdays[index].toString(),
                            style: khulaSemiBold.copyWith(
                              color: selectedDate == index ? ColorResources.COLOR_WHITE : ColorResources.COLOR_GREY, fontSize: 20
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: Dimensions.MARGIN_SIZE_DEFAULT, left: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Text("إختر الوقت",
                style: khulaSemiBold.copyWith(color: ColorResources.COLOR_GREY, fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: timeToDelivery.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      timeSelectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.47,
                    decoration: BoxDecoration(
                      color: timeSelectedIndex == index ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_WHITE,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(timeToDelivery[index].toString(),
                            style: robotoHintRegular.copyWith(
                                color: timeSelectedIndex == index ? ColorResources.COLOR_WHITE : ColorResources.COLOR_GREY,
                            ) ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Provider.of<OrderProvider>(context).isLoadingTime
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                : Builder(
                 key: _scaffoldKey,
                 builder: (context) => CustomButton(
                  buttonText: getTranslated('NEXT', context),
                  onTap: () {
                    if (selectedDate == -1) {
                      showCustomSnackBarOrder('يجب اختيار اليوم والوقت', context, isError: false);
                    } else if (timeSelectedIndex == -1) {
                      showCustomSnackBarOrder('يجب اختيار اليوم والوقت', context, isError: false);
                    } else {
                      Provider.of<OrderProvider>(context, listen: false).setDeliveryTimeInfo(context, timeSelectedIndex, selectedDate, timeToDelivery[timeSelectedIndex].toString(), weekdays[selectedDate].toString());
                      Provider.of<OrderProvider>(context, listen: false).setDeliveryTime();
                      Navigator.pop(context);
                    }
                  }),
            ),
          ]),
        );
  }
}
