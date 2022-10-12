
import 'dart:io';

import 'package:emdad/data/model/response/user_info_model.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/utility/styles.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomStepper extends StatefulWidget {
  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> with TickerProviderStateMixin {

  int _currentStep = 2;
  StepperType _stepperType = StepperType.horizontal;
  File file;
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();

  switchStepType() {
    setState(() =>
    _stepperType == StepperType.vertical ?
    _stepperType = StepperType.horizontal :
    _stepperType = StepperType.vertical);
  }

  void _choose() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50,maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool isGuestMode;
  String version;
  bool singleVendor = false;

  @override
  void initState() {
    isGuestMode =
    !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      version = Provider
          .of<SplashProvider>(context, listen: false)
          .configModel
          .version != null ? Provider
          .of<SplashProvider>(context, listen: false)
          .configModel
          .version : 'version';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('أكمل معلومات نشاطك', style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16),),
        backgroundColor: Color(0xffFFFFFF),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              steps: _stepper(),
              physics: BouncingScrollPhysics(),
              currentStep: this._currentStep,
              type: _stepperType,
              onStepContinue: () {
                if (this._currentStep == 3) {
                  setState(() {
                    _updateUserAccount();
                    print("Complete");
                  });
                } else {
                  setState(() {
                    _currentStep ++;
                  });
                }
              },
              onStepCancel: () {
                setState(() {
                  this._currentStep = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      Step(
        title: Text('الجوال',
            style: poppinsBold.copyWith(fontSize: 12, color: Colors.black)),
        content: Consumer<ProfileProvider>(
          builder: (context, profile, child) {
            return Row(children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.PADDING_SIZE_LARGE),
                child: Image.asset(Images.logo_with_name_image, height: 35,
                    color: ColorResources.WHITE),
              ),
              Expanded(child: SizedBox.shrink()),
            ]);
          },
        ),
        state: StepState.complete,
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('الموقع',
            style: poppinsBold.copyWith(fontSize: 12, color: Colors.black)),
        content: Column(
          children: [
            Text('Email Info', style: poppinsSemiBold.copyWith(
                fontSize: 14, color: Colors.black),),
            TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email_rounded, color: Colors.black,),
                    labelStyle: poppinsRegular.copyWith(
                      fontSize: 12, color: Color(0xFF645BC4),))),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock_rounded, color: Colors.black,),
                  labelStyle: poppinsRegular.copyWith(
                    fontSize: 12, color: Color(0xFF645BC4),)),),
          ],
        ),
        state: _currentStep >= 1 ? StepState.complete : StepState.editing,
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('معلومات',
            style: poppinsBold.copyWith(fontSize: 12, color: Colors.black)),
        content: Column(
          children: [
            Container(
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.width/3,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/images/docemdad.png", height: MediaQuery.of(context).size.width/3),
            ),

            Text('خدمتنا وأسعارنا المميزة هي نتيجة لشراكتنا المتينة مع الموردين مما يلزمنا أن تكون هذة الخدمات موجهة لقطاع الأعمال بشكل حصري', style: poppinsSemiBold.copyWith(
                fontSize: 20, color: Colors.black),),
            Container(
              height:20,
            ),
            Row(
              children: [
                Icon(Icons.info_outline, color: ColorResources.primaryColor, size: 40,),
                Container(
                  width:10,
                ),
                Text('كيف اقدر اوثق الحساب ؟ ', style: poppinsSemiBold.copyWith(
                    fontSize: 20, color: Colors.black),),

              ],
            ),
            Text(' عن طريق ارفاق رقم السجل التجاري ', style: poppinsSemiBold.copyWith(
                fontSize: 16, color: Colors.black),),
            Text(' أو ارفاق صورة للوحة المحل', style: poppinsSemiBold.copyWith(
                fontSize: 16, color: Colors.black),),
            Container(
              height:40,
            ),
          ],
        ),

        state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('التوثيق',
            style: poppinsBold.copyWith(fontSize: 12, color: Colors.black)),
        content: Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Container(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              _choose();
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(height: 5,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width -70 ,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.2)),
                                      borderRadius: BorderRadius.circular( 10 ),
                                      color: Theme.of( context ).highlightColor,
                                      // boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.10),
                                      //     spreadRadius: 1, blurRadius: 12)]
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('تأكيد عن طريق التقاط صورة للمحل', style: titilliumRegular.copyWith(color: ColorResources.COLOR_BLACK)),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(1),
                                            child: file == null
                                                ? FadeInImage.assetNetwork(
                                                  placeholder: Images.placeholder,
                                                  width: 300,
                                                  height: 200,
                                                  fit: BoxFit.fitHeight,
                                                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.imageDoc1}',
                                                  imageErrorBuilder: (c, o, s) =>
                                                  Image.asset(Images.placeholder, width: 300,
                                                      height: 200,
                                                      fit: BoxFit.cover),
                                                )
                                                : Image.file(file, width: 300, height: 200, fit: BoxFit.fitHeight),
                                          ),
                                           Container(
                                             alignment: Alignment.center,
                                             padding: EdgeInsets.symmetric(horizontal: 30),
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                             ),
                                             child:  OutlinedButton(
                                                onPressed: _choose,
                                                child: Text('إضغط هنا لإرفاق صورة', style: titilliumRegular.copyWith(color: ColorResources.COLOR_BLACK)),
                                             ),
                                          ),
                                        ])
                                  )
                              ]),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_LARGE,
                        vertical: Dimensions.MARGIN_SIZE_SMALL),
                    child: Provider.of<ProfileProvider>(context, listen: false).isLoading == false
                        ? CustomButton(onTap: _updateUserAccount, buttonText: 'توثيق')
                        : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                  ),
                  Container(height: 20,),
                  Divider(height: 5, color: ColorResources.BLACK),
                  Text('أمثلة للصور', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor,)),
                  Divider(height: 5, color: ColorResources.BLACK),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/shopDemo.jpg',
                            width: MediaQuery.of(context).size.width-70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            )),
        state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
        isActive: _currentStep >= 3,
      )
    ];
    return _steps;
  }

  _updateUserAccount() async {
    setState(() {});
    if (file != null) {
      UserInfoModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      updateUserInfoModel.method = 'put';
      //updateUserInfoModel.imageDoc1 = File(file.path).toString() ?? "";
      //updateUserInfoModel.imageDoc2 = File(file2.path).toString() ?? "";
      updateUserInfoModel.isDoc = 1 ?? 0;
      print('_updateUserAccount11========>_updateUserAccount22');

      await Provider.of<ProfileProvider>(context, listen: false).updateUserDocInfo(
        updateUserInfoModel, file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        if (response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
          setState(() {});
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
        }
      });
      }
    else if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.imageDoc1 != null){
      UserInfoModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
        updateUserInfoModel.isComplete = 1;
        updateUserInfoModel.method = 'put';
        //updateUserInfoModel.imageDoc1 = File(file.path).toString() ?? "";
        //updateUserInfoModel.imageDoc2 = File(file2.path).toString() ?? "";
        updateUserInfoModel.isDoc = 1 ?? 0;
        print('_updateUserAccount18881========>_updateUserAccount88822');

        await Provider.of<ProfileProvider>(context, listen: false).updateUserDocInfo(
          updateUserInfoModel, file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
        ).then((response) {
          if (response.isSuccess) {
            Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
            setState(() {});
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
          }
        });

        setState(() {});
    }
    else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('يجب ارفاق الصورتين'), backgroundColor: Colors.red));
    }
  }
}