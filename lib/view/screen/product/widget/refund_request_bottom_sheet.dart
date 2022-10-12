
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/custom_app_bar.dart';
import 'package:emdad/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

class RefundBottomSheet extends StatefulWidget {
  final Product product;
  final int orderDetailsId;
  RefundBottomSheet({@required this.product, @required this.orderDetailsId});

  @override
  _RefundBottomSheetState createState() => _RefundBottomSheetState();
}

class _RefundBottomSheetState extends State<RefundBottomSheet> {
  final TextEditingController _refundReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    Provider.of<OrderProvider>(context, listen: false).getRefundReqInfo(context, widget.orderDetailsId);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: getTranslated('refund_request', context)),
            SingleChildScrollView(
              child: Consumer<OrderProvider>(
                builder: (context,refundReq,_) {
                  return Padding(
                    padding: mediaQueryData.viewInsets,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Consumer<OrderProvider>(
                              builder: (context, refund,_) {
                                return Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('total_price', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.productPrice*refund.refundInfoModel.refund.quntity ), style: TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('product_discount', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.productTotalDiscount), style: TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('tax', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.productTotalTax), style: TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('sub_total', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.subtotal), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('coupon_discount', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.couponDiscount), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('total_refund_amount', context), style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundInfoModel.refund.refundAmount), style: TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ]),
                                );
                              }
                            ),

                        Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: CustomTextField(
                            maxLine: 4,
                            hintText: getTranslated('refund_reason', context),
                            controller: _refundReasonController,
                            textInputAction: TextInputAction.done,
                            fillColor: ColorResources.getLowGreen(context),
                          ),
                        ),

                        Consumer<OrderProvider>(
                            builder: (context, refundProvider,_) {
                              return refundProvider.refundImage.length>0?
                              Container(height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: refundProvider.refundImage.length,
                                  itemBuilder: (BuildContext context, index){
                                    return  refundProvider.refundImage.length > 0?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Container(width: 100, height: 100,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                              child: Image.file(File(refundProvider.refundImage[index].path), width: 100, height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ) ,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                          ),
                                          Positioned(
                                            top:0,right:0,
                                            child: InkWell(
                                              onTap :() => refundProvider.removeImage(index),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(Icons.clear,color: Colors.red,size: 15,),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ):SizedBox();

                                  },),
                              ):SizedBox();
                            }
                        ),

                        Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: InkWell(
                            onTap: (){
                              Provider.of<OrderProvider>(context, listen: false).pickImage(false);
                            },
                            child: Container(height: 30,
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(getTranslated('upload_image', context)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                    Image.asset(Images.upload_image),
                                  ],
                                )),
                          ),
                        ),

                            CustomButton(
                              buttonText: getTranslated('submit', context),
                              onTap: () {
                                String reason  = _refundReasonController.text.trim().toString();
                                print(reason);
                                if(reason.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(getTranslated('reason_required', context)),
                                    backgroundColor: Colors.red,
                                  ));
                                }else {
                                  refundReq.refundRequest(context, widget.orderDetailsId, refundReq.refundInfoModel.refund.refundAmount,reason,
                                      Provider.of<AuthProvider>(context, listen: false).getUserToken()).
                                  then((value) {
                                    if(value.statusCode==200){
                                      refundReq.getRefundReqInfo(context, widget.orderDetailsId);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(getTranslated('successfully_requested_for_refund', context)),
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.pop(context);
                                    }
                                  });
                                  //logic here
                                }
                              },
                            ),

                      ]),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor =  Colors.transparent;
  Color completeColor;
  double width;
  MyPainter({this.completeColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    var percent = (size.width *0.001) / 2;
    double arcAngle = 2 * pi * percent;

    for (var i = 0; i < 8; i++) {
      var init = (-pi / 2)*(i/2);
      canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), init, arcAngle, false, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
