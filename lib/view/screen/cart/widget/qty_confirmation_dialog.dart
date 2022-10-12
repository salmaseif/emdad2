import 'package:emdad/data/model/response/cart_model.dart';
import 'package:emdad/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';

class QuantityConfirmationDialog extends StatelessWidget {
  final quantityItem;
  final CartModel cartModel;
  final bool isIncrement;
  final int quantity;
  final int index;
  final int maxQty;
  
  QuantityConfirmationDialog({@required this.quantityItem, @required this.isIncrement, @required this.quantity, @required this.index, @required this.maxQty,@required this.cartModel});

  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 25),
          child: Text(getTranslated('set_quantity_alert', context), style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE), textAlign: TextAlign.center),
        ),
        Text(getTranslated('insert_quantity', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child:  Row(
            children: <Widget>[

              Expanded(flex: 4,
                child: Container( height: 60,
                  decoration: BoxDecoration(
                    color: ColorResources.getHomeBg(context),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: .4,color: Theme.of(context).highlightColor.withOpacity(.20)),
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), spreadRadius: 1, blurRadius: 1)],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                        TextField(
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          ),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: quantity.toString(),
                          hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR, fontSize: 18),
                          border: InputBorder.none,
                        ),
                      ),
                  ])
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 10),
        ),
        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel.id, int.parse(_quantityController.text), context).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
                ));
              });
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('set_quantity', context), style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: ColorResources.RED, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('cancel', context), style: titilliumBold.copyWith(color: ColorResources.WHITE)),
            ),
          )),

        ]),
      ]),
    );
  }
}
