import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/view/screen/product/BrandAndCategoryProductScreenSubCategory.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/provider/banner_provider.dart';
import 'package:emdad/provider/brand_provider.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/top_seller_provider.dart';
import 'package:emdad/view/screen/product/product_details_screen.dart';
import 'package:emdad/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
class MainSectionBannersView extends StatelessWidget {
  final int index;
  const MainSectionBannersView({Key key, this.index}) : super(key: key);

  _clickBannerRedirect(BuildContext context, int id, Product product,  String type){

    final cIndex =  Provider.of<CategoryProvider>(context, listen: false).categoryList.indexWhere((element) => element.id == id);
    final bIndex =  Provider.of<BrandProvider>(context, listen: false).brandList.indexWhere((element) => element.id == id);
    final tIndex =  Provider.of<TopSellerProvider>(context, listen: false).topSellerList.indexWhere((element) => element.id == id);


    if(type == 'category'){
      if(Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
          isBrand: false,
          id: id.toString(),
          name: '${Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name}',
        )));
      }

    }else if(type == 'product'){
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(
        product: product,
      )));

    }else if(type == 'brand'){
      if(Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
          isBrand: true,
          id: id.toString(),
          name: '${Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name}',
        )));
      }

    }else if( type == 'shop'){
      if(Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
          topSellerId: id,
          topSeller: Provider.of<TopSellerProvider>(context,listen: false).topSellerList[tIndex],
        )));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, footerBannerProvider, child) {

            return InkWell(
              onTap: () {
                Provider.of<BannerProvider>(context, listen: false).getProductDetails(context, footerBannerProvider.mainBannerList[index].resourceId.toString());
                _clickBannerRedirect(context, footerBannerProvider.mainBannerList[index].resourceType=='product'?footerBannerProvider.mainBannerList[index].product.id :footerBannerProvider.mainBannerList[index].resourceId,footerBannerProvider.mainBannerList[index].resourceType =='product'?footerBannerProvider.mainBannerList[index].product : null, footerBannerProvider.mainBannerList[index].resourceType);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width/4.1,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                          '/${footerBannerProvider.mainSectionBannerList[index].photo}',
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
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                          '/${footerBannerProvider.mainSectionBannerList[index].photo}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                    ),

                     */
                  ),
                ),
              ),
            );

          },
        ),
      ],
    );
  }


}

