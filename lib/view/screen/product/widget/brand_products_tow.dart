import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/view/basewidget/product_shimmer.dart';
import 'package:emdad/view/basewidget/product_widget.dart';
import 'package:provider/provider.dart';

class BrandProductTowView extends StatelessWidget {
  final ScrollController scrollController;
  final int brandId;
  BrandProductTowView({ this.scrollController, this.brandId});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getProductListByBrandId(true, brandId.toString(), context);
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels && Provider.of<ProductProvider>(context, listen: false).sellerProductList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        pageSize = Provider.of<ProductProvider>(context, listen: false).lPageSizeBrand;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
          Provider.of<ProductProvider>(context, listen: false).getProductListByBrandId(true, brandId.toString(), context);
        }
      }

    });

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.productListByBrandIds;

        return Column(children: [

          !prodProvider.firstLoading ? productList.length != 0 ?
          Container(
            height: MediaQuery.of(context).size.width/1.45,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                itemBuilder: (ctx,index){
                  return Container(width: (MediaQuery.of(context).size.width/2)-20,
                      child: ProductWidget(productModel: productList[index]));

                }),
          ): SizedBox.shrink() : ProductShimmer(isHomePage: false ,isEnabled: prodProvider.firstLoading),
          // prodProvider.isLoading ? Center(child: Padding(
          //   padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
          //   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          // )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}

