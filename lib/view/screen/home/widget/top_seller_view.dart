import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/provider/top_seller_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopSellerView extends StatelessWidget {
  final bool isHomePage;
  TopSellerView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {

    return Consumer<TopSellerProvider>(
      builder: (context, topSellerProvider, child) {

        return topSellerProvider.topSellerList != null ? topSellerProvider.topSellerList.length != 0 ?
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (1/1),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: isHomePage && topSellerProvider.topSellerList.length > 6? 6: topSellerProvider.topSellerList.length,
          shrinkWrap: true,
          physics: isHomePage ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(topSeller: topSellerProvider.topSellerList[index])));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                          color: Theme.of(context).highlightColor,

                          // boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                        child: CachedNetworkImage(
                          imageUrl: Provider.of<SplashProvider>(context,listen: false).baseUrls.shopImageUrl+'/'+topSellerProvider.topSellerList[index].image,
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
                          image: Provider.of<SplashProvider>(context,listen: false).baseUrls.shopImageUrl+'/'+topSellerProvider.topSellerList[index].image,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1, fit: BoxFit.cover,),
                        ),

                         */
                      ),
                    ),
                  ),
                ],
              ),
            );

          },
        ): SizedBox():TopSellerShimmer();

      },
    );
  }
}

class TopSellerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1),
      ),
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 2, blurRadius: 5)]),
          margin: EdgeInsets.all(3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: Provider.of<TopSellerProvider>(context).topSellerList.length == 0,
                child: Container(decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                )),
              ),
            ),

            Expanded(flex: 3, child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorResources.getTextBg(context),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: Provider.of<CategoryProvider>(context).categoryList.length == 0,
                child: Container(height: 10, color: Colors.white, margin: EdgeInsets.only(left: 15, right: 15)),
              ),
            )),

          ]),
        );

      },
    );
  }
}

