import 'package:flutter/material.dart';
import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/provider/wishlist_provider.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/view/basewidget/animated_custom_dialog.dart';
import 'package:emdad/view/basewidget/guest_dialog.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class FavouriteButton extends StatelessWidget {
  final Color backgroundColor;
  final Color favColor;
  final bool isSelected;
  final int productId;
  FavouriteButton({this.backgroundColor = Colors.black, this.favColor = Colors.white, this.isSelected = false, this.productId});

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: true).checkWishListById(productId.toString(), context);
    }
    feedbackMessage(String message) {
      if (message != '') {
        showCustomSnackBar(message, context, isError: false);
      }
    }

    return GestureDetector(
      onTap: () async {
        if (isGuestMode) {
          showAnimatedDialog(context, GuestDialog(), isFlip: true);
        } else {
          await Provider.of<WishListProvider>(context, listen: false).checkWishListById(productId.toString(), context);
          Provider.of<WishListProvider>(context, listen: false).isWish
              ? Provider.of<WishListProvider>(context, listen: false).removeWishList(productId, feedbackMessage: feedbackMessage)
              : Provider.of<WishListProvider>(context, listen: false).addWishList(productId, feedbackMessage: feedbackMessage);
        }
      },
      child: Consumer<WishListProvider>(
        builder: (context, wishListProvider, child) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              wishListProvider.isWish ? Images.wish_image : Images.wishlist,
              color: favColor,
              height: 16,
              width: 16,
            ),
          ),
        ),
      ),
    );
  }
}
