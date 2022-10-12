import 'package:emdad/view/basewidget/no_data_screen.dart';
import 'package:emdad/view/basewidget/product_shimmer.dart';
import 'package:emdad/view/basewidget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/helper/product_type.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType productType;
  final ScrollController scrollController;
  ProductView({@required this.productType, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if(productType == ProductType.POPULAR_PRODUCT) {
      Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context, reload: true);
    }

    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).lProductList != null
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        if(productType == ProductType.POPULAR_PRODUCT) {
          pageSize = (Provider.of<ProductProvider>(context, listen: false).latestProductList.length / 10).ceil();
        }
        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
          Provider.of<ProductProvider>(context, listen: false).getLProductList('1', context, reload: true);
        }
      }
    });
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if(productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.latestProductList;
        }

        return Column(children: [

          productList != null ? productList.length > 0 ? ListView.builder(
            itemCount: productList.length,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: productList[index]);
            },
          ) : NoDataScreen() : ListView.builder(
            itemCount: 10,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductShimmer(isEnabled: productList == null, isHomePage: false,);
            },
          ),

          prodProvider.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
