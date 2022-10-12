import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/utility/app_constants.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/Palette.dart';
import 'package:emdad/utility/app_strings.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/utility/device_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'customeTabView.dart';

class ProductScreenTap extends StatefulWidget {
  @override
  _ProductScreenTapState createState() => _ProductScreenTapState();
}

class _ProductScreenTapState extends State<ProductScreenTap> with TickerProviderStateMixin {
  // TabController controllerTab = TabController();
  int selectedIndex = 1;
  int initPosition = 0;

  @override
  void initState() {
    super.initState();
    var sellerId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString();
    sellerId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, 1, context, reload: true);
  }

  Future<void> _refreshProduct() async {
    Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context);
    Provider.of<ProductProvider>(context, listen: false).getCategoryListForMe(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
         getTranslated('my_products', context),
          style: TextStyle(fontFamily: proxima_nova_bold, color: Palette.loginhead),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Palette.loginhead,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductSearchScreen()));
                  },
                ),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Palette.loginhead,
                    ),
                    onPressed: () {
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductScreen(isEdit: false)));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(10),
          child:  Consumer<ProductProvider>(builder: (ctx, colorP,child){
            return  colorP.categoryNames.length > 0
                ? CustomTabView(
                  initPosition: initPosition,
                  // itemCount: data.data.length,
                  itemCount: colorP.categoryListFilterNames.length > 1 ? colorP.categoryListFilterNames.length : 1,
                  tabBuilder: (context, index) => Tab(text: colorP.categoryListFilterNames[index]),
                  pageBuilder: Provider.of<ProductProvider>(context, listen: false).isLoadingProduct == false
                    ? (context, index) => _productList(colorP.categoryListFilterIds[index])
                    : (context, index) => Expanded(child: ProductShimmer()),
                  onPositionChange: (index) {
                    print('current position: $index');
                    initPosition = index;
                    Provider.of<ProductProvider>(context, listen: false).filterProducts(colorP.categoryListFilterIds[index]);
                  },
                  onScroll: (position) => print('position::::::::::::$position'),
                )
            : Center(
              child: Container(child: Text('No Data To Show')),
            );
          }),
      ),
    );
  }

  _productList(int id) {
    return RefreshIndicator(
      color: Palette.green,
      onRefresh: _refreshProduct,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Container(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return ListView.builder(
                itemCount: productProvider.sellerProductListFilter.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModelSheet(productProvider.sellerProductListFilter[index]);
                    },
                    child: Container(
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
                      width: 100.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 18.w,
                            height: 20.w,
                            margin: EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                placeholder: (ctx, url) => Image.asset(Images.placeholder,),
                                errorWidget: (ctx,url,err) => Image.asset(Images.placeholder,),
                                imageUrl: '${AppConstants.BASE_URL}/${productProvider.sellerProductList[index].images}',
                              ),
                            ),
                          ),
                          Container(
                            width: 48.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2.48,
                                      child: Text(
                                        productProvider.sellerProductListFilter[index].name,
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
                                Row(
                                  children: [
                                    Text(getTranslated('discount', context),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Palette.switchs,
                                          fontSize: 12,
                                          fontFamily: proxima_nova_reg),
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Text(productProvider.sellerProductListFilter[index].discount != null
                                        ? productProvider.sellerProductListFilter[index].discount.toString()
                                      : 0,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Palette.switchs,
                                          fontSize: 12,
                                          fontFamily: proxima_nova_reg),
                                    ),
                                    Container(
                                        width: 10,
                                    ),
                                    Container(
                                      height: 20,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(Icons.remove_red_eye_outlined, color: Colors.orange, size: 12),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '\$ ${productProvider.sellerProductListFilter[index].unitPrice}',
                                      style: TextStyle(
                                          color: Palette.loginhead,
                                          fontSize: 14,
                                          fontFamily: proxima_nova_reg),
                                    ),
                                    Text(
                                      "  |  ",
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
                  );
                });
              },
            ),
          )),
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
                  width: 100.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 18.w,
                        height: 20.w,
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
                        width: 48.w,
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
                  width: 100.w,
                  height: 30.w,
                  child: Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                          return productProvider.sellerProductList.length > 0
                          ? ListView.builder(
                                  itemCount: productProvider.sellerProductList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(left: 20, right: 20),
                                      height: 20.w,
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

class ProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).highlightColor,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 150, color: ColorResources.WHITE),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Container(height: 45, color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(height: 20, color: ColorResources.WHITE),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(height: 10, width: 70, color: Colors.white),
                              SizedBox(width: 10),
                              Container(height: 10, width: 20, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
