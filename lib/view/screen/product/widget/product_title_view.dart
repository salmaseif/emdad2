import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/provider/product_details_provider.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';


class ProductTitleView extends StatefulWidget {
  final Product productModel;
  ProductTitleView({@required this.productModel});

  @override
  State<ProductTitleView> createState() => _ProductTitleViewState();
}

class _ProductTitleViewState extends State<ProductTitleView> {
  double _startingPrice = 0;
  double _endingPrice;

  @override
  Widget build(BuildContext context) {
    if(widget.productModel.variation != null && widget.productModel.variation.length != 0) {
      List<double> _priceList = [];
      widget.productModel.variation.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = widget.productModel.unitPrice;
    }

    return widget.productModel != null? Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, details, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(widget.productModel.name ?? '',
                  style: titleRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), maxLines: 2)),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            ]),

            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

            Row(children: [

              Text('${details.reviewList != null ? details.reviewList.length : 0} تقييم | ', style: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              )),

              Text('${details.orderCount} طلبات | ', style: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              )),

              Text('${details.wishCount} مفضل', style: titilliumRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
              )),

              Expanded(child: SizedBox.shrink()),

              /*
              SizedBox(width: 5),

              Row(children: [
                Icon(Icons.star, color: Colors.orange,),
                Text('${widget.productModel.rating != null ? widget.productModel.rating.length > 0 ?
                double.parse(widget.productModel.rating[0].average) : 0.0 : 0.0}')
              ],),
              */
            ]),
          ]);
        },
      ),
    ):SizedBox();
  }
}
