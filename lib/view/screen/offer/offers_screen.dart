import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/banner_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/custom_expanded_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<BannerProvider>(context, listen: false).getFooterBannerList(context);


    return CustomExpandedAppBar(title: getTranslated('offers', context), child: Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return banner.footerBannerList != null ? banner.footerBannerList.length != 0 ? RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<BannerProvider>(context, listen: false).getFooterBannerList( context);
          },
          child: ListView.builder(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: Provider.of<BannerProvider>(context).footerBannerList.length,
            itemBuilder: (context, index) {

              return InkWell(
                onTap: () => _launchUrl(banner.footerBannerList[index].url),
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                          '/${banner.footerBannerList[index].photo}',
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
                      placeholder: Images.placeholder, fit: BoxFit.fill, height: 150,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                          '/${banner.footerBannerList[index].photo}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.fill, height: 150),
                    ),

                     */
                  ),
                ),
              );
            },
          ),
        ) : Center(child: Text('No banner available')) : OfferShimmer();
      },
    ));
  }

  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class OfferShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<BannerProvider>(context).footerBannerList == null,
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResources.WHITE),
          ),
        );
      },
    );
  }
}

