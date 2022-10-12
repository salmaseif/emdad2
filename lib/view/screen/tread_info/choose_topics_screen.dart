import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/screen/tread_info/auth_header_widget.dart';
import 'package:emdad/view/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:emdad/provider/choose_category_provider.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/utility/strings.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChooseTopicsScreen extends StatelessWidget {
  double _crossAxisSpacing = 12, _mainAxisSpacing = 12, _aspectRatio = 0.9;
  int _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    Provider.of<ChooseCategoryProvider>(context, listen: false).initializeChooseCateoryList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            authHeaderWidget(context: context, title: Strings.choose_topics, subTitle: Strings.you_can_choose_topics_and_we_have),
            SizedBox(
              height: 40,
            ),
            Consumer<ChooseCategoryProvider>(
              builder: (context, chooseCategoryProvider, child) => Expanded(
                child: GridView.builder(
                    itemCount: chooseCategoryProvider.chooseCategoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount,
                      crossAxisSpacing: _crossAxisSpacing,
                      mainAxisSpacing: _mainAxisSpacing,
                      childAspectRatio: _aspectRatio,
                    ),
                    itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              //color: ColorResources.COLOR_PRIMARY.withOpacity(.1),
                              ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<ChooseCategoryProvider>(context, listen: false).selectTreadType(index);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        image: chooseCategoryProvider.chooseCategoryList[index].imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,),
                                    ),
                                  ),
                                  Positioned(
                                      right: 5,
                                      top: 5,
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: chooseCategoryProvider.chooseCategoryList[index].isSelect
                                            ? ColorResources.COLOR_PRIMARY
                                            : ColorResources.COLOR_VERY_LIGHT_GRAY,
                                        child: chooseCategoryProvider.chooseCategoryList[index].isSelect
                                            ? Icon(
                                                Icons.done,
                                                size: 15,
                                                color: ColorResources.COLOR_WHITE,
                                              )
                                            : null,
                                      ))
                                ],
                              ),
                              Text(chooseCategoryProvider.chooseCategoryList[index].name)
                            ],
                          ),
                        )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_DEFAULT, right: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                child: CustomButton(
                  buttonText: Strings.done,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )),
          ],
        ),
      ),
    );
  }
}
