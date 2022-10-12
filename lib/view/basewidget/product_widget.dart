import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/provider/wishlist_provider.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final Product productModel;
  ProductWidget({@required this.productModel});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false).checkWishListById(widget.productModel.id.toString(), context);
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1000),
          pageBuilder: (context, anim1, anim2) => ProductDetails(product: widget.productModel),
        ));
      },
      child: Container(
        height: MediaQuery.of(context).size.width/1.55,
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Product Image
            Container(
              decoration: BoxDecoration(
                color: ColorResources.getIconBg(context),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.width/2.55,
                  imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.productModel.thumbnail}',
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
                  placeholder: Images.placeholder, fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width/2.55,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${productModel.thumbnail}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1,
                      fit: BoxFit.cover,height: MediaQuery.of(context).size.width/2.45),
                ),

                 */
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.only(top :1,bottom: 1, left: 5,right: 5),
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.productModel.name ?? '', textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                          fontWeight: FontWeight.w400), maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      /*
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar(
                              rating: double.parse(ratting),
                              size: 18,
                            ),
                        Text('(${productModel.reviewCount.toString() ?? 0})',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                           )),
                      ]),
                       */

                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      widget.productModel.discount.toInt() != null && widget.productModel.discount.toInt() > 0 ? Text(
                        PriceConverter.convertPrice(context, widget.productModel.unitPrice),
                        style: titleRegular.copyWith(
                          color: ColorResources.getTextTitle(context),
                          decoration: TextDecoration.lineThrough,
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALLest,
                        ),
                      ) : SizedBox.shrink(),

                      Text(
                        PriceConverter.convertPrice(context, widget.productModel.unitPrice, discountType: widget.productModel.discountType, discount: widget.productModel.discount),
                        style: titilliumSemiBold.copyWith(
                          color: ColorResources.getTextTitle(context),
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),

          // Off
          widget.productModel.discount.toInt() > 0
              ? Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: ColorResources.getPrimary(context),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  PriceConverter.percentageCalculation(context, widget.productModel.unitPrice, widget.productModel.discount, widget.productModel.discountType),
                  style: robotoRegular.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
              ),
            ),
          )
              : SizedBox.shrink(),
           Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Variation _variation;
                    String _variantName = widget.productModel.colors.length != 0 ? widget.productModel.colors[Provider.of<ProductDetailsProvider>(context, listen: false).variantIndex].name : null;
                    List<String> _variationList = [];
                    for(int index=0; index < widget.productModel.choiceOptions.length; index++) {
                      _variationList.add(widget.productModel.choiceOptions[index].options[Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex[index]].trim());

                    }
                    String variationType = '';
                      bool isFirst = true;
                      _variationList.forEach((variation) {
                        if(isFirst) {
                          variationType = '$variationType$variation';
                          isFirst = false;
                        }else {
                          variationType = '$variationType-$variation';
                        }
                      });

                    double price = widget.productModel.unitPrice;
                    int _stock = widget.productModel.currentStock;
                    variationType = variationType.replaceAll(' ', '');
                    for(Variation variation in widget.productModel.variation) {
                      if(variation.type == variationType) {
                        price = variation.price;
                        _variation = variation;
                        _stock = variation.qty;
                        break;
                      }
                    }
                    double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, widget.productModel.discount, widget.productModel.discountType);

                    if(widget.productModel.currentStock > 0 ) {
                      CartModel cart = CartModel(
                          widget.productModel.id, widget.productModel.thumbnail, widget.productModel.name,
                          widget.productModel.addedBy == 'seller' ? widget.productModel.addedBy : 'admin',
                          price, priceWithDiscount, Provider.of<ProductDetailsProvider>(context, listen: false).quantity, widget.productModel.currentStock,
                          widget.productModel.colors.length > 0 ? widget.productModel.colors[Provider.of<ProductDetailsProvider>(context, listen: false).variantIndex].name : '', widget.productModel.colors.length > 0 ? widget.productModel.colors[Provider.of<ProductDetailsProvider>(context, listen: false).variantIndex].code : '',
                          _variation, widget.productModel.discount, widget.productModel.discountType, widget.productModel.tax, widget.productModel.taxType, 1,
                          '',widget.productModel.userId,'','','', widget.productModel.choiceOptions, Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex, widget.productModel.isMultiPly==1? widget.productModel.shippingCost* Provider.of<ProductDetailsProvider>(context, listen: false).quantity : widget.productModel.shippingCost ??0
                      );

                      // cart.variations = _variation;

                      if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                        Provider.of<CartProvider>(context, listen: false).addToCartAPI(
                          cart, route, context, widget.productModel.choiceOptions,
                          Provider.of<ProductDetailsProvider>(context, listen: false).variationIndex,
                        );
                      }else {
                        Provider.of<CartProvider>(context, listen: false).addToCart(cart);
                        Navigator.pop(context);
                        showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                      }

                    }
                  },
                  child: Container(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: ColorResources.getPrimary(context),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ),
          /*

          Positioned(
            top: 2,
            left: 0,
            child: Column(
              children: [
                FavouriteButton(
                  backgroundColor: ColorResources.getImageBg(context),
                  favColor: Theme.of(context).primaryColor,
                  isSelected: Provider.of<WishListProvider>(context,listen: false).isWish,
                  productId: widget.productModel.id,
                ),
              ],
            ),
          ),
*/
        ]),
      ),
    );
  }
}
