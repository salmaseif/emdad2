import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/category.dart';
import 'package:emdad/data/repository/category_repo.dart';
import 'package:emdad/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});


  List<Category> _categoryList = [];
  List<Category> get categoryList => _categoryList;

  List _categoryListSelected = [];
  List get categoryListSelected => _categoryListSelected;

  int _categorySelectedIndex;
  int get categorySelectedIndex => _categorySelectedIndex;

  bool _checkCategorySelected = false;
  bool get checkCategorySelected =>_checkCategorySelected;

  Future<void> getCategoryList(bool reload, BuildContext context) async {
    if (_categoryList.length == 0 || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response.data.forEach((category) => _categoryList.add(Category.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }

  selectCategories(int index){
    for(int i=0;i<_categoryList.length;i++){
      if(i==index){
        print('index::::: $index');
        print('i::::: $i');
        print('_chooseCategoryList[index].isSelect::::: ${_categoryList[index].isSelected}');
        _categoryList[i].isSelected =  !_categoryList[index].isSelected;
        _checkCategorySelected= true;
      }
      notifyListeners();
    }
  }

  selectCategoriesByIds(String catId){
    for(int i=0;i<_categoryList.length;i++){
      if(_categoryList[i].id.toString() == catId.toString()){
        print('catId::::: $catId');
        print('i::::: $i');
        print('_chooseCategoryList[index].isSelect::::: ${_categoryList[i].isSelected}');
        _categoryList[i].isSelected =  !_categoryList[i].isSelected;
        _checkCategorySelected= true;
      }
      notifyListeners();
    }
  }

  collectCategoriesSelected(){
    _categoryListSelected =[];
    for(int i=0;i<_categoryList.length;i++){
      if (_categoryList[i].isSelected) {
          _categoryListSelected.add(_categoryList[i].id.toString());
        }
      notifyListeners();
    }
  }

}
