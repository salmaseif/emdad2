import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/view/basewidget/animated_custom_dialog.dart';
import 'package:emdad/view/screen/cart/widget/qty_confirmation_dialog.dart';
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
import 'package:emdad/utility/images.dart';
import 'package:provider/provider.dart';


class CartWidget extends StatefulWidget {
  final CartModel cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget({Key key, this.cartModel, @required this.index, @required this.fromCheckout});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: ColorResources.getHomeBg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: .6,color: Theme.of(context).primaryColor.withOpacity(.40)),
          boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), spreadRadius: 1, blurRadius: 1)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:  MainAxisAlignment.start,
          children: [
            Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ?
            InkWell(
                onTap: () {
                  showAnimatedDialog(context, QuantityConfirmationDialog(quantityItem:widget.cartModel.quantity.toString(), index: widget.index, isIncrement: true, quantity: widget.cartModel.quantity, maxQty: 20, cartModel: widget.cartModel),  isFlip: true);
                  /*
                  Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index,
                          (bool isSuccessful, String message) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: isSuccessful ? Colors.green : Colors.red,
                          content: Text(message),
                        ));
                      });
                  */
                },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.4),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), spreadRadius: 1, blurRadius: 1)],
                  border: Border.all(width: .9,color: Theme.of(context).primaryColor.withOpacity(.20)),
                  borderRadius: BorderRadius.circular(20),
              ),
               child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(widget.cartModel.id, widget.cartModel.quantity+1, context).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
                        ));
                      });
                      },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).highlightColor.withOpacity(0.8),
                    child: Text(
                      widget.cartModel.quantity.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(widget.cartModel.id,widget.cartModel.quantity-1, context).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
                        ));
                      });
                      },
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ),
              ),
            ) : SizedBox.shrink(),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.20),width: 1)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: CachedNetworkImage(
                  height: 60, width: 60,
                  imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${widget.cartModel.thumbnail}',
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
                  placeholder: Images.placeholder, height: 60, width: 60,
                  image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${widget.cartModel.thumbnail}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,fit: BoxFit.cover, height: 60, width: 60),
                ),

                 */
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(widget.cartModel.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: titilliumBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: ColorResources.getReviewRattingColor(context),
                            )),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                          !widget.fromCheckout ? InkWell(
                            onTap: () {
                              if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                Provider.of<CartProvider>(context, listen: false).removeFromCartAPI(context,widget.cartModel.id);
                              }else {
                                Provider.of<CartProvider>(context, listen: false).removeFromCart(widget.index);
                              }
                            },
                            child: Container(width: 20,height: 20,
                                child: Image.asset(Images.delete,scale: .5,)),
                          ) : SizedBox.shrink(),
                        ],

                      ),
                      Row(
                        children: [
                          Text(getTranslated('onePrice', context), style: titilliumSemiBold.copyWith(
                              color: ColorResources.getReviewRattingColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT),
                          ),
                          widget.cartModel.discount>0?
                          Text(
                            PriceConverter.convertPrice(context, widget.cartModel.price),maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: titilliumSemiBold.copyWith(color: ColorResources.getRed(context),
                                decoration: TextDecoration.lineThrough,
                            ),
                          ):SizedBox(),
                          SizedBox(width: Dimensions.FONT_SIZE_DEFAULT,),
                          SizedBox(width: Dimensions.FONT_SIZE_DEFAULT,),
                          SizedBox(width: Dimensions.FONT_SIZE_DEFAULT,),
                          Text(
                            PriceConverter.convertPrice(context, widget.cartModel.price, discount: widget.cartModel.discount,discountType: 'amount'),
                            maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: titilliumRegular.copyWith(
                                color: ColorResources.getReviewRattingColor(context),
                                fontSize: Dimensions.FONT_SIZE_DEFAULT
                                ),
                          ),
                        ],
                      ),
                      //السعر الاجمالي
                      Row(
                        children: [

                          Text(getTranslated('totalPrice', context), style: titilliumSemiBold.copyWith(
                              color: ColorResources.getReviewRattingColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT),
                          ),
                          SizedBox(width: Dimensions.FONT_SIZE_DEFAULT,),
                          Text(PriceConverter.convertPrice(context, widget.cartModel.price * widget.cartModel.quantity), style: titilliumSemiBold.copyWith(
                          color: ColorResources.getReviewRattingColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT),
                          ),
                        ],
                      ),


                      //variation
                      (widget.cartModel.variant != null && widget.cartModel.variant.isNotEmpty) ? Padding(
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                        child: Row(children: [
                          //Text('${getTranslated('variations', context)}: ', style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                          Flexible(child: Text(widget.cartModel.variant,
                              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: ColorResources.getReviewRattingColor(context),))),
                        ]),
                      ) : SizedBox(),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        widget.cartModel.shippingType !='order_wise' && Provider.of<AuthProvider>(context, listen: false).isLoggedIn()?
                        Padding(
                          padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                          child: Row(children: [
                            Text('${getTranslated('shipping_cost', context)}: ',
                                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    color: ColorResources.getReviewRattingColor(context))),
                            Text('${widget.cartModel.shippingCost}', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).disabledColor,)),
                          ]),
                        ):SizedBox(),



                        /*
                        Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                              child: QuantityButton(isIncrement: false, index: widget.index, quantity: widget.cartModel.quantity,maxQty: 20,cartModel: widget.cartModel),
                            ),
                            Text(widget.cartModel.quantity.toString(), style: titilliumSemiBold),
                            Padding(
                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                              child: QuantityButton(index: widget.index, isIncrement: true, quantity: widget.cartModel.quantity, maxQty: 20, cartModel: widget.cartModel),
                            ),
                          ],
                        ) : SizedBox.shrink(),
                       */
                      ],),
                    ],
                  ),
              ),
            ),
      ]),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final CartModel cartModel;
  final bool isIncrement;
  final int quantity;
  final int index;
  final int maxQty;
  QuantityButton({@required this.isIncrement, @required this.quantity, @required this.index, @required this.maxQty,@required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isIncrement && quantity > 1) {
          // Provider.of<CartProvider>(context, listen: false).setQuantity(false, index);
          Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel.id,cartModel.quantity-1, context).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        } else if (isIncrement && quantity < maxQty) {
          // Provider.of<CartProvider>(context, listen: false).setQuantity(true, index);
          Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel.id, cartModel.quantity+1, context).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        }
      },
      child: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ? quantity >= maxQty ? ColorResources.getGrey(context)
            : ColorResources.getPrimary(context)
            : quantity > 1
            ? ColorResources.getPrimary(context)
            : ColorResources.getGrey(context),
        size: 30,
      ),
    );
  }
}

