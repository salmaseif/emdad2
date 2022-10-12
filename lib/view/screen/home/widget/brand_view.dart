import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/view/screen/product/BrandAndCategoryProductScreenSubCategory.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/brand_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BrandView extends StatelessWidget {
  final bool isHomePage;
  BrandView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {

        return brandProvider.brandList.length != 0 ?
        isHomePage?
        ConstrainedBox(
          constraints: brandProvider.brandList.length > 0 ? BoxConstraints(maxHeight: 130):BoxConstraints(maxHeight: 0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brandProvider.brandList.length,
              itemBuilder: (ctx,index){

                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                      isBrand: true,
                      id: brandProvider.brandList[index].id.toString(),
                      name: brandProvider.brandList[index].name,
                      image: brandProvider.brandList[index].image,
                    )));
                   },
                  child: Padding(
                    padding:  EdgeInsets.only(right: 10),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width/5.9),
                            height: (MediaQuery.of(context).size.width/5.9),
                            //padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.width/5))),
                                color: Theme.of(context).highlightColor,
                                 ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular((MediaQuery.of(context).size.width/5))),
                              child: CachedNetworkImage(
                                imageUrl: Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl+'/'+brandProvider.brandList[index].image,
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
                                fit: BoxFit.cover,
                                placeholder: Images.placeholder,
                                image: Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl+'/'+brandProvider.brandList[index].image,
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,  fit: BoxFit.cover,),
                              ),

                               */
                            ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width/4) * 0.3,
                            child: Center(child: Text(
                              brandProvider.brandList[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              }),
        ):
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: (1/1.3),
            mainAxisSpacing: 10,
            crossAxisSpacing: 5,
          ),
          itemCount: brandProvider.brandList.length != 0
              ? isHomePage
              ? brandProvider.brandList.length > 8
              ? 8
              : brandProvider.brandList.length
              : brandProvider.brandList.length
              : 8,
          shrinkWrap: true,
          physics: isHomePage ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                  isBrand: true,
                  id: brandProvider.brandList[index].id.toString(),
                  name: brandProvider.brandList[index].name,
                  image: brandProvider.brandList[index].image,
                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl+'/'+brandProvider.brandList[index].image,
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
                          fit: BoxFit.cover,
                          placeholder: Images.placeholder,
                          image: Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl+'/'+brandProvider.brandList[index].image,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,  fit: BoxFit.cover,),
                        ),
                         */
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width/4) * 0.3,
                    child: Center(child: Text(
                      brandProvider.brandList[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    )),
                  ),
                ],
              ),
            );

          },
        ) : BrandShimmer(isHomePage: isHomePage);

      },
    );
  }
}

class BrandShimmer extends StatelessWidget {
  final bool isHomePage;
  BrandShimmer({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: isHomePage ? 8 : 30,
      shrinkWrap: true,
      physics: isHomePage ? NeverScrollableScrollPhysics() : null,
      itemBuilder: (BuildContext context, int index) {

        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<BrandProvider>(context).brandList.length == 0,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: Container(decoration: BoxDecoration(color: ColorResources.WHITE, shape: BoxShape.circle))),
            Container(height: 10, color: ColorResources.WHITE, margin: EdgeInsets.only(left: 25, right: 25)),
          ]),
        );

      },
    );
  }
}
