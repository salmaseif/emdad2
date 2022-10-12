import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/view/basewidget/animated_custom_dialog.dart';
import 'package:emdad/view/screen/cart/widget/qty_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


class BottomCartView extends StatefulWidget {
  final Product product;
  BottomCartView({@required this.product});

  @override
  State<BottomCartView> createState() => _BottomCartViewState();
}

class _BottomCartViewState extends State<BottomCartView> {

  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    int _stock = widget.product.currentStock;
    double price = widget.product.unitPrice;
    Variation _variation;

    double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, widget.product.discount, widget.product.discountType);
    double priceWithQuantity = priceWithDiscount * Provider.of<ProductDetailsProvider>(context, listen: false).quantity;

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], blurRadius: 15, spreadRadius: 1)],
      ),
      child: Row(children: [
        Expanded(flex: 3, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALLest),
          child: Stack(children: [
            GestureDetector(
                onTap: (){
                  showAnimatedDialog(context, QuantityConfirmationDialog(quantityItem: Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toInt(), index: widget.product.id, isIncrement: true, quantity: Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toInt(), maxQty: 20, cartModel: null),  isFlip: true);

                  /*
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>CartScreen()
                  ));
                  */
                  },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: ColorResources.getPrimary(context)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(children: [
                    QuantityButton(isIncrement: false, quantity: Provider.of<ProductDetailsProvider>(context, listen: false).quantity, stock: widget.product.currentStock),
                    Text(Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toString(), style: titilliumSemiBold),
                    QuantityButton(isIncrement: true, quantity: Provider.of<ProductDetailsProvider>(context, listen: false).quantity, stock: widget.product.currentStock),
                  ])),
            ),
          ]),
        )),
        Expanded(flex: 7, child: InkWell(
          onTap: _stock < 1  ? null :() {
            if(_stock > 0 ) {
              var conn = Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toString();
              print('counnnnnnnnnnnnnnnn: $conn');
              CartModel cart = CartModel(
                  widget.product.id, widget.product.thumbnail, widget.product.name,
                  widget.product.addedBy == 'seller' ? widget.product.addedBy : 'admin',
                  price, priceWithDiscount, Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toInt(), _stock,
                  widget.product.colors.length > 0 ? widget.product.colors[Provider.of<ProductDetailsProvider>(context, listen: false).variantIndex].name : '', widget.product.colors.length > 0 ? widget.product.colors[Provider.of<ProductDetailsProvider>(context, listen: false).variantIndex].code : '',
                  _variation, widget.product.discount, widget.product.discountType, widget.product.tax, widget.product.taxType, 1,
                  '',widget.product.userId,'','','', widget.product.choiceOptions, Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex, widget.product.isMultiPly==1? widget.product.shippingCost* Provider.of<ProductDetailsProvider>(context, listen: false).quantity : widget.product.shippingCost ??0
              );

              // cart.variations = _variation;

              if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                Provider.of<CartProvider>(context, listen: false).addToCartAPI(
                  cart, route, context, widget.product.choiceOptions,
                  Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex,
                );
                setState(() {});
              }else {
                Provider.of<CartProvider>(context, listen: false).addToCart(cart);
                setState(() {});
                showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
              }
              setState(() {});
            }},
          /*
          onTap: () {
            showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(product: product, callback: (){
              showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
            },));
          },
           */

          child:  Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: ColorResources.getPrimary(context),
            ),
            child: Provider.of<CartProvider>(context, listen: true).isLoading == false ?

            Container(
                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right:  Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.getPrimary(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     '${PriceConverter.convertPrice(context, priceWithQuantity)}',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).highlightColor),
                    ) ,
                    Text(
                      '${getTranslated('add_to_cart', context)}',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).highlightColor),
                    ),
                ])) : SpinKitFadingCircle(
              color: Theme.of(context).highlightColor,
              size: 50.0,
            ),
          ),
        )),
      ]),
    );
  }
}
