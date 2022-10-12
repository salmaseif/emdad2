import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/view/screen/checkout/widget/TimeDeliveryBottomSheet.dart';
import 'package:emdad/view/screen/checkout/widget/custom_check_box_product.dart';
import 'package:emdad/view/screen/payment/payment_screen.dart';
import 'package:emdad/view/screen/tread_info/steppers_dots.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/coupon_provider.dart';
import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/amount_widget.dart';
import 'package:emdad/view/basewidget/animated_custom_dialog.dart';
import 'package:emdad/view/basewidget/custom_app_bar.dart';
import 'package:emdad/view/basewidget/my_dialog.dart';
import 'package:emdad/view/basewidget/textfield/custom_textfield.dart';
import 'package:emdad/view/screen/address/saved_address_list_screen.dart';
import 'package:emdad/view/screen/address/saved_billing_Address_list_screen.dart';
import 'package:emdad/view/screen/checkout/widget/custom_check_box.dart';
import 'package:emdad/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:emdad/data/model/body/order_place_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int sellerId;

  CheckoutScreen({@required this.cartList, this.fromProductDetails = false, @required this.discount, @required this.tax, @required this.totalOrderAmount, @required this.shippingFee, this.sellerId});


  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  double _orderCheckDouble = 0;
  double _minOrder = 50.000;
  String _orderCheck;
  bool _digitalPayment;
  bool _cod;
  bool _inFound;
  bool _cancelProduct;
  bool _billingAddress;
  bool _phoneverify;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false).getChosenShippingMethod(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    _digitalPayment = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment;
    _cod = Provider.of<SplashProvider>(context, listen: false).configModel.cod;
    _inFound = Provider.of<SplashProvider>(context, listen: false).configModel.cod;
    _cancelProduct = true;
    _billingAddress = Provider.of<SplashProvider>(context, listen: false).configModel.billingAddress == 1;
    synAddress();
    //
    // Provider.of<OrderProvider>(context, listen: false).shippingAddressNull();
    // Provider.of<OrderProvider>(context, listen: false).billingAddressNull();
  }

  synAddress () async {
    if(Provider.of<ProfileProvider>(context, listen: false).addressList != null)
    {
      Provider.of<OrderProvider>(context, listen: false).setAddressIndex(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount+widget.discount;
    _orderCheck = widget.totalOrderAmount.toStringAsFixed(3);
    _orderCheckDouble = double.parse(_orderCheck);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: ColorResources.getPrimary(context),
         ),
        child: Center(
          child: Consumer<OrderProvider>(
            builder: (context, order, child) {
            return !Provider.of<OrderProvider>(context).isLoading ? Builder(
              builder: (context) => InkWell(
                onTap: () async {
                  print("_order: $_order");
                  print("_orderCheck: $_orderCheck");
                  print("_orderCheckDouble: $_orderCheckDouble");

                  if(Provider.of<OrderProvider>(context, listen: false).addressIndex == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_a_shipping_address', context)), backgroundColor: Colors.red));
                  } else if(Provider.of<OrderProvider>(context, listen: false).billingAddressIndex == null && _billingAddress){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_a_billing_address', context)), backgroundColor: Colors.red));
                  } else if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isDoc == 0 && Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isDocReq == 0) {
                    await showModalBottomSheet(
                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                      builder: (context) => CustomStepper(),
                    );
                  } else if(_orderCheckDouble < _minOrder) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يجب ان يكون الطلب اكثر من  50  الف ريال"), backgroundColor: ColorResources.primaryColor));
                  }  else if(Provider.of<OrderProvider>(context, listen: false).timeDeliveryIndex == 0) {
                    await showModalBottomSheet(
                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                      builder: (context) => TimeDeliveryBottomSheet(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1),
                    );
                  } else {
                    List<CartModel> _cartList = [];
                    _cartList.addAll(widget.cartList);
                    for(int index=0; index<widget.cartList.length; index++) {
                      for(int i=0; i<Provider.of<CartProvider>(context, listen: false).chosenShippingList.length; i++) {
                        if(Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].cartGroupId == widget.cartList[index].cartGroupId) {
                          _cartList[index].shippingMethodId = Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].id;
                          break;
                        }
                      }
                    }
                    String orderNote = _orderNoteController.text.trim();
                    double couponDiscount = Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).discount : 0;
                    String couponCode = Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).coupon.code : '';
                    if(_cod && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {

                      Provider.of<OrderProvider>(context, listen: false).placeOrder(OrderPlaceModel(
                        CustomerInfo(
                          Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                          Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].address,
                          _billingAddress? Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].id.toString():
                          Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                          _billingAddress? Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].address:
                          Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].address,
                          orderNote,
                        ),
                        _cartList,
                        order.paymentMethodIndex == 0 ? 'cash_on_delivery' : '',
                        couponDiscount,
                        Provider.of<OrderProvider>(context, listen: false).timeDeliveryData,
                        Provider.of<OrderProvider>(context, listen: false).timeDeliveryData,
                      ),

                      _callback,
                      _cartList,
                      Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                      couponCode,
                      _billingAddress? Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].id.toString():
                      Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                      orderNote );
                      Provider.of<OrderProvider>(context, listen: false).clearDeliveryTime();
                    }
                    else {
                      String userID = await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PaymentScreen(
                        customerID: userID,
                        addressID: Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                        couponCode: Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).coupon.code : '',
                        billingId: _billingAddress? Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].id.toString():
                        Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                        orderNote: orderNote,
                      )));
                    }
                  }
                },

                child: Text(getTranslated('proceed', context), style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                  color: Theme.of(context).cardColor,
                )),
              ),
            ) : Container(
              height: 30,width: 30 ,alignment: Alignment.center,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).highlightColor)),
            );
            },
          ),
        ),
      ),

      body: Column(
        children: [

          CustomAppBar(title: getTranslated('checkout', context)),

          Expanded(
            child: ListView(physics: BouncingScrollPhysics(), padding: EdgeInsets.all(0), children: [
              // Shipping Details
              Consumer<OrderProvider>(
                builder: (context, shipping,_) {
                  return Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text('${getTranslated('shipping_address', context)}',
                                          style: titilliumRegular.copyWith(fontWeight: FontWeight.w600))),

                                      InkWell(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(builder: (BuildContext context) => SavedAddressListScreen())),
                                        child: Image.asset(Images.address, scale: 3),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          Provider.of<OrderProvider>(context,listen: false).addressIndex == null
                                              ? '${getTranslated('address_type', context)}'
                                              : Provider.of<ProfileProvider>(context, listen: false).addressList[
                                          Provider.of<OrderProvider>(context, listen: false).addressIndex].addressType,
                                          style: titilliumBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                          maxLines: 3, overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        child: Text(
                                          Provider.of<OrderProvider>(context,listen: false).addressIndex == null ?
                                          getTranslated('add_your_address', context)
                                              : Provider.of<ProfileProvider>(context, listen: false).addressList[
                                                shipping.addressIndex].address,
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 3, overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                          _billingAddress ?
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text('${getTranslated('billing_address', context)}',
                                          style: titilliumRegular.copyWith(fontWeight: FontWeight.w600))),
                                      InkWell(
                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => SavedBillingAddressListScreen())),
                                        child: Image.asset(Images.address, scale: 3),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          Provider.of<OrderProvider>(context).billingAddressIndex == null ? '${getTranslated('address_type', context)}'
                                              : Provider.of<ProfileProvider>(context, listen: false).billingAddressList[
                                          Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].addressType,
                                          style: titilliumBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                          maxLines: 1, overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        child: Text(
                                          Provider.of<OrderProvider>(context).billingAddressIndex == null ? getTranslated('add_your_address', context)
                                              : Provider.of<ProfileProvider>(context, listen: false).billingAddressList[
                                                shipping.billingAddressIndex].address,
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 3, overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ):SizedBox(),
                    ]),
                  );
                }
              ),
              // Payment Method
              //طريقه الدفع
              Container(
                height: 100,
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated('payment_method', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Expanded(child: Row(children: [
                        //Text(getTranslated('payment_method', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                        _cod? Expanded(child: CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0)):  SizedBox(),
                        _digitalPayment ? Expanded(
                          child: Container(
                              child: CustomCheckBox(title: getTranslated('digital_payment', context), index: !_cod ? 0 : 1)),
                        ) : SizedBox(),
                      ],)),
                      // _cod? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0):  SizedBox(),
                      // _digitalPayment ? CustomCheckBox(title: getTranslated('digital_payment', context), index: !_cod ? 0 : 1) : SizedBox(),
                    ]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              // Order Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Text(getTranslated('ORDER_DETAILS', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<CartProvider>(context,listen: false).cartList.length,
                    itemBuilder: (ctx,index){
                      return Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.25)),
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                              child: CachedNetworkImage(
                                width: 50, height: 50,
                                imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}'
                                    '/${Provider.of<CartProvider>(context,listen: false).cartList[index].thumbnail}',
                                fit: BoxFit.cover,
                                imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                                  return Image( image: imageProvider, fit: BoxFit.cover);},
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.shopping_cart_outlined),
                              ),
                              /*
                              FadeInImage.assetNetwork(
                                placeholder: Images.placeholder, fit: BoxFit.cover, width: 50, height: 50,
                                image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}'
                                    '/${Provider.of<CartProvider>(context,listen: false).cartList[index].thumbnail}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover, width: 50, height: 50),
                              ),

                               */
                            ),
                          ),
                          SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                          Expanded(
                            flex: 3,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Provider.of<CartProvider>(context,listen: false).cartList[index].name,
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                          color: ColorResources.getPrimary(context)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                  Text(PriceConverter.convertPrice(context, Provider.of<CartProvider>(context,listen: false).cartList[index].price),
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),

                                ],
                              ),
                              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),

                              Row(children: [

                                Text('${getTranslated('qty', context)} - '+' '+Provider.of<CartProvider>(context,listen: false).cartList[index].quantity.toString(),
                                    style: titilliumRegular.copyWith()),

                              ]),
                            ]),
                          ),
                        ]),
                      );

                    }),
              ),
              // Coupon
              Padding(
                padding: const EdgeInsets.only(left:Dimensions.PADDING_SIZE_DEFAULT,right:Dimensions.PADDING_SIZE_DEFAULT,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT),
                child: Container(height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorResources.couponColor(context).withOpacity(.5),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.9))
                  ),
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,bottom: 5),
                          child: Center(
                            child: TextField(controller: _controller, decoration: InputDecoration(
                              hintText: 'هل تمتلك كود الخصم?',
                              hintStyle: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                              filled: false,
                              fillColor: ColorResources.getIconBg(context),
                              border: InputBorder.none,
                            )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    !Provider.of<CouponProvider>(context).isLoading ? InkWell(
                      onTap: () {
                        if(_controller.text.isNotEmpty) {
                          Provider.of<CouponProvider>(context, listen: false).initCoupon(_controller.text, _order).then((value) {
                            if(value > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                               Text('لقد حصلت على ${PriceConverter.convertPrice(context, value)} تخفيض'), backgroundColor: Colors.green));
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getTranslated('invalid_coupon_or', context)),
                                backgroundColor: Colors.red,
                              ));
                            }
                          });
                        }
                      },
                      child: Container(width: 100,height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  topRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL))

                          ),
                          child: Center(child: Text(getTranslated('APPLY', context),
                            style: titleRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                          ))),
                    ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  ]),
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              Container(
                height: 40,width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.055),
                ),
                child: Center(child: Text(getTranslated('order_summary', context),
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),)),
              ),
              // Total bill
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                    //_shippingCost = order.shippingIndex != null ? order.shippingList[order.shippingIndex].cost : 0;
                    double _couponDiscount = Provider.of<CouponProvider>(context).discount != null ?
                    Provider.of<CouponProvider>(context).discount : 0;

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      AmountWidget(title: getTranslated('sub_total', context), amount: PriceConverter.convertPrice(context, _order)),
                      AmountWidget(title: getTranslated('SHIPPING_FEE', context), amount: PriceConverter.convertPrice(context, widget.shippingFee)),
                      AmountWidget(title: getTranslated('DISCOUNT', context), amount: PriceConverter.convertPrice(context, widget.discount)),
                      AmountWidget(title: getTranslated('coupon_voucher', context), amount: PriceConverter.convertPrice(context, _couponDiscount)),
                      AmountWidget(title: getTranslated('TAX', context), amount: PriceConverter.convertPrice(context, widget.tax)),
                      Divider(height: 5, color: Theme.of(context).hintColor),
                      AmountWidget(title: getTranslated('TOTAL_PAYABLE', context), amount: PriceConverter.convertPrice(context,
                          (_order + widget.shippingFee - widget.discount - _couponDiscount + widget.tax))),
                    ]);
                  },
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              //في حال لم تجد المنتج
              Container(
                height: 140,
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated('notFoundProduct', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Expanded(child: Column(children: [
                        //Text(getTranslated('payment_method', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                          _inFound? Expanded(child: CustomCheckBoxProduct(title: getTranslated('tellMeWhenCome', context), index: 0)):  SizedBox(),
                          _cancelProduct ? Expanded(
                           child: Container(
                              child: CustomCheckBoxProduct(title: getTranslated('cancelProduct', context), index: !_inFound ? 0 : 1)),
                        ) : SizedBox(),
                      ],)),
                      // _cod? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0):  SizedBox(),
                      // _digitalPayment ? CustomCheckBox(title: getTranslated('digital_payment', context), index: !_cod ? 0 : 1) : SizedBox(),
                    ]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              // note
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      Text(
                        '${getTranslated('order_note', context)}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                      Text(
                        '${getTranslated('extra_inst', context)}',
                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),),
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  CustomTextField(
                    hintText: getTranslated('order_note', context),
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLine: 3,
                    focusNode: _orderNoteNode,
                    controller: _orderNoteController,
                  ),
                ]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

            ]),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID, List<CartModel> carts) async {
    if(isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, context, reload: true,);
      if(Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
        showAnimatedDialog(context, MyDialog(
          icon: Icons.check,
          title: getTranslated('order_placed', context),
          description: getTranslated('your_order_placed', context),
          isFailed: false,
        ), dismissible: false, isFlip: true);
        Provider.of<OrderProvider>(context, listen: false).clearConfirmPhone();
        Provider.of<OrderProvider>(context, listen: false).clearDeliveryTime();
      }else {

      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: ColorResources.RED));
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;
  PaymentButton({@required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}

