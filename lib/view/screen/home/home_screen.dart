import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/view/basewidget/my_text.dart';
import 'package:emdad/view/basewidget/product_widget.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/address/saved_address_list_screen.dart';
import 'package:emdad/view/screen/featureddeal/featured_deal_screen.dart';
import 'package:emdad/view/screen/flashdeal/flash_deal_screen.dart';
import 'package:emdad/view/screen/home/widget/footer_banner.dart';
import 'package:emdad/view/screen/order/order_screen.dart';
import 'package:emdad/view/screen/product/BrandAndCategoryProductScreenSubCategory.dart';
import 'package:emdad/view/screen/product/product_details_screen.dart';
import 'package:emdad/view/screen/requstOrder/order_bottom_sheet.dart';
import 'package:emdad/view/screen/tread_info/steppers_dots.dart';
import 'package:emdad/view/screen/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';

import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/banner_provider.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/provider/featured_deal_provider.dart';
import 'package:emdad/provider/flash_deal_provider.dart';
import 'package:emdad/provider/home_category_product_provider.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/provider/splash_provider.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:emdad/provider/top_seller_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/title_row.dart';
import 'package:emdad/view/screen/brand/all_brand_screen.dart';
import 'package:emdad/view/screen/cart/cart_screen.dart';
import 'package:emdad/view/screen/home/widget/announcement.dart';
import 'package:emdad/view/screen/home/widget/banners_view.dart';
import 'package:emdad/view/screen/home/widget/brand_view.dart';
import 'package:emdad/view/screen/search/search_screen.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  String currentAddress = "يرجى الانتضار";
  bool isCurrentAddress = false;

  int isDocComplete = 1;
  int isDocRequest = 0;

  Future<void> _loadData(BuildContext context, bool reload) async {
     await Provider.of<BannerProvider>(context, listen: false).getBannerList(reload, context);
     await Provider.of<BannerProvider>(context, listen: false).getFooterBannerList(context);
     await Provider.of<BannerProvider>(context, listen: false).getMainSectionBanner(context);
     await Provider.of<TopSellerProvider>(context, listen: false).getTopSellerList(reload, context);
     //await Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(reload, context,_languageCode,true);
     await Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, context, reload: reload);
     await Provider.of<ProductProvider>(context, listen: false).getFeaturedProductList('1', context, reload: reload);
     await Provider.of<FeaturedDealProvider>(context, listen: false).getFeaturedDealList(reload, context);
     await Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context, reload: reload);
     Provider.of<HomeCategoryProductProvider>(context, listen: false).getHomeCategoryProductList(true, context);
  }

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";
    Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(true, context, true);

    _loadData(context, false);

    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<CartProvider>(context, listen: false).uploadToServer(context);
      Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    }else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }

    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isDoc == 0){
      isDocComplete = 0;
    } else {
      isDocComplete = 1;
    }
    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.isDocReq == 0){
      isDocRequest = 0;
    } else {
      isDocRequest = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
   List<String> types =[getTranslated('new_arrival', context),getTranslated('top_product', context), getTranslated('best_selling', context),  getTranslated('discounted_product', context)];
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await _loadData(context, true);
            await Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(true, context, false);
            return true;
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).highlightColor,
                    title: Image.asset(Images.logo_with_name_image, height: 35),
                    actions: [
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => SavedAddressListScreen())),
                         child:  Consumer<ProfileProvider>(
                          builder: (context, profileProviderAddress, child) {
                          return profileProviderAddress.addressList.length > 0
                              ? Container(
                              // width: SizeConfig.blockSizeHorizontal * 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular( 7 )
                                ),
                              child: Padding(
                                    padding: const EdgeInsets.all( 10.0 ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            border: Border.all(width: .7, color: Theme.of(context).primaryColor.withOpacity(.9))
                                        ),
                                      child: Padding(
                                        padding: const EdgeInsets.all( 5.0 ),
                                        child: Text(
                                          "عنوان التوصيل:${profileProviderAddress.addressList.first.address.length> 20 ? '${profileProviderAddress.addressList.first.address.substring(0, 20)}...' : profileProviderAddress.addressList.first.address}",
                                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor,),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                            )
                          : SizedBox.shrink();
                          }
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
                          },
                          icon: Stack(clipBehavior: Clip.none, children: [
                            Image.asset(
                              Images.cart_arrow_down_image,
                              height: Dimensions.ICON_SIZE_DEFAULT,
                              width: Dimensions.ICON_SIZE_DEFAULT,
                              color: ColorResources.getPrimary(context),
                            ),
                            Positioned(top: -4, right: -4,
                              child: Consumer<CartProvider>(builder: (context, cart, child) {
                                return CircleAvatar(radius: 7, backgroundColor: ColorResources.RED,
                                  child: Text(cart.cartList.length.toString(),
                                      style: titilliumSemiBold.copyWith(color: ColorResources.WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      )),
                                );
                              }),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  // Search Button
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                          child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
                            child: Container(padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.HOME_PAGE_PADDING, vertical: Dimensions.PADDING_SIZE_SMALL),
                              color: ColorResources.getHomeBg(context),
                              alignment: Alignment.center,
                              child: Container(padding: EdgeInsets.only(
                                left: Dimensions.HOME_PAGE_PADDING, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                top: Dimensions.PADDING_SIZE_EXTRA_SMALL, bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              ),
                                height: 60, alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ?
                                  900 : 200], spreadRadius: 1, blurRadius: 1)],
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_LARGE),),
                                child: Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [

                                  Text(getTranslated('SEARCH_HINT', context),
                                      style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                                  Container(
                                    width: 40,height: 40,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL))
                                  ),
                                    child: Icon(Icons.search, color: Theme.of(context).cardColor, size: Dimensions.ICON_SIZE_SMALL),
                                  ),
                            ]),
                          ),
                        ),
                      ))),

                  SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          isDocRequest == 1
                          ? Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30),),
                                margin: EdgeInsets.all(15),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                        //  Navigator.push(context, MaterialPageRoute(builder: (_) => CustomStepper( )));
                                        },
                                        icon: Icon(Icons.privacy_tip, color: ColorResources.RED,),
                                        label: Container(
                                          alignment: Alignment.center,
                                          height: 40, padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Text('توثيق حسابك قيد الإنتظار', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).hintColor,)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : isDocComplete == 0
                              ? Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30),),
                                    margin: EdgeInsets.all(15),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => CustomStepper( )));
                                            },
                                            icon: Icon(Icons.privacy_tip, color: ColorResources.RED,),
                                            label: Container(
                                              alignment: Alignment.center,
                                              height: 40, padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Text('أكمل معلوماتك حتي تستطيع الطلب', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).hintColor,)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                              : SizedBox(height: 10),
                        ],
                      )
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.HOME_PAGE_PADDING,
                          Dimensions.PADDING_SIZE_SMALL, Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_SMALL  ),
                      child: Column(
                        children: [
                          BannersView(),
                          SizedBox(height: Dimensions.HOME_PAGE_PADDING),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20.0,
                          20.0,
                          20.0,
                          20.0,
                        ),
                        child: buildHomeMenuRow(context),
                      ),
                    ]),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.HOME_PAGE_PADDING,
                          Dimensions.PADDING_SIZE_SMALL, Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_SMALL  ),
                      child: Column(
                        children: [

                          /*
                          // Category
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: getTranslated('CATEGORY', context),
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllCategoryScreen()))),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                            child: CategoryView(isHomePage: true),
                          ),
                           */
                          // Mega Deal
                          /*
                          Consumer<FlashDealProvider>(
                            builder: (context, flashDeal, child) {
                              return  (flashDeal.flashDeal != null && flashDeal.flashDealList != null
                                  && flashDeal.flashDealList.length > 0)
                                  ? TitleRow(title: getTranslated('flash_deal', context),
                                      eventDuration: flashDeal.flashDeal != null ? flashDeal.duration : null,
                                      onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => FlashDealScreen()));
                                      },
                                  isFlash: true,
                                      )
                                  : SizedBox.shrink();
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Consumer<FlashDealProvider>(
                            builder: (context, megaDeal, child) {
                              return  (megaDeal.flashDeal != null && megaDeal.flashDealList != null && megaDeal.flashDealList.length > 0)
                                  ? Container(height: MediaQuery.of(context).size.width*.77,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                                    child: FlashDealsView(),
                                  )) : SizedBox.shrink();},),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          */
                          // Brand
                          Padding(
                            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: getTranslated('brand_market', context),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllBrandScreen()));}
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          BrandView(isHomePage: true),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          //footer banner
                          Consumer<BannerProvider>(builder: (context, footerBannerProvider, child){
                            return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList.length > 0?
                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                              child: FooterBannersView(index: 0,),
                            ):SizedBox();
                          }),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                           Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                ),
                                child:  Consumer<CategoryProvider>(
                                    builder: (context, categoryProvider, child) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: categoryProvider.categoryList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                          categoryProvider.categoryList[index].id != 1363
                                           ?  Container(
                                              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 35.0),
                                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *.5),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).highlightColor,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(150),
                                                    bottomRight: Radius.circular(150),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.transparent.withOpacity(0.2),
                                                        offset: Offset(0.0,5.0),
                                                        blurRadius: 10.0,
                                                        spreadRadius: 0.5
                                                    )
                                                  ]
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                  0.0,
                                                  5.0,
                                                  5.0,
                                                  5.0,
                                                ),
                                                child:  Text(
                                                     '${categoryProvider.categoryList[index].name}',
                                                      style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                                    ),
                                              ),
                                            )
                                            : SizedBox.shrink(),
                                           // Text('${categoryProvider.categoryList[index].name}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                            categoryProvider.categoryList[index].id != 1363
                                            ? Container(
                                              decoration: BoxDecoration(
                                               color: Theme.of(context).cardColor,
                                               borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                              ),
                                               child: GridView.builder(
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        crossAxisSpacing: 5,
                                                        mainAxisSpacing: 3,
                                                        childAspectRatio: (1/1.1),
                                                      ),
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: categoryProvider.categoryList[index].subCategories.length,
                                                      itemBuilder: (context, i) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                                                              isBrand: false,
                                                              id: categoryProvider.categoryList[index].subCategories[i].id.toString(),
                                                              name: categoryProvider.categoryList[index].subCategories[i].name,
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
                                                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                                                                child: CachedNetworkImage(
                                                                  width: 100,
                                                                  height: 90,
                                                                  imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.categoryImageUrl}'
                                                                      '/${categoryProvider.categoryList[index].subCategories[i].icon}',
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

                                                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                            Container(
                                                              child: Center(
                                                                child: Text(
                                                                  categoryProvider.categoryList[index].subCategories.length!=0 ?
                                                                  categoryProvider.categoryList[index].subCategories[i].name : getTranslated('CATEGORY', context),
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
                                                    ),
                                                    )
                                            : SizedBox.shrink(),
                                            categoryProvider.categoryList[index].id != 1363
                                                ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                                                : SizedBox.shrink(),
                                            categoryProvider.categoryList[index].id != 1363
                                                ? Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                                        child: TitleRow(title: 'منتجات ${categoryProvider.categoryList[index].name} المختارة لك',
                                                          onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                                                            isBrand: false,
                                                            id: categoryProvider.categoryList[index].id.toString(),
                                                            name: categoryProvider.categoryList[index].name,
                                                          )));
                                                        }),
                                                  ),
                                                )
                                                : SizedBox.shrink(),
                                            categoryProvider.categoryList[index].id != 1363
                                                ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                                            : SizedBox.shrink(),
                                            /*
                                             Padding(
                                              padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                                              child: FeaturedProductView(scrollController: _scrollController, isHome: true,),
                                            ),
                                           */

                                            //اظهار المنتجات
                                            categoryProvider.categoryList[index].id != 1363
                                                ? Consumer<HomeCategoryProductProvider>(
                                                      builder: (context, homeCategoryProductProvider, child) {
                                                       return ConstrainedBox(
                                                          constraints: homeCategoryProductProvider.homeCategoryProductList[index].products.length > 0
                                                              ? BoxConstraints(maxHeight: MediaQuery.of(context).size.width/1.45,)
                                                              : BoxConstraints(maxHeight: 0),
                                                          child: homeCategoryProductProvider.homeCategoryProductList[index].products.length > 0
                                                          ? homeCategoryProductProvider.homeCategoryProductList[index].products.length > 0
                                                              ? ListView.builder(
                                                              itemCount: homeCategoryProductProvider.homeCategoryProductList[index].products.length,
                                                              padding: EdgeInsets.all(0),
                                                              scrollDirection: Axis.horizontal,
                                                              shrinkWrap: true,
                                                              itemBuilder: (BuildContext context, int i) {
                                                                return InkWell(
                                                                  onTap: () {Navigator.push(context, PageRouteBuilder(transitionDuration: Duration(milliseconds: 1000),
                                                                    pageBuilder: (context, anim1, anim2) => ProductDetails(product: homeCategoryProductProvider.productList[i]),
                                                                  ));
                                                                  },
                                                                  child: Container(
                                                                      width: (MediaQuery.of(context).size.width/2)-20,
                                                                      child: ProductWidget(productModel: homeCategoryProductProvider.homeCategoryProductList[index].products[i])
                                                                  ),
                                                                );
                                                              })
                                                          : SizedBox.shrink()
                                                          : SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                                       );
                                                  })
                                                : SizedBox.shrink(),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                            Divider(thickness: 1, color: Theme.of(context).primaryColor.withOpacity(0.3)),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          ]);
                                    },
                                   );
                                } ),
                          ),

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


                          Container(
                            height: 120,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]
                            ),
                            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                              child: InkWell(
                                onTap: () {
                                    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => OrderBottomSheet(callback: (){
                                      showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                    },));
                                  },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("عندك طلب خاص?", style: robotoRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme ?
                                    Colors.white : Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                                    OutlinedButton(
                                      onPressed: () {
                                        showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => OrderBottomSheet(callback: (){
                                          showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                        },));
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Text('اطلب الأن', style: MyText.button(context).copyWith(color: Theme.of(context).primaryColor))
                                      ),
                                    ),
                              ]),
                             ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Container(
                            height: MediaQuery.of(context).size.height*0.15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 2)]
                            ),
                            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreenSubCategory(
                                  isBrand: false,
                                  id: '1364',
                                  name: "طلبيات كبيرة",
                                )));
                              },
                              child:  Image.asset(
                                  'assets/images/bigorder.jpg',
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                         // /*

                          /*
                          //top seller
                          singleVendor?SizedBox():
                          TitleRow(title: getTranslated('top_seller', context),
                            onTap: () {
                              Shared.onPopEventHandler(_interstitialAd);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => AllTopSellerScreen(topSeller: null,)));},
                          ),
                          singleVendor?SizedBox(height: 0):SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          singleVendor?SizedBox():
                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                            child: TopSellerView(isHomePage: true),
                          ),

                          //footer banner
                          Consumer<BannerProvider>(builder: (context, footerBannerProvider, child){
                            return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList.length > 0?
                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                              child: FooterBannersView(index: 0,),
                            ):SizedBox();
                          }),

                          // Featured Products
                          Consumer<ProductProvider>(
                            builder: (context, featured,_) {
                              return featured.featuredProductList!=null && featured.featuredProductList.length>0 ?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                  child: TitleRow(title: getTranslated('featured_products', context),
                                      onTap: () {
                                        Shared.onPopEventHandler(_interstitialAd);
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.FEATURED_PRODUCT)));}),
                                ),
                              ):SizedBox();
                            }
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                            child: FeaturedProductView(scrollController: _scrollController, isHome: true,),
                          ),

                          // Featured Deal
                          Consumer<FeaturedDealProvider>(
                            builder: (context, featuredDealProvider, child) {
                              return featuredDealProvider.featuredDealList == null
                                  ? TitleRow(title: getTranslated('featured_deals', context),
                                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => FeaturedDealScreen()));}) :
                              (featuredDealProvider.featuredDealList != null && featuredDealProvider.featuredDealList.length > 0) ?
                              Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                child: TitleRow(title: getTranslated('featured_deals', context),
                                    onTap: () {
                                      Shared.onPopEventHandler(_interstitialAd);
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => FeaturedDealScreen()));}),
                              ) : SizedBox.shrink();},),

                          Consumer<FeaturedDealProvider>(
                            builder: (context, featuredDeal, child) {
                              return featuredDeal.featuredDealList == null && featuredDeal.featuredDealList.length > 0?
                              Container(height: 150, child: FeaturedDealsView()) : (featuredDeal.featuredDealList != null && featuredDeal.featuredDealList.length > 0) ?
                              Container(height: featuredDeal.featuredDealList.length> 4 ? 120 * 4.0 : 120 * (double.parse(featuredDeal.featuredDealList.length.toString())),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                                    child: FeaturedDealsView(),
                                  )) : SizedBox.shrink();},),


                          Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                            child: RecommendedProductView(),
                          ),


                          //footer banner
                          Consumer<BannerProvider>(builder: (context, footerBannerProvider, child){
                            return footerBannerProvider.mainSectionBannerList != null &&
                                footerBannerProvider.mainSectionBannerList.length > 0?
                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                              child: MainSectionBannersView(index: 0,),
                            ):SizedBox();

                          }),


                          // Latest Products
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: TitleRow(title: getTranslated('latest_products', context),
                                onTap: () {
                                  Shared.onPopEventHandler(_interstitialAd);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(
                                    productType: ProductType.LATEST_PRODUCT)));}),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          LatestProductView(scrollController: _scrollController),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          //Home category
                          HomeCategoryProductView(isHomePage: true),
                          SizedBox(height: Dimensions.HOME_PAGE_PADDING),

                          
                          //footer banner
                          Consumer<BannerProvider>(builder: (context, footerBannerProvider, child){
                            return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList.length>1?
                            FooterBannersView(index: 1):SizedBox();
                          }),
                          SizedBox(height: Dimensions.HOME_PAGE_PADDING),


                          //Category filter
                          Consumer<ProductProvider>(
                              builder: (ctx,prodProvider,child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Row(children: [
                                Expanded(child: Text(prodProvider.title == 'xyz' ? getTranslated('new_arrival',context):prodProvider.title, style: titleHeader)),
                                prodProvider.latestProductList != null ? PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(value: ProductType.NEW_ARRIVAL, child: Text(getTranslated('new_arrival',context)), textStyle: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                         )),
                                      PopupMenuItem(value: ProductType.TOP_PRODUCT, child: Text(getTranslated('top_product',context)), textStyle: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        )),
                                      PopupMenuItem(value: ProductType.BEST_SELLING, child: Text(getTranslated('best_selling',context)), textStyle: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                       )),
                                      PopupMenuItem(value: ProductType.DISCOUNTED_PRODUCT, child: Text(getTranslated('discounted_product',context)), textStyle: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                      )),
                                    ];
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical:Dimensions.PADDING_SIZE_SMALL ),
                                    child: Image.asset(Images.dropdown, scale: 3,),
                                  ),
                                  onSelected: (value) {
                                    if(value == ProductType.NEW_ARRIVAL){
                                      Provider.of<ProductProvider>(context, listen: false).changeTypeOfProduct(value, types[0]);
                                    }else if(value == ProductType.TOP_PRODUCT){
                                      Provider.of<ProductProvider>(context, listen: false).changeTypeOfProduct(value, types[1]);
                                    }else if(value == ProductType.BEST_SELLING){
                                      Provider.of<ProductProvider>(context, listen: false).changeTypeOfProduct(value, types[2]);
                                    }else if(value == ProductType.DISCOUNTED_PRODUCT){
                                      Provider.of<ProductProvider>(context, listen: false).changeTypeOfProduct(value, types[3]);
                                    }

                                    ProductView(isHomePage: false, productType: value, scrollController: _scrollController);
                                    Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, context, reload: true);


                                  }
                                ) : SizedBox(),
                              ]),
                            );
                          }),
                          ProductView(isHomePage: false, productType: ProductType.NEW_ARRIVAL, scrollController: _scrollController),
                          SizedBox(height: Dimensions.HOME_PAGE_PADDING),
                           */
                        ],
                      ),
                    ),
                  )
                ],
              ),

              /*
              //footer banner
              Consumer<BannerProvider>(builder: (context, footerBannerProvider, child){
                return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList.length > 0?
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.HOME_PAGE_PADDING),
                  child: FooterBannersView(index: 0,),
                ):SizedBox();
              }),


               */
              Provider.of<SplashProvider>(context, listen: false).configModel.announcement.status == '1'?
              Positioned(top: MediaQuery.of(context).size.height-128,
                left: 0,right: 0,
                child: Consumer<SplashProvider>(
                  builder: (context, announcement, _){
                    return announcement.onOff?
                    AnnouncementScreen(announcement: announcement.configModel.announcement):SizedBox();
                  },
                ),
              ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  buildHomeMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderScreen();
              }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 1)) // changes position of shadow
                        ]
                    ),
                    child: Icon(
                      Icons.more_time,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "طلبتها سابقا",
                    textAlign: TextAlign.center,
                    style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealScreen();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                        ]
                    ),
                    child: Icon(
                      Icons.percent_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("عروض التوفير",
                        textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FeaturedDealScreen();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                        ]
                    ),
                    child: Icon(
                      Icons.local_fire_department_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("الأكثر مبيعا",
                        textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
             return WishListScreen();
             }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                        ]
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("مفضلتك",
                        textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 || oldDelegate.minExtent != 70 || child != oldDelegate.child;
  }
}
