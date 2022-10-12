import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdad/data/model/response/category.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:emdad/provider/category_provider.dart';
import 'package:emdad/utility/Palette.dart';
import 'package:emdad/utility/app_constants.dart';
import 'package:emdad/utility/app_strings.dart';
import 'package:emdad/utility/device_utils.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/ProductWidgetHorizontal.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:emdad/view/screen/cart/cart_screen.dart';
import 'package:emdad/view/screen/product/widget/ProductFilterBottomSheet.dart';
import 'package:emdad/view/screen/product_tap/customeTabView.dart';
import 'package:emdad/view/screen/requstOrder/order_bottom_sheet.dart';
import 'package:emdad/view/screen/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/no_internet_screen.dart';
import 'package:emdad/view/basewidget/product_shimmer.dart';
import 'package:emdad/view/basewidget/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class BrandAndCategoryProductScreenSubCategory extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String name;
  final String image;
  BrandAndCategoryProductScreenSubCategory({@required this.isBrand, @required this.id, @required this.name, this.image});

  @override
  State<BrandAndCategoryProductScreenSubCategory> createState() => _BrandAndCategoryProductScreenSubCategoryState();
}

class _BrandAndCategoryProductScreenSubCategoryState extends State<BrandAndCategoryProductScreenSubCategory> with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  List<Category> items;
  int selectedIndex = 1;
  int initPosition = 0;
  bool verticalOrHorizontal = false;

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).filterProducts(int.parse(widget.id));
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(widget.isBrand, widget.id, context);
    items = Provider.of<CategoryProvider>(context, listen: false).categoryList;
    Provider.of<ProductProvider>(context, listen: false).getSubSubCategoryList(context, int.parse(widget.id));
    Provider.of<ProductProvider>(context, listen: false).getSubCategoryList(context, int.parse(widget.id));
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void onItemClick(int index, Category obj) {
    //MyToast.show("News " + index.toString() + "clicked", context, duration: MyToast.LENGTH_SHORT);
  }

  Future<void> _refreshProduct() async {
    Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context);
    Provider.of<ProductProvider>(context, listen: false).getCategoryListForMe(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).highlightColor,
        elevation: 0,
        centerTitle: true,
        title:  Text( widget.name,
          style: TextStyle(fontFamily: proxima_nova_bold, color: Palette.loginhead),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return  Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20, color: ColorResources.COLOR_BLACK),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: IconButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
                    },
                    icon: Stack(clipBehavior: Clip.none, children: [
                      Image.asset(
                        Images.search,
                        height: Dimensions.ICON_SIZE_HALF_SMALL,
                        width: Dimensions.ICON_SIZE_HALF_SMALL,
                        color: ColorResources.getPrimary(context),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: IconButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
                    },
                    icon: Stack(clipBehavior: Clip.none, children: [
                      Image.asset(
                        Images.cart_arrow_down_image,
                        height: Dimensions.ICON_SIZE_HALF_SMALL,
                        width: Dimensions.ICON_SIZE_HALF_SMALL,
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
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(1),
        child:  Consumer<ProductProvider>(builder: (ctx, productProvider,child){
          return  productProvider.categoryList.length > 0
              ? CustomTabView(
                   initPosition: initPosition,
                    // itemCount: data.data.length,
                    itemCount: productProvider.subSubFilterCategoryNames.length > 1 ? productProvider.subSubFilterCategoryNames.length : 1,
                    tabBuilder: (context, index) => Tab(text: productProvider.subSubFilterCategoryNames[index]),
                    pageBuilder: Provider.of<ProductProvider>(context, listen: false).isLoadingProduct == false
                        ? (context, index) => _productList(productProvider.subSubFilterCategoryIds[index])
                        : (context, index) => Expanded(child: ProductShimmer(isHomePage: false, isEnabled: false)),
                    onPositionChange: (index) {
                      print('current position: $index');
                      initPosition = index;
                      if(productProvider.subSubFilterCategoryIds[index] != 0) {
                        Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, productProvider.subSubFilterCategoryIds[index].toString(), context);
                        setState(() {});
                      } else {
                        Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, widget.id.toString(), context);
                        setState(() {});
                      }
                    },
                onScroll: (position) => print('position::::::::::::$position'),
              )
              : Center(
                child: Container(
                  child:  OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => OrderBottomSheet(callback: (){
                        showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                      },));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 40, padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text('اطلب منتجك الأن', style: titilliumRegular.copyWith(color: ColorResources.GAINS_BORO))
                    ),
                ),),
          );
        }),
      ),
    );
  }

  _productList(int id) {
    return RefreshIndicator(
      color: Palette.green,
      onRefresh: _refreshProduct,
      child: Column(
          children: [
            Row(
              children: [
                Expanded( child: Text('${getTranslated('item_found', context)} : ${widget.name}',style: robotoRegular.copyWith(color: Theme.of(context).hintColor),)),
                InkWell(
                  onTap: () => showModalBottomSheet(context: context,
                      isScrollControlled: true, backgroundColor: Colors.transparent,
                      builder: (c) => ProductFilterBottomSheet()),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${getTranslated('SORT', context)}',style: robotoRegular.copyWith(color: Theme.of(context).hintColor),),
                          Image.asset(Images.dropdown, scale: 3),
                    ])
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      verticalOrHorizontal = ! verticalOrHorizontal;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(Images.more_image, scale: 3),
                  ),
                ),
              ],
            ),
            Divider(height: 0, color: Theme.of(context).hintColor),
            Container(
               child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return productProvider.sortProductListItem.length > 0
                    ? verticalOrHorizontal == true
                      ? Expanded(
                          child: StaggeredGridView.countBuilder(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            itemCount: productProvider.sortProductListItem.length,
                            shrinkWrap: true,
                            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductWidget(productModel: productProvider.sortProductListItem[index]);
                            },
                          ),
                        )
                      : Expanded(
                          child: StaggeredGridView.countBuilder(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 1,
                            itemCount: productProvider.sortProductListItem.length,
                            shrinkWrap: true,
                            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductWidgetHorizontal(productModel: productProvider.sortProductListItem[index]);
                            },
                          ),
                        )
                    : Expanded(child: Center(child: productProvider.hasData
                      ? ProductShimmer(isHomePage: false,isEnabled: Provider.of<ProductProvider>(context).sortProductListItem.length == 0)
                      : NoInternetOrDataScreen(isNoInternet: false),
                ));
              },
            ),
            ),
          ])
    );
  }

  showModelSheet(Product productData) async {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Palette.sheet,
      context: context,
      elevation: 10,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width /4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /4,
                        height: MediaQuery.of(context).size.height /4,
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            placeholder: (ctx, url) => Image.asset(Images.placeholder,),
                            errorWidget: (ctx,url,err) => Image.asset(Images.placeholder,),
                            imageUrl: '${AppConstants.BASE_URL}/${productData.thumbnail}',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2.48,
                                  child: Text(
                                    productData.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontSize: 16,
                                        fontFamily: proxima_nova_bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 12,
                                  fontFamily: proxima_nova_reg),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$ ${productData.unitPrice}',
                                  style: TextStyle(
                                      color: Palette.loginhead,
                                      fontSize: 16,
                                      fontFamily: proxima_nova_reg),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated('customization_list', context),
                        style: TextStyle(
                            fontSize: 15, color: Palette.loginhead, fontFamily: "ProximaBold"),
                      ),
                      GestureDetector(
                        onTap: () {
                          DeviceUtils.displayAlert(context);
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomizationOptionScreen()));*/
                        },
                        child: Text(
                          getTranslated('edit_customization_list', context),
                          style: TextStyle(
                              fontSize: 16, color: Palette.blue, fontFamily: "ProximaNova"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width /4,
                  height: MediaQuery.of(context).size.height /4,
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return productProvider.sellerProductList.length > 0
                          ? ListView.builder(
                          itemCount: productProvider.sellerProductList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: MediaQuery.of(context).size.height /4,
                              child: ListView.builder(
                                itemCount: productProvider.sellerProductList.length,
                                itemBuilder: (context, index) {
                                  return productProvider.sellerProductList.length > 0
                                      ? Container(
                                    margin: EdgeInsets.only(bottom: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${productProvider.sellerProductList[index].name}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Palette.loginhead,
                                              fontFamily: "ProximaBold"),
                                        ),
                                        Text(
                                          "\u0024 ${productProvider.sellerProductList[index].unitPrice}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Palette.loginhead,
                                              fontFamily: "ProximaNova"),
                                        ),
                                      ],
                                    ),
                                  )
                                      : Text(getTranslated('nothing_found', context));
                                },
                              ),
                            );
                          })
                          : Center(child: Text(getTranslated('nothing_found', context)));

                    },
                  ),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}