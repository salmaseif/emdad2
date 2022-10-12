import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerifiedBottomSheet extends StatefulWidget {
  final String groupId;
  final int sellerId;
  final int sellerIndex;
  PhoneVerifiedBottomSheet({@required this.groupId, @required this.sellerId, @required this.sellerIndex});

  @override
  _PhoneVerifiedBottomSheetState createState() => _PhoneVerifiedBottomSheetState();
}

class _PhoneVerifiedBottomSheetState extends State<PhoneVerifiedBottomSheet> {
  int selectedDate = -1;
  bool isChecked = false;
  bool isMorning = true;

  bool isVoiceCall = true;
  bool isMessage = false;
  bool isVideoCall = false;

  bool isTime = false;

  int timeSelectedIndex = 0;
  int phoneIndex = 0;

  @override
  void initState() {
    //Provider.of<CartProvider>(context,listen: false).getShippingMethod(context, widget.cart.sellerId,widget.sellerIndex);
    Provider.of<AuthProvider>(context, listen: false).checkPhoneOrder(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone);   super.initState();
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

        Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                              Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ==null?
                              '${getTranslated('please_enter_4_digit_code', context)}':
                              '${getTranslated('please_enter_4_digit_code', context)}',
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 10),
                        child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor: ColorResources.getSearchBg(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor: ColorResources.getSearchBg(context),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),

                      Center(
                          child: Text(getTranslated('i_didnt_receive_the_code', context),)),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Provider.of<AuthProvider>(context, listen: false).checkPhoneOrder(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone).then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBar('Resent code successful', context, isError: false);
                              } else {
                                showCustomSnackBar(value.message, context);
                              }
                            });

                          },
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              getTranslated('resend_code', context),

                            ),
                          ),
                        ),
                      ),
                       !authProvider.isPhoneNumberVerificationButtonLoading
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: CustomButton(
                             buttonText: getTranslated('verify', context),

                             onTap: () {
                                Provider.of<AuthProvider>(context, listen: false).verifyPhoneOrder(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone).then((value) async {
                                  if(value.isSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم تاكيد الطلب إضغط ارسال الطلب'),backgroundColor: Colors.green,)
                                    );
                                    Provider.of<OrderProvider>(context, listen: false).setConfirmPhone();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("تاكد من ادخال الرمز بشكل صحيح"),backgroundColor: Colors.green,)
                                    );
                                  }
                                });
                          },
                        ),
                      )
                          :  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
