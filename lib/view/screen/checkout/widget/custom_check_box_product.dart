import 'package:flutter/material.dart';
import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:provider/provider.dart';

class CustomCheckBoxProduct extends StatelessWidget {
  final String title;
  final int index;
  CustomCheckBoxProduct({@required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setNotFoundProductMethod(index),
          child: Row(children: [
            Checkbox(
              shape: CircleBorder(),
              value: order.paymentMethodIndex == index,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool isChecked) => order.setNotFoundProductMethod(index),
            ),
            Expanded(
              child: Text(title, style: titleRegular.copyWith(
                color: Theme.of(context).textTheme.bodyText1.color,
              )),
            ),
          ]),
        );
      },
    );
  }
}
