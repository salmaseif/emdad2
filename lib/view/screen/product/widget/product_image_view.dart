import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/helper/price_converter.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/provider/wishlist_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/screen/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductImageView extends StatelessWidget {
  final Product productModel;
  ProductImageView({@required this.productModel});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductImageScreen(imageList: productModel.images, title: productModel.name))),
          child: productModel.images !=null ?Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
              gradient: Provider.of<ThemeProvider>(context).darkTheme ? null : LinearGradient(
                colors: [ColorResources.WHITE, ColorResources.WHITE],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.width /1.5,
                child: productModel.images != null? PageView.builder(
                  controller: _controller,
                  itemCount: productModel.images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${productModel.thumbnail}',
                      fit: BoxFit.fitHeight,
                      imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                        return Image( image: imageProvider, fit: BoxFit.fitHeight);},
                      placeholder: (context, url) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    );
                      /*
                      FadeInImage.assetNetwork(fit: BoxFit.fitHeight,
                      placeholder: Images.placeholder2, height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productImageUrl}/${productModel.images[index]}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder2, height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,fit: BoxFit.cover,
                      ),
                    );
                    */
                  },
                  onPageChanged: (index) {
                    Provider.of<ProductDetailsProvider>(context, listen: false).setImageSliderSelectedIndex(index);
                  },
                ):SizedBox(),
              ),
              Positioned(
                left: 0, right: 0, bottom: 30,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _indicators(context),
                    ),
                    Spacer(),
                    Provider.of<ProductDetailsProvider>(context).imageSliderIndex != null?
                    Padding(
                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT,bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Text('${Provider.of<ProductDetailsProvider>(context).imageSliderIndex+1}'+'/'+'${productModel.images.length.toString()}'),
                    ):SizedBox(),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    FavouriteButton(
                      backgroundColor: ColorResources.getImageBg(context),
                      favColor: ColorResources.primaryColor,
                      isSelected: Provider.of<WishListProvider>(context,listen: false).isWish,
                      productId: productModel.id,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                    InkWell(
                      onTap: () {
                        if(Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink != null) {
                          Share.share(Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink);
                        }
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.share, color: Theme.of(context).cardColor, size: Dimensions.ICON_SIZE_SMALL),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              productModel.unitPrice !=null && productModel.discount != 0 ?
              Positioned(
                left: 0,top: 0,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
                      ),
                      child: Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          productModel.discount, productModel.discountType)}',
                        style: titilliumRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                    ),

                  ],
                ),
              ) : SizedBox.shrink(),
              SizedBox.shrink(),


            ]),
          ):SizedBox(),
        ),

      ],
    );
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < productModel.images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == Provider.of<ProductDetailsProvider>(context).imageSliderIndex ?
        Theme.of(context).primaryColor : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: 10,
      ));
    }
    return indicators;
  }

}
