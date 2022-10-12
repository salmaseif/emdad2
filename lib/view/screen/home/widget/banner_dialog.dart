import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/data/model/response/banner_model.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';

class BannerDialog extends StatelessWidget {
  final BannerModel banner;

  BannerDialog({@required this.banner});

  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: CachedNetworkImage(
              height: 150,

              imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                  '/${banner.photo}',
              fit: BoxFit.cover,
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                return Image( image: imageProvider, fit: BoxFit.cover);},
              placeholder: (context, url) => Image.asset(
                'assets/images/placeholder.png',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 10),
        ),

        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 10),
        ),

        Row(children: [
          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: ColorResources.primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text("إطلب الأن", style: titilliumBold.copyWith(color: ColorResources.WHITE)),
            ),
          )),

        ]),
      ]),
    );
  }
}
