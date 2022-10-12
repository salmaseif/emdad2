
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/search_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/no_internet_screen.dart';
import 'package:emdad/view/basewidget/product_shimmer.dart';
import 'package:emdad/view/basewidget/search_widget.dart';
import 'package:emdad/view/screen/search/widget/search_product_widget.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [


            // for tool bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                )],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT),
                    child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  Expanded(
                    child: Container(
                      child: SearchWidget(
                        hintText: getTranslated('SEARCH_HINT', context),
                        onSubmit: (String text) {
                          Provider.of<SearchProvider>(context, listen: false).searchProduct(text, context);
                          Provider.of<SearchProvider>(context, listen: false).saveSearchAddress(text);
                        },
                        onClearPressed: () {
                          Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

            Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                return !searchProvider.isClear ? searchProvider.searchProductList != null ?
                searchProvider.searchProductList.length > 0
                    ? Expanded(child: SearchProductWidget(products: searchProvider.searchProductList, isViewScrollable: true))
                    : Expanded(child: NoInternetOrDataScreen(isNoInternet: false))
                    : Expanded(child: ProductShimmer(isHomePage: false,
                    isEnabled: Provider.of<SearchProvider>(context).searchProductList == null))
                    : Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Consumer<SearchProvider>(
                          builder: (context, searchProvider, child) => StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: searchProvider.historyList.length,
                            itemBuilder: (context, index) => Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<SearchProvider>(context, listen: false).searchProduct(searchProvider.historyList[index], context);
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: ColorResources.getGrey(context)),
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        Provider.of<SearchProvider>(context, listen: false).historyList[index] ?? "",
                                        style: titilliumItalic.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                    ),
                                  ),
                                )),
                            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('SEARCH_HISTORY', context), style: robotoBold),
                                InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      Provider.of<SearchProvider>(context, listen: false).clearSearchAddress();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_DEFAULT,
                                            vertical:Dimensions.PADDING_SIZE_LARGE ),
                                        child: Text(
                                          getTranslated('REMOVE', context),
                                          style: titilliumRegular.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
                                        )))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
