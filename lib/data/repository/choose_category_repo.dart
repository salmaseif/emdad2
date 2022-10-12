import 'package:emdad/data/model/body/choose_category_model.dart';
import 'package:emdad/utility/images.dart';
import 'package:emdad/utility/strings.dart';

class ChooseCategoryRepo {
  List<ChooseCategoryModel> getChooseCategoryList = [
    ChooseCategoryModel(imageUrl: Images.market, name: Strings.market, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.cafe, name: Strings.cafe, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.restaurant, name: Strings.restaurant, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.hotel, name: Strings.hotel, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.hotel, name: Strings.halls, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.school, name: Strings.school, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.office, name: Strings.office, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.office, name: Strings.corporation, isSelect: false),
    ChooseCategoryModel(imageUrl: Images.medicine, name: Strings.medicine, isSelect: false),
  ];
}
