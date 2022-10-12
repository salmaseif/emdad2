import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/view/screen/product/BrandAndCategoryProductScreenSubCategory.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  CategoryView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {

        return categoryProvider.categoryList.length != 0 ?
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 5,
            childAspectRatio: (1/1.4),
          ),
          itemCount: isHomePage
              ? categoryProvider.categoryList.length > 8
                 ? 8
                 : categoryProvider.categoryList.length
              : categoryProvider.categoryList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                  isBrand: false,
                  id: categoryProvider.categoryList[index].id.toString(),
                  name: categoryProvider.categoryList[index].name,
                )));
              },
              child: Column( children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.2)),
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).highlightColor,
                    // boxShadow: [BoxShadow(
                    //   color: Colors.grey.withOpacity(0.3),
                    //   spreadRadius: 1,
                    //   blurRadius: 3,
                    //   offset: Offset(0, 3), // changes position of shadow
                    // )],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    child: CachedNetworkImage(
                      imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.categoryImageUrl}'
                          '/${categoryProvider.categoryList[index].icon}',
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
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.categoryImageUrl}'
                          '/${categoryProvider.categoryList[index].icon}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover,),
                    ),

                     */
                  ),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(
                  child: Center(
                    child: Text(
                      categoryProvider.categoryList.length!=0 ?
                      categoryProvider.categoryList[index].name : getTranslated('CATEGORY', context),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: ColorResources.getTextTitle(context)),
                    ),
                  ),
                ),

              ]),
            );

          },
        )

        : CategoryShimmer();

      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1),
      ),
      itemCount: 8,
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
                enabled: Provider.of<CategoryProvider>(context).categoryList.length == 0,
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

