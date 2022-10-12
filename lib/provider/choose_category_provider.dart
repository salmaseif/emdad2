import 'package:emdad/data/model/body/choose_category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:emdad/data/repository/choose_category_repo.dart';

class ChooseCategoryProvider with ChangeNotifier{
  final ChooseCategoryRepo categoryRepo;
  ChooseCategoryProvider({this.categoryRepo});

  List<ChooseCategoryModel> _chooseCategoryList=[];
  List<ChooseCategoryModel> get chooseCategoryList=>_chooseCategoryList;

  List _collectCategoryList=[];
  List get collectCategoryList=>_collectCategoryList;

  bool _checkTreadType = false;
  bool get checkTreadType =>_checkTreadType;

  String _checkTreadTypeName;
  String get checkTreadTypeName =>_checkTreadTypeName;

  selectCategories(int index){
    for(int i=0;i<_chooseCategoryList.length;i++){
      if(i==index){
        print('index::::: $index');
        print('i::::: $i');
        print('_chooseCategoryList[index].isSelect::::: ${_chooseCategoryList[index].isSelect}');
        _chooseCategoryList[index].isSelect =  !_chooseCategoryList[index].isSelect;
      }
      notifyListeners();
    }
  }


  selectTreadType(int index){
    for(int i=0;i<_chooseCategoryList.length;i++){
      if(i==index){
        print('index::::: $index');
        print('i::::: $i');
        print('selectTreadType[index].isSelect::::: ${_chooseCategoryList[index].isSelect}');
        _chooseCategoryList[index].isSelect = true;
        _checkTreadType = true;
        _checkTreadTypeName = _chooseCategoryList[index].name;
      } else {
        _chooseCategoryList[i].isSelect = false;
      }
      notifyListeners();
    }
  }

  collectsTreadType(){
    _collectCategoryList= [];
    for(int i=0;i<_chooseCategoryList.length;i++){
      if (_chooseCategoryList[i].isSelect) {
        _collectCategoryList.add(_chooseCategoryList[i].name.toString());
      }
      notifyListeners();
    }
  }

  void initializeChooseCateoryList() {
    if (_chooseCategoryList.length == 0) {
      _chooseCategoryList.clear();
      _chooseCategoryList = ChooseCategoryRepo().getChooseCategoryList;
      notifyListeners();
    }
  }

}