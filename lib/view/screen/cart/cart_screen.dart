import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/Palette.dart';
import 'package:emdad/view/basewidget/no_order_in_cart.dart';
import 'package:emdad/view/screen/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/animated_custom_dialog.dart';
import 'package:emdad/view/basewidget/guest_dialog.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/cart/widget/cart_widget.dart';
import 'package:emdad/view/screen/checkout/checkout_screen.dart';
import 'package:emdad/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  CartScreen({this.fromCheckout = false, this.sellerId = 1});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _loadData()async{
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
       Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
      Provider.of<CartProvider>(context, listen: false).setCartData();

      if( Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod != 'sellerwise_shipping'){
        Provider.of<CartProvider>(context, listen: false).getAdminShippingMethodList(context);
      }

    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      double amount = 0.0;
      double shippingAmount = 0.0;
      double discount = 0.0;
      double tax = 0.0;
      List<CartModel> cartList = [];
      cartList.addAll(cart.cartList);

      //TODO: seller
      List<String> orderTypeShipping = [];
      List<String> sellerList = [];
      List<CartModel> sellerGroupList = [];
      List<List<CartModel>> cartProductList = [];
      List<List<int>> cartProductIndexList = [];
      cartList.forEach((cart) {
        if(!sellerList.contains(cart.cartGroupId)) {
          sellerList.add(cart.cartGroupId);
          sellerGroupList.add(cart);
        }
      });

      sellerList.forEach((seller) {
        List<CartModel> cartLists = [];
        List<int> indexList = [];
        cartList.forEach((cart) {
          if(seller == cart.cartGroupId) {
            cartLists.add(cart);
            indexList.add(cartList.indexOf(cart));
          }

        });
        cartProductList.add(cartLists);
        cartProductIndexList.add(indexList);
      });

      sellerGroupList.forEach((seller) {
        if(seller.shippingType == 'order_wise'){
          orderTypeShipping.add(seller.shippingType);
        }
      });

      if(cart.getData && Provider.of<AuthProvider>(context, listen: false).isLoggedIn() && Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false).getShippingMethod(context, cartProductList);
      }

      for(int i=0;i<cart.cartList.length;i++){
        amount += (cart.cartList[i].price - cart.cartList[i].discount) * cart.cartList[i].quantity;
        discount += cart.cartList[i].discount * cart.cartList[i].quantity;
        tax += cart.cartList[i].tax * cart.cartList[i].quantity;
      }
      for(int i=0;i<cart.chosenShippingList.length;i++){
        shippingAmount += cart.chosenShippingList[i].shippingCost;
      }
      for(int j = 0; j< cartList.length; j++){
        shippingAmount += cart.cartList[j].shippingCost??0;
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: ColorResources.BLACK),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text( "سلة التسوق",
            style: titilliumRegular.copyWith(fontSize: 20,
              color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Palette.loginhead,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                  ),
                ],
              ),
            )
          ],
        ),

        bottomNavigationBar: (!widget.fromCheckout && !cart.isLoading)
            ? Container(height: 80, padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              ),
              child: cartList.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Center(
                              child: Row(
                                children: [
                                  Text('${getTranslated('total_price', context)}', style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL),
                                  ),
                                  Text(PriceConverter.convertPrice(context, amount+shippingAmount), style: titilliumSemiBold.copyWith(
                                      color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ],
                              ))),
                      Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            print('===asd=>${orderTypeShipping.length}');
                            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                              if (cart.cartList.length == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_at_least_one_product', context)), backgroundColor: Colors.red,));
                              }
                              /*
                              else if(cart.chosenShippingList.length < orderTypeShipping.length && Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping'){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_all_shipping_method', context)), backgroundColor: Colors.red));
                              } else if(cart.chosenShippingList.length < 1 && Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod !='sellerwise_shipping' && Provider.of<SplashProvider>(context,listen: false).configModel.inHouseSelectedShippingType =='order_wise'){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_all_shipping_method', context)), backgroundColor: Colors.red));
                              }
                              */
                              else {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(
                                  cartList: cartList,totalOrderAmount: amount,shippingFee: shippingAmount, discount: discount,
                                  tax: tax,
                                )));
                              }
                            } else {showAnimatedDialog(context, GuestDialog(), isFlip: true);}
                          },

                          child: Container(width: MediaQuery.of(context).size.width/2.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                    vertical: Dimensions.FONT_SIZE_SMALL),
                                child: Text(getTranslated('checkout', context),
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      color: Theme.of(context).cardColor,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
                  : SizedBox(),
              )
            : null,

        body: Column(
            children: [
              cart.isLoading
                  ? Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Center(child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    ),
                  )
                  : sellerList.length != 0
                  ? Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Card(
                                child: Container(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(Dimensions.HOME_PAGE_PADDING),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).highlightColor,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(width: 0.5,color: Colors.grey),
                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text( getTranslated('itemTotalPrice', context),
                                                    textAlign: TextAlign.end, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                                    )),
                                                Text(PriceConverter.convertPrice(context, amount+shippingAmount), style: titilliumSemiBold.copyWith(
                                                    color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE),
                                                ),
                                              ]),

                                        ])
                                )
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                    await Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
                                  }
                                },
                                child: ListView.builder(
                                  itemCount: sellerList.length,
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Card(
                                              child: Container(
                                                padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                                    Text( getTranslated('ORDER_DETAILS', context),
                                                        textAlign: TextAlign.start, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                                        )),
                                                    ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.all(0),
                                                      itemCount: cartProductList[index].length,
                                                      itemBuilder: (context, i) {
                                                        return CartWidget(
                                                          cartModel: cartProductList[index][i],
                                                          index: cartProductIndexList[index][i],
                                                          fromCheckout: widget.fromCheckout,
                                                        );
                                                      },
                                                    ),

                                                    //Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping'?
                                                    Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping' && sellerGroupList[index].shippingType =='order_wise'?
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                                            showModalBottomSheet(
                                                              context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                                              builder: (context) => ShippingMethodBottomSheet(groupId: sellerGroupList[index].cartGroupId,sellerIndex: index, sellerId: sellerGroupList[index].id),
                                                            );
                                                          }else {
                                                            showCustomSnackBar('not_logged_in', context);
                                                          }
                                                        },


                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(width: 0.5,color: Colors.grey),
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                              Text(getTranslated('SHIPPING_PARTNER', context), style: titilliumRegular),
                                                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                Text(
                                                                  (cart.shippingList == null || cart.shippingList[index].shippingMethodList == null || cart.chosenShippingList.length == 0 || cart.shippingList[index].shippingIndex == -1) ? ''
                                                                      : '${cart.shippingList[index].shippingMethodList[cart.shippingList[index].shippingIndex].title.toString()}',
                                                                  style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                                              ]),
                                                            ]),
                                                          ),
                                                        ),
                                                      )
                                                      ,
                                                    ) :SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod !='sellerwise_shipping' && Provider.of<SplashProvider>(context,listen: false).configModel.inHouseSelectedShippingType =='order_wise'
                                ? InkWell(
                              onTap: () {
                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                  showModalBottomSheet(
                                    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                    builder: (context) => ShippingMethodBottomSheet(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1),
                                  );
                                }else {
                                  showCustomSnackBar('not_logged_in', context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5,color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('SHIPPING_PARTNER', context), style: titilliumRegular),
                                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                      Text(
                                        (cart.shippingList == null ||cart.chosenShippingList.length == 0 || cart.shippingList.length==0 || cart.shippingList[0].shippingMethodList == null ||  cart.shippingList[0].shippingIndex == -1) ? ''
                                            : '${cart.shippingList[0].shippingMethodList[cart.shippingList[0].shippingIndex].title.toString()}',
                                        style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                    ]),
                                  ]),
                                ),
                              ),
                            )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    )
                  : Expanded(child: NoOrderInCartScreen(isNoInternet: false)),
            ]),
      );
    });
  }
}
