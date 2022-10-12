import 'package:country_code_picker/country_code_picker.dart';
import 'package:emdad/data/model/body/login_model.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/screen/auth/widget/code_picker_widget.dart';
import 'package:emdad/view/screen/auth/widget/otp_verification_screen.dart';
import 'package:emdad/view/screen/tread_info/auth_header_widget.dart';
import 'package:emdad/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:provider/provider.dart';

import '../more/widget/html_view_Screen.dart';
//import 'package:getwidget/getwidget.dart';
class AuthPhoneScreen extends StatefulWidget{
  final int initialPage;
  AuthPhoneScreen({this.initialPage = 0});

  @override
  State<AuthPhoneScreen> createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends State<AuthPhoneScreen> {
  TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneFocus = FocusNode();

  bool isEmailVerified = false;
  String _countryDialCode = "+967";
  LoginModel loginBody = LoginModel();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    Provider.of<SplashProvider>(context,listen: false).configModel;
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
    _phoneController.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail() ?? null;
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        FocusScope.of(context).requestFocus(_phoneFocus);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }


  void loginUser() async {
    if (_phoneController.text.length > 8) {
      String _phone = _countryDialCode+_phoneController.text.trim();
      Provider.of<AuthProvider>(context, listen: false).updateRemember(true);
      if (Provider.of<AuthProvider>(context, listen: false).isRemember) {
        Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
        Provider.of<AuthProvider>(context, listen: false).saveUserEmail(_phoneController.text,_phoneController.text);
      } else {
          Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
      }
      loginBody.email = _phone;
      loginBody.password = _phone;
      await Provider.of<AuthProvider>(context, listen: false).registrationOrLogin(loginBody, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ادخل رقم التلفون بشكل صحيح"),
        backgroundColor: Colors.red,
      ));
    }
  }


  route(bool isRoute, String token, String temporaryToken, String errorMessage) async {
    if (isRoute) {
      if(token==null || token.isEmpty){
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
        String _phone = _countryDialCode+_phoneController.text.trim();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => VerificationScreen(temporaryToken,_phone,'')), (route) => false);
      } else{
        await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isRemember;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // background
          Provider.of<ThemeProvider>(context).darkTheme ? SizedBox()
              : Image.asset(Images.background1, fit: BoxFit.fill, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
          Consumer<AuthProvider>(
            builder: (context, auth, child) => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  // for logo with text
                  Image.asset(Images.logo_with_name_image, height: 150, width: 200),
                  authHeaderWidget(context: context, title: "كم رقم جوالك؟", subTitle: "إدخل رقم جوالك عشان نرسل لك كود التفعيل"),
                  // for decision making section like sign in or register section
                  Padding(
                    padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_SMALL),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                          child: Row(children: [
                            Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.number,
                                  style: titleHeader,
                                  autofocus: true,
                                  maxLength: 10,

                                  decoration: InputDecoration(
                                      hintText: 'ادخل رقم تلفونك',
                                      border: InputBorder.none,
                                      hintStyle: titilliumRegular.copyWith(color: ColorResources.GAINS_BORO),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Theme.of(context).highlightColor,
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                                  ),
                            ),
                            ),
                            CodePickerWidget(
                              onChanged: (CountryCode countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              initialSelection: _countryDialCode,
                              favorite: [_countryDialCode],
                              showDropDownButton: true,
                              padding: EdgeInsets.zero,
                              showFlagMain: true,
                              textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),

                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  // for decision making section like sign in or register section
                  Row(
                    children: [
                      //GFButton(),
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(

                          fillColor: MaterialStateProperty.all( Theme.of(context).primaryColor),

                          checkColor:Theme.of(context).highlightColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          value: true,
                        ),
                      ),
                   RichText(
                       text:TextSpan(text: " الموافقه علي ",  style: TextStyle(color: Colors.black),
                           children: [

                         TextSpan(text: "  شروط الأستخدام ",
                           style: const TextStyle(
                             color: Colors.blue,
                             decoration: TextDecoration.underline,
                           ),
                           recognizer: TapGestureRecognizer()
                             ..onTap = () => Navigator.push(
                               context,
                               /*PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
              return ScaleTransition(scale: animation, child: child, alignment: Alignment.center);
            },
          ),*/
                               MaterialPageRoute(builder: (_) => HtmlViewScreen(
                                 title: getTranslated('terms_condition', context),
                                 url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                               )),
                             ),
                         ),
                         TextSpan(text: "و",  style: TextStyle(color: Colors.black),),
                         TextSpan(text: "سياسه الخصوصيه ", style: const TextStyle(
                           color: Colors.blue,
                           decoration: TextDecoration.underline,
                         ),
                           recognizer: TapGestureRecognizer()
                             ..onTap = () => Navigator.push(
                               context,
                               /*PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
              return ScaleTransition(scale: animation, child: child, alignment: Alignment.center);
            },
          ),*/
                               MaterialPageRoute(builder: (_) => HtmlViewScreen(
                                 title: getTranslated('privacy_policy', context),
                                 url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                               )),
                             ),
                         ),

                       ]),




                   ),
                    ],

                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //margin: EdgeInsets.only(right: Dimensions.FONT_SIZE_LARGE),
                            height: 1,
                            color: ColorResources.getGainsBoro(context),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 15),
                          child: Provider.of<AuthProvider>(context).isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                   Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                              : CustomButton(onTap: loginUser, buttonText: getTranslated('NEXT', context)),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

