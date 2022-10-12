import 'dart:async';

import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/view/screen/address/add_first_address_screen.dart';
import 'package:emdad/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/auth/widget/reset_password_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatefulWidget {
  final String tempToken;
  final String mobileNumber;
  final String email;


  VerificationScreen(this.tempToken, this.mobileNumber, this.email);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> with TickerProviderStateMixin{

  Timer _timer;
  int _start = 30;

  @override
  void initState() {
    //on Splash Screen hide statusbar
    _start = 30;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=======Mobile Number=====>${widget.mobileNumber}');
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 55),
                      Image.asset(
                        Images.login,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                              widget.email==null?
                              '${getTranslated('please_enter_4_digit_code', context)}\n${widget.mobileNumber}':
                              '${getTranslated('please_enter_4_digit_code', context)}\n${widget.email}',
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
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
                      ),
                      Center(
                          child: Text(getTranslated('i_didnt_receive_the_code', context),)),
                      _start == 0
                          ? Center(
                            child: InkWell(
                              onTap: () {
                                Provider.of<AuthProvider>(context, listen: false).checkPhone(widget.mobileNumber,widget.tempToken).then((value) {
                                  if (value.isSuccess) {
                                    showCustomSnackBar('Resent code successful', context, isError: false);
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                                startTimer();
                                setState(() {
                                  _start = 30;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Text(
                                  getTranslated('resend_code', context),
                                ),
                              ),
                            ),
                          )
                      : Padding(
                        padding: const EdgeInsets.all(40),
                        child: InkWell(
                          onTap: (){
                            showCustomSnackBar("الرجاء الإنتظار حتي يتنهي العد التنازلي ", context);
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(right: 30, left: 30),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorResources.COLOR_BLACK, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Text(_start.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorResources.COLOR_BLACK,
                                    decoration: TextDecoration.underline,
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      authProvider.isEnableVerificationCode
                          ? !authProvider.isPhoneNumberVerificationButtonLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                buttonText: getTranslated('verify', context),
                                onTap: () {
                                  bool phoneVerification = Provider.of<SplashProvider>(context,listen: false).configModel.forgetPasswordVerification =='phone';
                                  if(phoneVerification){
                                    Provider.of<AuthProvider>(context, listen: false).verifyOtp(widget.mobileNumber).then((value) {
                                      if(value.isSuccess) {
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => ResetPasswordWidget(mobileNumber: widget.mobileNumber,otp: authProvider.verificationCode)), (route) => false);
                                        }else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(getTranslated('input_valid_otp', context)),backgroundColor: Colors.red,)
                                        );
                                      }
                                    });
                                  } else{
                                    if(Provider.of<SplashProvider>(context,listen: false).configModel.phoneVerification){
                                      Provider.of<AuthProvider>(context, listen: false).verifyPhone(widget.mobileNumber,widget.tempToken).then((value) async {
                                        if(value.isSuccess) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(getTranslated('sign_up_successfully_now_login', context)),backgroundColor: Colors.green,)
                                          );
                                          await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                                          int isDoc = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isDoc;
                                          int isComplete = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isComplete;
                                          if (isComplete == 0) {
                                            Provider.of<AuthProvider>(context, listen: false).setAddressInfo();
                                            Provider.of<AuthProvider>(context, listen: false).setTreadInfo();
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddFirstAddressScreen(isEnableUpdate: false)));
                                          } else {
                                            Provider.of<AuthProvider>(context, listen: false).setAddressInfo();
                                            Provider.of<AuthProvider>(context, listen: false).setTreadInfo();
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
                                          }
                                        }else {
                                          print(value.message);
                                          showCustomSnackBar(value.message, context);
                                        }
                                      });
                                    }
                                    else{
                                      Provider.of<AuthProvider>(context, listen: false).verifyEmail(widget.email,widget.tempToken).then((value) async {
                                        if(value.isSuccess) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(getTranslated('sign_up_successfully_now_login', context)),backgroundColor: Colors.green,)
                                          );
                                          await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                                          int isComplete = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isComplete;
                                          if (isComplete == 0) {
                                            Provider.of<AuthProvider>(context, listen: false).setAddressInfo();
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddFirstAddressScreen()));
                                          } else {
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
                                          }
                                        }else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(value.message),backgroundColor: Colors.red)
                                          );
                                        }
                                      });
                                    }
                                  }
                                },
                              ),
                            )
                          :  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                          : SizedBox.shrink(),
                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "  في حال لم يصلك رمز التحقق على الواتساب ",
                          style: TextStyle(
                              color: ColorResources.COLOR_BLACK,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: (){
                            launchUrl( Uri.parse("tel:967777794438") );
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(right: 30, left: 30),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorResources.COLOR_BLACK, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child:Text("إتصل بنا",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorResources.COLOR_BLACK,
                                    fontSize: 16)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          " نعمل من أجلك على مدار 24 ساعة ",
                          style: TextStyle(
                              color: ColorResources.COLOR_BLACK,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
