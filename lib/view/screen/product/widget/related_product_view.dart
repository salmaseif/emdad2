import 'package:flutter/material.dart';
import 'package:emdad/provider/product_provider.dart';
import 'package:emdad/view/basewidget/product_shimmer.dart';
import 'package:emdad/view/basewidget/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class RelatedProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        return Column(children: [

          prodProvider.relatedProductList != null ? prodProvider.relatedProductList.length != 0 ? StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: prodProvider.relatedProductList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: prodProvider.relatedProductList[index]);
            },
          ): Center(child: Text('لا يوجد منتجات مشابهه')) :
          ProductShimmer(isHomePage: false, isEnabled: Provider.of<ProductProvider>(context).relatedProductList == null),
        ]);
      },
    );
  }
}
