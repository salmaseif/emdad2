import 'package:emdad/data/model/response/user_info_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/choose_category_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/utility/strings.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/textfield/custom_textfield.dart';
import 'package:emdad/view/screen/dashboard/dashboard_screen.dart';
import 'package:emdad/view/screen/tread_info/auth_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

class TreadInfo extends StatefulWidget {
  final bool start;
  const TreadInfo({Key key,@required this.start}) : super(key: key);

  @override
  _TreadInfo createState() => _TreadInfo();
}

class _TreadInfo extends State<TreadInfo> with TickerProviderStateMixin{
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 3; // upperBound MUST BE total number of icons minus 1.
  double _crossAxisSpacing = 12, _mainAxisSpacing = 12, _aspectRatio = 0.9;
  int _crossAxisCount = 3;
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  //final FocusNode _passwordFocus = FocusNode();
  //final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  List saleItem=['المشتريات الشهرية','500,0000','1,000,000','1,500,000'];
  String chooseSaleType;
  String chooseSaleTypeInIt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChooseCategoryProvider>(context, listen: false).initializeChooseCateoryList();
    setCatTreadType();
    if(widget.start == false) {
      setCat();
    }
    setSaleAmount();
  }


  void setCatTreadType() {
    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      String treadType = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.treadType;
      for (int j = 0; j < Provider.of<ChooseCategoryProvider>(context, listen: false).chooseCategoryList.length; j++) {
        if (Provider.of<ChooseCategoryProvider>(context, listen: false).chooseCategoryList[j].name.toString() == treadType.toString()) {
          Provider.of<ChooseCategoryProvider>(context, listen: false).selectTreadType(j);
          setState(() {});
          break;
        }
      }
      _firstNameController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName.toString() != null ? Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName: '';
      _lastNameController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName != null ? Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName: '';
      _emailController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.email != null ? Provider.of<ProfileProvider>(context, listen: false).userInfoModel.email: '';
      _phoneController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone != null ? Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone: '';
      setState(() {});
    }
  }

  void setCat() {
    List<String> catIds = [];
    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      List<String> stringList = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.categorySelected.split(",");
      print('===stringList====>$stringList');
      for(int j=0; j < stringList.length; j++) {
        catIds.add(stringList[j].replaceAll("]", "").replaceAll("[", ""));
        print('===catIds====>$catIds');
        Provider.of<CategoryProvider>( context, listen: false ).selectCategoriesByIds(stringList[j].replaceAll("]", "").replaceAll("[", "").toString());
      }
      setState(() {});
    }
  }


  void setSaleAmount() {
    List<String> catIds = [];
    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      String saleAmounts = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.saleAmount;
    print('===saleAmounts====>$saleAmounts');
    for(int j=0; j < saleItem.length; j++) {
      if( saleItem[j].toString() == saleAmounts.toString()) {
        chooseSaleType = saleItem[j];
        setState(() {});
      }
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ChooseCategoryProvider>(context, listen: false).initializeChooseCateoryList();
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 80,
          title: Text('أكمل معلومات نشاطك' ,style: TextStyle(
              color: Colors.black87,
              fontSize: 16),
          ),
          backgroundColor: Color(0xffFFFFFF),
        ),
        body: Padding(
          padding: const EdgeInsets.all(1.0),
          child:  Column(
                children: [
                  IconStepper(
                    icons: [
                      Icon(Icons.category, color: Color(0xFF645BC4)),
                      Icon(Icons.production_quantity_limits_sharp, color: Color(0xFF645BC4)),
                      Icon(Icons.person, color: Color(0xFF645BC4),),
                    ],
                    // activeStep property set to activeStep variable defined above.
                    activeStep: activeStep,
                    // This ensures step-tapping updates the activeStep.
                    onStepReached: (index) {
                      setState(() {
                        activeStep = index;
                      });
                    },
                  ),

                 // header( ),
                  activeStep == 0
                      ? Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                authHeaderWidget( context: context,
                                    title: "نوع المنشاء",
                                    subTitle: Strings.you_can_choose_topics_and_we_have
                                ),
                                Consumer<ChooseCategoryProvider>(
                                  builder: (context, chooseCategoryProvider, child) =>
                                      Expanded(
                                        child: GridView.builder(
                                            itemCount: chooseCategoryProvider.chooseCategoryList.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: _crossAxisCount,
                                              crossAxisSpacing: _crossAxisSpacing,
                                              mainAxisSpacing: _mainAxisSpacing,
                                              childAspectRatio: _aspectRatio,
                                            ),
                                            itemBuilder: (context, index) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    //color: ColorResources.COLOR_PRIMARY.withOpacity(.1),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Provider.of<ChooseCategoryProvider>( context, listen: false ).selectTreadType( index );
                                                              setState(() {});
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular( Dimensions.PADDING_SIZE_SMALL ),
                                                                child: Image.asset(
                                                                  chooseCategoryProvider.chooseCategoryList[index].imageUrl,
                                                                  width: 100,
                                                                  height: 100,
                                                                ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              right: 5,
                                                              top: 5,
                                                              child: CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor: chooseCategoryProvider.chooseCategoryList[index].isSelect
                                                                    ? ColorResources.COLOR_PRIMARY
                                                                    : ColorResources.COLOR_VERY_LIGHT_GRAY,
                                                                child: chooseCategoryProvider.chooseCategoryList[index].isSelect
                                                                    ? Icon( Icons.done, size: 15, color: ColorResources.COLOR_WHITE, )
                                                                    : null,
                                                              ) )
                                                        ],
                                                      ),
                                                      Text(chooseCategoryProvider.chooseCategoryList[index].name)
                                                    ],
                                                  ),
                                                ) ),
                                      ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: Dimensions.PADDING_SIZE_DEFAULT,
                                        right: Dimensions.PADDING_SIZE_DEFAULT,
                                        bottom: Dimensions.PADDING_SIZE_DEFAULT ),
                                    child: CustomButton(
                                      buttonText: "الاستمرار",
                                      onTap: () {
                                       if(Provider.of<ChooseCategoryProvider>( context, listen: false ).checkTreadType == true){
                                          setState(() {
                                            activeStep = 1;
                                          });
                                        } else{
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يجب تحديد نوع نشاطك التجاري"), backgroundColor: ColorResources.RED));
                                       }
                                      },
                                    ) ),
                              ],
                            ),
                          ),
                        )
                        : activeStep == 1
                        ? Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  authHeaderWidget( context: context,
                                      title: 'أقسام تهمك',
                                      subTitle: "اختار التقسيمات والاصناف المهمه بالنسه لك"),
                                  Container(height: 20,),
                                  Consumer<CategoryProvider>(
                                    builder: (context, categoryProviderDir, child) =>
                                        Expanded(
                                          child: GridView.builder(
                                              itemCount: categoryProviderDir.categoryList.length,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: _crossAxisCount,
                                                crossAxisSpacing: _crossAxisSpacing,
                                                mainAxisSpacing: _mainAxisSpacing,
                                                childAspectRatio: _aspectRatio,
                                              ),
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      //color: ColorResources.COLOR_PRIMARY.withOpacity(.1),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Provider.of<CategoryProvider>( context, listen: false ).selectCategories( index );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular( Dimensions.PADDING_SIZE_SMALL ),
                                                                child: FadeInImage.assetNetwork(
                                                                  placeholder: Images.placeholder,
                                                                  image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.categoryImageUrl}'
                                                                      '/${categoryProviderDir.categoryList[index].icon}',
                                                                  width: 100,
                                                                  height: 80,
                                                                  fit: BoxFit.fill, ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                right: 5,
                                                                top: 5,
                                                                child: CircleAvatar(
                                                                  radius: 10,
                                                                  backgroundColor: categoryProviderDir.categoryList[index].isSelected
                                                                      ? ColorResources.COLOR_PRIMARY
                                                                      : ColorResources.COLOR_VERY_LIGHT_GRAY,
                                                                  child: categoryProviderDir.categoryList[index].isSelected
                                                                      ? Icon(
                                                                    Icons.done,
                                                                    size: 15,
                                                                    color: ColorResources.COLOR_WHITE,
                                                                  )
                                                                      : null,
                                                                ) )
                                                          ],
                                                        ),
                                                        Text( categoryProviderDir.categoryList[index].name )
                                                      ],
                                                    ),
                                                  ) ),
                                        ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: Dimensions.PADDING_SIZE_DEFAULT,
                                          right: Dimensions.PADDING_SIZE_DEFAULT,
                                          bottom: Dimensions.PADDING_SIZE_DEFAULT ),
                                      child: CustomButton(
                                        buttonText: "الاستمرار",
                                        onTap: () {
                                          if(Provider.of<CategoryProvider>( context, listen: false ).checkCategorySelected == true){
                                            setState(() {
                                              activeStep = 2;
                                            });
                                          } else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يجب تحديد واحد من الاهتمامات"), backgroundColor: ColorResources.RED));
                                          }
                                        },
                                      ) ),
                                ],
                              ),
                            ),
                          )
                          : activeStep == 2
                          ? Expanded(
                           child: Center(
                            child: Column(
                              children: [
                                authHeaderWidget( context: context,
                                    title: 'معلومات المنشاة',
                                    subTitle: "اكمل تفاصيل عملك التجاري "),
                                Container(height: 20),
                                Consumer<ProfileProvider>(
                                  builder: (context, profile, child) {

                                    //chooseSaleType = profile.userInfoModel.saleAmount != null ? profile.userInfoModel.saleAmount : saleItem[0];
                                    return Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorResources.getIconBg(context),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                            topRight: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                          )),
                                      child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        children: [
                                          // اسم المنشاة
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.alternate_email, color: ColorResources.getLightSkyBlue(context), size: 20),
                                                    SizedBox(
                                                      width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text(getTranslated('company_name', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomTextField(
                                                  textInputType: TextInputType.name,
                                                  focusNode: _fNameFocus,
                                                  nextNode: _lNameFocus,
                                                  hintText: profile.userInfoModel.fName ?? '',
                                                  controller: _firstNameController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.50)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.all(Radius.circular(25))),
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: DropdownButton(
                                                hint: Text('المشتريات الشهرية'),
                                                dropdownColor: Colors.white,
                                                icon: Icon(Icons.money,color: ColorResources.primaryColor,size: 16,),
                                                isExpanded: true,
                                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
                                                underline: SizedBox(),
                                                value: chooseSaleType,
                                                onChanged: (newValue){
                                                  setState(() {
                                                    chooseSaleType = newValue;
                                                  });
                                                },
                                                items: saleItem.map((valueItem) => DropdownMenuItem(
                                                    value: valueItem,
                                                    child: Text(valueItem))).toList(),
                                              ),
                                          ),
                                          SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                          SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),

                                          authHeaderWidget( context: context,
                                              title: 'معلومات التواصل',
                                              subTitle: "المسؤول عن التواصل والمشتريات"),
                                          // for Email
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.home, color: ColorResources.getLightSkyBlue(context), size: 20),
                                                    SizedBox(
                                                      width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text(getTranslated('person_name', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomTextField(
                                                  textInputType: TextInputType.name,
                                                  focusNode: _lNameFocus,
                                                  nextNode: _phoneFocus,
                                                  hintText: profile.userInfoModel.lName,
                                                  controller: _lastNameController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // for Email
                                          /*
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.alternate_email, color: ColorResources.getLightSkyBlue(context), size: 20),
                                                    SizedBox(
                                                      width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text(getTranslated('EMAIL', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomTextField(
                                                  textInputType: TextInputType.emailAddress,
                                                  focusNode: _lNameFocus,
                                                  nextNode: _phoneFocus,
                                                  hintText: profile.userInfoModel.email ?? '',
                                                  controller: _emailController,
                                                ),
                                              ],
                                            ),
                                          ),
                                           */
                                          // for Phone No
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.dialpad, color: ColorResources.getLightSkyBlue(context), size: 20),
                                                    SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                                    Text(getTranslated('PHONE_NO', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomTextField(
                                                  textInputType: TextInputType.number,
                                                  focusNode: _phoneFocus,
                                                  hintText: profile.userInfoModel.phone ?? "",
                                                  nextNode: _addressFocus,
                                                  controller: _phoneController,
                                                  isPhoneNumber: true,
                                                ),
                                              ],
                                            ),
                                          ),

                                          /*
                                          // for Password
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                                                    SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                                    Text(getTranslated('PASSWORD', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomPasswordTextField(
                                                  controller: _passwordController,
                                                  focusNode: _passwordFocus,
                                                  nextNode: _confirmPasswordFocus,
                                                  textInputAction: TextInputAction.next,
                                                ),
                                              ],
                                            ),
                                          ),

                                          // for  re-enter Password
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                                                    SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                                    Text(getTranslated('RE_ENTER_PASSWORD', context), style: titilliumRegular)
                                                  ],
                                                ),
                                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                                CustomPasswordTextField(
                                                  controller: _confirmPasswordController,
                                                  focusNode: _confirmPasswordFocus,
                                                  textInputAction: TextInputAction.done,
                                                ),
                                              ],
                                            ),
                                          ),
                                          */
                                        ],
                                      ),
                                    ),
                                  );
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE, vertical: Dimensions.MARGIN_SIZE_SMALL),
                                  child: !Provider.of<ProfileProvider>(context).isLoading
                                      ? CustomButton(onTap: _updateUserAccount, buttonText: getTranslated('UPDATE_ACCOUNT', context))
                                      : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(width: 2,),
                ],
              )

        ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: Text('التالي'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Text('السابق'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return activeStep == 0
    ? Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.symmetric(horizontal: 70),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              headerText(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    )
    : activeStep == 1
    ? Container(
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              headerText(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    )
    : activeStep == 2
        ? Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 100),
      width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  headerText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
    ) : Container(width: 1);
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 0:
        return 'نوع \nالمنشاء';

      case 1:
        return 'اصناف \nتهمك';

      case 2:
        return 'معلومات\n المنشاة';

      default:
        return 'بداية';
    }
  }

  _updateUserAccount() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_firstName.isEmpty || _lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    } else if (_email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    } else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    } else if((_password.isNotEmpty && _password.length < 6)
        || (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password should be at least 6 character'), backgroundColor: ColorResources.RED));
    } else if(_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)), backgroundColor: ColorResources.RED));
    } else if(chooseSaleType.toString() == 'المشتريات الشهرية'.toString() || chooseSaleType == null || chooseSaleType == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يجب تحديد المشتريات الشهرية"), backgroundColor: ColorResources.RED));
    } else {
      Provider.of<CategoryProvider>( context, listen: false ).collectCategoriesSelected();
      Provider.of<ChooseCategoryProvider>( context, listen: false ).collectsTreadType();

      UserInfoModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text ?? "";
      updateUserInfoModel.lName = _lastNameController.text ?? "";
      updateUserInfoModel.phone = _phoneController.text ?? '';
      updateUserInfoModel.treadType = Provider.of<ChooseCategoryProvider>( context, listen: false ).checkTreadTypeName.toString()  ?? '';
      updateUserInfoModel.categorySelected = Provider.of<CategoryProvider>( context, listen: false ).categoryListSelected.toString()  ?? '';
      updateUserInfoModel.saleAmount = chooseSaleType ?? "";
      String pass = _passwordController.text ?? '';

      await Provider.of<ProfileProvider>(context, listen: false).updateCompanyDocInfo(
        updateUserInfoModel, pass, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        if(response.isSuccess) {
          Provider.of<AuthProvider>(context, listen: false).setTreadInfoFinch();
          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
        }
      });
    }
  }

}