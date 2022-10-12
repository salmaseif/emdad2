import 'package:emdad/utility/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppBars(
  BuildContext context, {
  String title,
  bool centerTitle = true,
  bool enableLeading = true,
  List<Widget> actions,
  void Function() leadingOntap,
  PreferredSizeWidget bottom,
  Color backgroundColor,
  Color leadingIconColor,
  Color titleColor,
}) {
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: (backgroundColor == null) ? info : backgroundColor,
    centerTitle: centerTitle,
    leading: enableLeading
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (leadingOntap == null) ? buildBackOnTap : leadingOntap,
            color: leadingIconColor ?? theme.primaryColor,
          )
        : const SizedBox(),
    title: Text(
      title ?? '',
      style: theme.textTheme.headline3?.copyWith(
        color: titleColor,
      ),
    ),
    actions: actions,
    bottom: bottom,
  );
}

void buildBackOnTap() {
  Get.back<dynamic>();
}
