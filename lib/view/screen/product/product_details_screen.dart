import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/screen/cart/cart_screen.dart';
import 'package:emdad/view/screen/product/widget/brand_products.dart';
import 'package:emdad/view/screen/product/widget/brand_products_tow.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/data/model/response/product_model.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/provider/wishlist_provider.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/no_internet_screen.dart';
import 'package:emdad/view/basewidget/title_row.dart';
import 'package:emdad/view/screen/product/widget/bottom_cart_view.dart';
import 'package:emdad/view/screen/product/widget/product_image_view.dart';
import 'package:emdad/view/screen/product/widget/product_title_view.dart';
import 'package:provider/provider.dart';


class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({@required this.product, });



  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData( BuildContext context) async{
      Provider.of<ProductDetailsProvider>(context, listen: false).removePrevReview();
      Provider.of<ProductDetailsProvider>(context, listen: false).initProduct(widget.product, context);
      Provider.of<ProductProvider>(context, listen: false).removePrevRelatedProduct();
      Provider.of<ProductProvider>(context, listen: false).initRelatedProductList(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false).getCount(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false).getSharableLink(widget.product.slug.toString(), context);
      if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<WishListProvider>(context, listen: false).checkWishList(widget.product.id.toString(), context);
      }
      Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.product.userId.toString(), 1, context);
  }

  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }
  Variation _variation;

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailsProvider>(context, listen: false).initData(widget.product);
    ScrollController _scrollController = ScrollController();
    //String ratting = widget.product.rating != null && widget.product.rating.length != 0? widget.product.rating[0].average.toString() : "0";
    _loadData(context);
    return Consumer<ProductDetailsProvider>(
      builder: (context, details, child) {

        return details.hasConnection ? Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBar(
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Theme.of(context).highlightColor : Theme.of(context).highlightColor,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              InkWell(
                child: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor, size: 20),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Text(getTranslated('product_details', context),
                  style: robotoRegular.copyWith(fontSize: 20, color: Theme.of(context).primaryColor)),
                  Spacer(),
                  Spacer(),
              Stack(children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=>CartScreen()
                        ));
                      },
                      child: Container(
                          height: 60,
                          width: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], blurRadius: 15, spreadRadius: 1)],
                          ),
                          child: Image.asset(Images.cart_arrow_down_image, color: ColorResources.getPrimary(context))),),

                  Positioned(
                    top: 2,
                    left: 20,
                    child: Consumer<CartProvider>(builder: (context, cart, child) {
                      return Container(
                        height: 20,
                        width: 17,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResources.getPrimary(context),
                        ),
                        child: Text(
                          cart.cartList.length.toString(),
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color:Theme.of(context).highlightColor),
                        ),
                      );
                    }),
                  )
                ]),
            ]),

            automaticallyImplyLeading: false,
            elevation: 0,
          ),

          bottomNavigationBar: BottomCartView(product: widget.product),

          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                ProductTitleView(productModel: widget.product),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                widget.product != null?
                ProductImageView(productModel: widget.product):SizedBox(),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),


                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      ),
                      child: Consumer<ProductDetailsProvider>(
                        builder: (context, details, child) {
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

                          String priceOneDiscount = PriceConverter.convertPriceOne(context, price,  widget.product.unitNumbers);
                        //  String ratting = widget.product.rating != null && widget.product.rating.length != 0? widget.product.rating[0].average : "0";
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Close Button
                            // Product details

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
                                      Text('${widget.product.choiceOptions[index].title} : ', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
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

                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                            Divider(height: 0, color: Theme.of(context).hintColor),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  ],
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("السعر",
                                        style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                    Text(
                                      PriceConverter.convertPrice(context, widget.product.unitPrice, discountType: widget.product.discountType, discount: widget.product.discount),
                                      style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("سعر الحبه",
                                        style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                    ),
                                    Text(
                                      '${priceOneDiscount.toString()} ر.ي',
                                      style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                  ],
                                ),
                              ],
                            ),
                            // Quantity
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Divider(height: 0, color: Theme.of(context).hintColor),

                          ]);
                        },
                      ),
                    ),
                ],
              ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                Container(
                  transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                  padding: EdgeInsets.only(top: Dimensions.FONT_SIZE_DEFAULT),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          topRight:Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE) ),
                        ),
                  child: Column(children: [


                    /*
                    // Specification
                    (widget.product.details != null && widget.product.details.isNotEmpty) ? Container(
                      height: 158,
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: ProductSpecification(productSpecification: widget.product.details ?? ''),
                    ) : SizedBox(),




                    //promise
                    Container(padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT,
                      horizontal: Dimensions.FONT_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                        color: Theme.of(context).cardColor
                      ),
                        child: PromiseScreen()),

                    widget.product.addedBy == 'seller' ? SellerView(sellerId: widget.product.userId.toString()) : SizedBox.shrink(),
                    //widget.product.addedBy == 'admin' ? SellerView(sellerId: '0') : SizedBox.shrink(),

                    // Reviews
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      color: Theme.of(context).cardColor,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(getTranslated('customer_reviews', context),
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Container(width: 230,height: 30,
                          decoration: BoxDecoration(color: ColorResources.visitShop(context),
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          ),


                          child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RatingBar(rating: double.parse(ratting), size: 18,),
                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                              Text('${double.parse(ratting).toStringAsFixed(1)}'+ ' '+ '${getTranslated('out_of_5', context)}'),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        Text('${getTranslated('total', context)}' + ' '+'${details.reviewList != null ? details.reviewList.length : 0}' +' '+ '${getTranslated('reviews', context)}'),

                        details.reviewList != null ? details.reviewList.length != 0 ? ReviewWidget(reviewModel: details.reviewList[0])
                            : SizedBox() : ReviewShimmer(),
                        details.reviewList != null ? details.reviewList.length > 1 ? ReviewWidget(reviewModel: details.reviewList[1])
                            : SizedBox() : ReviewShimmer(),
                        details.reviewList != null ? details.reviewList.length > 2 ? ReviewWidget(reviewModel: details.reviewList[2])
                            : SizedBox() : ReviewShimmer(),

                        InkWell(
                            onTap: () {
                              if(details.reviewList != null)
                              {Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                  ReviewScreen(reviewList: details.reviewList)));}},
                            child: details.reviewList != null && details.reviewList.length > 3?
                            Text(getTranslated('view_more', context),
                              style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor),):SizedBox())



                      ]),
                    ),

                    //saller more product
                    widget.product.addedBy == 'seller' ?
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: TitleRow(title: getTranslated('more_from_the_shop', context), isDetailsPage: true),
                    ):SizedBox(),

                    widget.product.addedBy == 'seller' ?
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: ProductView(isHomePage: false, productType: ProductType.SELLER_PRODUCT, scrollController: _scrollController, sellerId: widget.product.userId.toString()),
                    ):SizedBox(),

 */
                    // Related Products
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: getTranslated('mark_products', context), isDetailsPage: true),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                            child: BrandProductTowView(scrollController: _scrollController,brandId: widget.product.brandId),
                          ),
                        ],
                      ),
                    ),

                    // Related Products
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: "منتجات من نفس القسم", isDetailsPage: true),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                            child: BrandProductView(scrollController: _scrollController),
                          ),
                        ],
                      ),
                    ),

                    /*
                    // Related Products
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: getTranslated('related_products', context), isDetailsPage: true),
                          ),
                          SizedBox(height: 5),
                          RelatedProductView(),
                        ],
                      ),
                    ),

                     */


                ],),),
              ],
            ),
          ),
        ) : Scaffold(body: NoInternetOrDataScreen(isNoInternet: true, child: ProductDetails(product: widget.product)));
      },
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