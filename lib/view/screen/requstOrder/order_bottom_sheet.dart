import 'dart:io';

import 'package:emdad/data/model/body/new_order_body.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/new_requst_order_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/support_ticket_provider.dart';
import 'package:emdad/view/basewidget/my_text.dart';
import 'package:emdad/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderBottomSheet extends StatefulWidget {
  final Function callback;
  OrderBottomSheet({this.callback});

  @override
  _OrderBottomSheetState createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  File file;
  final picker = ImagePicker();

  void _choose() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Column( children: [

            Text(getTranslated('product_description_data', context), style: titilliumSemiBold.copyWith(fontSize: 20)),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            Row(
              children: <Widget>[
                Expanded(flex: 3,
                  child: Container( height: 45,
                    decoration: BoxDecoration(
                      color: ColorResources.getHomeBg(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: .5,color: Theme.of(context).highlightColor.withOpacity(.20)),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(maxLines: 2,
                      controller: _subjectController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                          hintText: "اسم منتجك", hintStyle: MyText.body1(context).copyWith(color: Colors.grey)
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /*
            CustomTextField(
              focusNode: _subjectNode,
              nextNode: _descriptionNode,
              textInputAction: TextInputAction.next,
              hintText: getTranslated('product_name', context),
              controller: _subjectController,
              maxLine: 2,
            ),

            TextField(
              focusNode: _subjectNode,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: getTranslated('product_description', context),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            TextField(
              focusNode: _subjectNode,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: getTranslated('product_description', context),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            */
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            Row(
              children: <Widget>[
                Expanded(flex: 3,
                  child: Container( height: 45,
                    decoration: BoxDecoration(
                      color: ColorResources.getHomeBg(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: .5,color: Theme.of(context).highlightColor.withOpacity(.20)),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(maxLines: 1,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(-12), border: InputBorder.none,
                          hintText: "الكمية", hintStyle: MyText.body1(context).copyWith(color: Colors.grey)
                      ),
                    ),
                  ),
                ),
                Container(width: 15),
                Expanded(flex: 2,
                  child: Container( height: 45,
                    decoration: BoxDecoration(
                        color: ColorResources.getHomeBg(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: .5,color: Theme.of(context).highlightColor.withOpacity(.20)),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                        ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(maxLines: 1,
                      controller: _priceController,
                      style: titilliumRegular,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "السعر المتوقع",
                        hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR),
                        border: InputBorder.none,
                      ),

                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            CustomTextField(
              focusNode: _descriptionNode,
              textInputAction: TextInputAction.newline,
              hintText: getTranslated('product_description', context),
              textInputType: TextInputType.multiline,
              controller: _descriptionController,
              maxLine: 5,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            Text(getTranslated('upload_images', context), style: titilliumSemiBold.copyWith(fontSize: 14)),

            Container(
              margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.white, width: 3),
                shape: BoxShape.circle,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: file == null
                        ? FadeInImage.assetNetwork(
                          placeholder: Images.placeholder, width: 100, height: 100, fit: BoxFit.cover,
                          // TODO: implement initState
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${2}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: 100, height: 100, fit: BoxFit.cover),
                        )
                        : Image.file(file, width: 100, height: 100, fit: BoxFit.fill),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -10,
                    child: CircleAvatar(
                      backgroundColor: ColorResources.LIGHT_SKY_BLUE,
                      radius: 14,
                      child: IconButton(
                        onPressed: _choose,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.edit, color: ColorResources.WHITE, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            Provider.of<SupportTicketProvider>(context).isLoading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                : CustomButton(
                      buttonText: getTranslated('submit', context),
                      onTap: () {
                        if (_subjectController.text == "") {
                          showCustomSnackBar('يجب إدخال إسم المنتج', context);
                        } else if (_descriptionController.text == "") {
                          showCustomSnackBar('يجب إدخال تفاصيل المنتج المطلوب', context);
                        }else if (_quantityController.text  == "") {
                          showCustomSnackBar('يجب إدخال الكمية المطلوبة', context);
                        } else {
                          var tokkken = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                          print('sendNewRequstOrder $tokkken');

                          var userId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id;
                          var userToken = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                          NewOrderBody newOrderBody = NewOrderBody(userId,"طلب جديد",_subjectController.text, _quantityController.text, _priceController.text, _descriptionController.text, file);
                          Provider.of<NewRequstOrderProvider>(context, listen: false).sendNewRequstOrder(newOrderBody, callback, context);
                          Provider.of<NewRequstOrderProvider>(context, listen: false).sendNewRequstOrderDoc(newOrderBody, callback, context,file ,userToken);
                        }
                      }),
          ]),
        ),
      ],
    );
  }
  void callback (bool isSuccess, String message) {
    print(message);
    if (isSuccess) {
      _subjectController.text = '';
      _descriptionController.text = '';
      _quantityController.text = '';
      _priceController.text = '';
      Navigator.of(context).pop();
    } else {}
  }
}


