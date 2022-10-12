import 'dart:async';

import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/provider/seller_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/cart/cart_screen.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final Function callback;
  CartBottomSheet({@required this.product, this.callback});

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {

  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailsProvider>(context, listen: false).initData(widget.product);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              Variation _variation;
              String _variantName = widget.product.colors.length != 0 ? widget.product.colors[details.variantIndex].name : null;
              List<String> _variationList = [];
              for(int index=0; index < widget.product.choiceOptions.length; index++) {
                _variationList.add(widget.product.choiceOptions[index].options[details.variationIndex[index]].trim());

              }
              String variationType = '';
              if(_variantName != null) {
                variationType = _variantName;
                _variationList.forEach((variation) => variationType = '$variationType-$variation');
              }else {

                bool isFirst = true;
                _variationList.forEach((variation) {
                  if(isFirst) {
                    variationType = '$variationType$variation';
                    isFirst = false;
                  }else {
                    variationType = '$variationType-$variation';
                  }
                });
              }
              double price = widget.product.unitPrice;
              int _stock = widget.product.currentStock;
              variationType = variationType.replaceAll(' ', '');
              for(Variation variation in widget.product.variation) {
                if(variation.type == variationType) {
                  price = variation.price;
                  _variation = variation;
                  _stock = variation.qty;
                  break;
                }
              }
              double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, widget.product.discount, widget.product.discountType);
              double priceWithQuantity = priceWithDiscount * details.quantity;
              String ratting = widget.product.rating != null && widget.product.rating.length != 0? widget.product.rating[0].average : "0";

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Close Button
                Align(alignment: Alignment.centerRight, child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).highlightColor, boxShadow: [BoxShadow(
                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                      spreadRadius: 1,
                      blurRadius: 5,
                    )]),
                    child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
                  ),
                )),

                // Product details
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: ColorResources.getImageBg(context),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: .5,color: Theme.of(context).primaryColor.withOpacity(.20))
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder,
                                image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${widget.product.thumbnail}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.product.name ?? '',
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                      maxLines: 2, overflow: TextOverflow.ellipsis),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  Row(
                                    children: [
                                      Icon(Icons.star,color: Colors.orange),
                                      Text(double.parse(ratting).toStringAsFixed(1),
                                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                          maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ]),
                          ),
                        ]),
                    Row(
                      children: [
                        widget.product.discount > 0 ?
                        Container(
                          margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              PriceConverter.percentageCalculation(context, widget.product.unitPrice,
                                  widget.product.discount, widget.product.discountType),
                              style: titilliumRegular.copyWith(color: Theme.of(context).cardColor,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT),
                            ),
                          ),
                        ) : SizedBox(width: 93),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                        widget.product.discount > 0 ? Text(
                          PriceConverter.convertPrice(context, widget.product.unitPrice),
                          style: titilliumRegular.copyWith(color: ColorResources.getRed(context),
                              decoration: TextDecoration.lineThrough),
                        ) : SizedBox(),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                        Text(
                          PriceConverter.convertPrice(context, widget.product.unitPrice, discountType: widget.product.discountType, discount: widget.product.discount),
                          style: titilliumRegular.copyWith(color: ColorResources.getPrimary(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        ),

                      ],
                    ),
                  ],
                ),


                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                // Variant
                widget.product.colors.length > 0 ?
                Row( children: [
                  Text('${getTranslated('select_variant', context)} : ',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                  SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: widget.product.colors.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String colorString = '0xff' + widget.product.colors[index].code.substring(1, 7);
                        return InkWell(
                          onTap: () {
                            Provider.of<ProductDetailsProvider>(context, listen: false).setCartVariantIndex(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                border: details.variantIndex == index ? Border.all(width: 1, color: Theme.of(context).primaryColor):null
                            ),
                            child: Padding(padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              child: Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all( Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(colorString)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                //child: details.variantIndex == index ? Icon(Icons.done_all, color: ColorResources.WHITE, size: 12) : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]) : SizedBox(),
                widget.product.colors.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL) : SizedBox(),


                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${getTranslated('available', context)} '+' '+'${widget.product.choiceOptions[index].title} : ', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: (1 / .55),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.product.choiceOptions[index].options.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<ProductDetailsProvider>(context, listen: false).setCartVariationIndex(index, i);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        //color: details.variationIndex[index] != i ? Theme.of(context).highlightColor : ColorResources.getPrimary(context),
                                        borderRadius: BorderRadius.circular(5),
                                        border: details.variationIndex[index] != i ?  null: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                      ),
                                      child: Center(
                                        child: Text(widget.product.choiceOptions[index].options[i], maxLines: 1,
                                            overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                              color: details.variationIndex[index] != i ? ColorResources.getTextTitle(context) : Theme.of(context).primaryColor,
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ]);
                  },
                ),


                SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),


                // Quantity
                Row(children: [
                  Text(getTranslated('quantity', context), style: robotoBold),
                  QuantityButton(isIncrement: false, quantity: details.quantity, stock: _stock),
                  Text(details.quantity.toString(), style: titilliumSemiBold),
                  QuantityButton(isIncrement: true, quantity: details.quantity, stock: _stock),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getTranslated('total_price', context), style: robotoBold),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        PriceConverter.convertPrice(context, priceWithQuantity),
                        style: titilliumBold.copyWith(color: ColorResources.getPrimary(context), fontSize: 16),
                      ),
                    ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(children: [
                  Provider.of<CartProvider>(context).isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : Expanded(
                          child: CustomButton(
                              buttonText: getTranslated(_stock < 1 ? 'out_of_stock' : 'add_to_cart', context),
                              onTap: _stock < 1  ? null :() {
                                if(_stock > 0 ) {
                                  CartModel cart = CartModel(
                                      widget.product.id, widget.product.thumbnail, widget.product.name,
                                      widget.product.addedBy == 'seller' ? '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.fName} '
                                          '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.lName}' : 'admin',
                                      price, priceWithDiscount, details.quantity, _stock,
                                      widget.product.colors.length > 0 ? widget.product.colors[details.variantIndex].name : '', widget.product.colors.length > 0 ? widget.product.colors[details.variantIndex].code : '',
                                      _variation, widget.product.discount, widget.product.discountType, widget.product.tax, widget.product.taxType, 1,
                                      '',widget.product.userId,'','','', widget.product.choiceOptions, Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex, widget.product.isMultiPly==1? widget.product.shippingCost*details.quantity : widget.product.shippingCost ??0
                                  );

                                  // cart.variations = _variation;

                                  if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                    Provider.of<CartProvider>(context, listen: false).addToCartAPI(
                                      cart, route, context, widget.product.choiceOptions,
                                      Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex,
                                    );
                                  }else {
                                    Provider.of<CartProvider>(context, listen: false).addToCart(cart);
                                    Navigator.pop(context);
                                    showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                  }

                                }}

                          ),
                        ),

                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                        Provider.of<CartProvider>(context).isLoading
                      ? SizedBox()
                      : Expanded(
                        child: CustomButton(
                            isBuy:true,
                            buttonText: getTranslated(_stock < 1 ? 'out_of_stock' : 'buy_now', context),
                            onTap: _stock < 1  ? null :() {
                              if(_stock > 0 ) {
                                CartModel cart = CartModel(
                                    widget.product.id, widget.product.thumbnail, widget.product.name,
                                    widget.product.addedBy == 'seller' ? '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.fName} '
                                        '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.lName}' : 'admin',
                                    price, priceWithDiscount, details.quantity, _stock,
                                    widget.product.colors.length > 0 ? widget.product.colors[details.variantIndex].name : '', widget.product.colors.length > 0 ? widget.product.colors[details.variantIndex].code : '',
                                    _variation, widget.product.discount, widget.product.discountType, widget.product.tax, widget.product.taxType, 1,
                                    '',widget.product.userId,'','','', widget.product.choiceOptions, Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex, widget.product.isMultiPly==1? widget.product.shippingCost*details.quantity : widget.product.shippingCost ??0
                                );

                                // cart.variations = _variation;

                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                  Provider.of<CartProvider>(context, listen: false).addToCartAPI(
                                    cart, route, context, widget.product.choiceOptions,
                                    Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex,
                                  ).then((value) =>
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context)=> CartScreen()
                                      )),
                                  );
                                }else {
                                  Provider.of<CartProvider>(context, listen: false).addToCart(cart);
                                  Future.delayed(const Duration(seconds: 1), () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context)=>CartScreen()
                                    ));
                                  });
                                }

                              }}



                        ),
                      ),
                    ],),
                    // Cart button


              ]);
            },
          ),
        ),
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;

  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isIncrement && quantity > 1) {
          Provider.of<ProductDetailsProvider>(context, listen: false).setQuantity(quantity - 1);
        } else if (isIncrement && quantity < stock) {
          Provider.of<ProductDetailsProvider>(context, listen: false).setQuantity(quantity + 1);
        }
      },
      icon: Container(
        width: 40,height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Theme.of(context).primaryColor)
        ),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: isIncrement
              ? quantity >= stock ? ColorResources.getLowGreen(context) : ColorResources.getPrimary(context)
              : quantity > 1
              ? ColorResources.getPrimary(context)
              : ColorResources.getTextTitle(context),
          size: isCartWidget?26:20,
        ),
      ),
    );
  }
}