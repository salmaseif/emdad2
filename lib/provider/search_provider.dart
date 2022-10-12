import 'package:emdad/data/model/response/category.dart';
import 'package:emdad/data/repository/category_repo.dart';
import 'package:emdad/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/data/repository/search_repo.dart';
import 'package:emdad/helper/api_checker.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo searchRepo;
  final CategoryRepo categoryRepo;
  SearchProvider({@required this.categoryRepo, @required this.searchRepo});

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  String _dropdownInitializeValueValue = '';

  String get dropdownInitializeValue => _dropdownInitializeValueValue;

  updateDropDownValue(String value) {
    _dropdownInitializeValueValue = value;
    notifyListeners();
  }

  List<String> _getAllSearchCategory = [];

  List<String> get getAllSearchCategory => _getAllSearchCategory;

  List<Category> _categoryList = [];
  int _categorySelectedIndex;

  List<Category> get categoryList => _categoryList;
  int get categorySelectedIndex => _categorySelectedIndex;

  void sortSearchList(double startingPrice, double endingPrice) {
    _searchProductList = [];
    if(startingPrice > 0 && endingPrice > startingPrice) {
      _searchProductList.addAll(_filterProductList.where((product) =>
      (product.unitPrice) > startingPrice && (product.unitPrice) < endingPrice).toList());
    }else {
      _searchProductList.addAll(_filterProductList);
    }

    if (_filterIndex == 0) {

    } else if (_filterIndex == 1) {
      _searchProductList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_filterIndex == 2) {
      _searchProductList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    } else if (_filterIndex == 3) {
      _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } else if (_filterIndex == 4) {
      _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    }

    notifyListeners();
  }

  List<Product> _searchProductList;
  List<Product> _filterProductList;
  bool _isClear = true;
  String _searchText = '';

  List<Product> get searchProductList => _searchProductList;
  List<Product> get filterProductList => _filterProductList;
  bool get isClear => _isClear;
  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, BuildContext context) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    notifyListeners();

    ApiResponse apiResponse = await searchRepo.getSearchProductList(query);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _filterProductList = [];
        _filterProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo.saveSearchAddress(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }

  searchProductLocal( String query) async {
    if (query.isEmpty) {
      _searchProductList.clear();
      ApiResponse apiResponse = await ProductRepo(dioClient: null).getLProductList('1');
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _searchProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      }
      notifyListeners();
    } else {
      _filterProductList = [];
      _searchProductList.forEach((product) async {
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          _filterProductList.add(product);
        }
      });
      notifyListeners();
    }
  }


  initializeProducts(BuildContext context) async {
    if (_searchProductList.length == 0) {
      _searchProductList.clear();
      ApiResponse apiResponse = await ProductRepo(dioClient: null).getLProductList('1');
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _searchProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  initalizeAllSearchCategory() async {
    if (_getAllSearchCategory.length == 0) {
      _getAllSearchCategory.clear();
      _getAllSearchCategory = searchRepo.getAllSearchCategory;
      _dropdownInitializeValueValue = searchRepo.getAllSearchCategory[0];
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        apiResponse.response.data.forEach((category) => _categoryList.add(Category.fromJson(category)));
      }
      notifyListeners();
    }
  }
}
