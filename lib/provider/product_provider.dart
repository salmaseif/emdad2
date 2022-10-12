
import 'package:emdad/data/model/response/brand_model.dart';
import 'package:emdad/data/model/response/category.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/data/repository/product_repo.dart';
import 'package:emdad/helper/api_checker.dart';
import 'package:emdad/helper/product_type.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _latestProductList = [];
  List<Product> _lProductList = [];
  List<Product> get lProductList=> _lProductList;
  List<Product> _featuredProductList = [];

  bool _isLoadingProduct = false;
  bool get isLoadingProduct => _isLoadingProduct;

  ProductType _productType = ProductType.NEW_ARRIVAL;
  String _title = 'xyz';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstProductListByCategoryIdLoading = true;
  bool _firstProductListByBrandIdLoading = true;
  bool _firstLoading = true;
  int _latestPageSize;
  int _lOffset = 1;
  int _sellerOffset = 1;
  int _lPageSize;
  int get lPageSize=> _lPageSize;
  int _lPageSizeBrand;
  int get lPageSizeBrand=> _lPageSizeBrand;
  int _featuredPageSize;

  ProductType get productType => _productType;
  String get title => _title;
  int get lOffset => _lOffset;
  int get sellerOffset => _sellerOffset;

  List<int> _offsetList = [];
  List<String> _lOffsetList = [];
  List<String> get lOffsetList=>_lOffsetList;
  List<String> _featuredOffsetList = [];

  List<Product> get latestProductList => _latestProductList;
  List<Product> get featuredProductList => _featuredProductList;

  Product _recommendedProduct;
  Product get recommendedProduct=> _recommendedProduct;

  bool get filterIsLoading => _filterIsLoading;
  bool get filterFirstLoading => _filterFirstLoading;
  bool get isLoading => _isLoading;
  bool get firstFeaturedLoading => _firstFeaturedLoading;
  bool get firstProductListByCategoryIdLoading => _firstProductListByCategoryIdLoading;
  bool get firstProductListByBrandIdLoading => _firstProductListByBrandIdLoading;
  bool get firstLoading => _firstLoading;
  int get latestPageSize => _latestPageSize;
  int get featuredPageSize => _featuredPageSize;


  List<Product> _sellerProductListFilter = [];
  List<Product> get sellerProductListFilter => _sellerProductListFilter;


  List<ProductModel> _restaurant;
  List<ProductModel> get restaurant => _restaurant;
  int _totalQuantity =0;
  int get totalQuantity => _totalQuantity;

  int _discountTypeIndex = 0;
  List<Category> _categoryList;
  List<BrandModel> _brandList;
  List _subCategoryList;
  List<Category> _subCategoryListDropDown;
  List<SubSubCategory> _subSubCategoryList;
  int _categorySelectedIndex;
  int _subCategorySelectedIndex;
  int _subSubCategorySelectedIndex;
  int _categoryIndex = 0;
  int _subCategoryIndex = 0;
  int _subCategorySubIndex = 0;
  int _subSubCategoryIndex = 0;
  int _brandIndex = 0;
  int _unitIndex = 0;
  int get unitIndex => _unitIndex;
  bool _isLoadingCategory = false;
  bool get isLoadingCategory => _isLoadingCategory;
  int get categorySelectedIndex => _categorySelectedIndex;
  int get subCategorySelectedIndex => _subCategorySelectedIndex;
  int get subSubCategorySelectedIndex => _subSubCategorySelectedIndex;
  List<int> _selectedColor = [];
  List<int> get selectedColor =>_selectedColor;
  String _successAddProduct;
  int _successProductId;
  String get successAddProduct => _successAddProduct;
  int get successProductId => _successProductId;

  List<int> _categoryIds = [];
  List<int> _categoryListFilterIds;
  List<String> _categoryListFilterNames = [];
  List<String> _categoryNames = [];
  List<int> _subSubCategoryIds = [];
  List<int> _subSubCategoryParentIds = [];
  List<String> _subSubCategoryNames = [];

  List<String> get subSubCategoryNames => _subSubCategoryNames;
  List<int> get categoryIds => _categoryIds;
  List<int> get categoryListFilterIds => _categoryListFilterIds;
  List<String> get categoryNames => _categoryNames;
  List<String> get categoryListFilterNames => _categoryListFilterNames;
  List<int> get subSubCategoryIds => _subSubCategoryIds;
  List<int> get subSubCategoryParentIds => _subSubCategoryParentIds;

  List<String> _subcategoryNames = [];
  List<dynamic> _subcategoryMap = [];
  List<String> get subcategoryNames => _subcategoryNames;
  List<int> _subCategoryIds = [];
  List<int> get subCategoryIds => _subCategoryIds;
  List<int> _subCategoryParentIds = [];
  List<int> get subCategoryParentIds => _subCategoryParentIds;
  List<String> _subcategorySubNames = [];
  List<String> get subcategorySubNames => _subcategorySubNames;
  List<int> _subCategorySubIds = [];
  List<int> get subCategorySubIds => _subCategorySubIds;
  List<int> get subcategoryMap => _subcategoryMap;


  Product _editProductByBarcode;
  Product get editProductByBarcode => _editProductByBarcode;
  int get discountTypeIndex => _discountTypeIndex;
  List<Category> get categoryList => _categoryList;
  List<SubCategory> get subCategoryList => _subCategoryList;
  List<Category> get subCategoryListDropDown => _subCategoryListDropDown;
  List<SubSubCategory> get subSubCategoryList => _subSubCategoryList;
  List<BrandModel> get brandList => _brandList;
  XFile _pickedLogo;
  XFile _pickedCover;
  XFile _pickedMeta;
  List <XFile>_coveredImage = [];
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  XFile get pickedMeta => _pickedMeta;
  List<XFile> get coveredImage => _coveredImage;
  int get categoryIndex => _categoryIndex;
  int get subCategoryIndex => _subCategoryIndex;
  int get subCategorySubIndex => _subCategorySubIndex;
  int get subSubCategoryIndex => _subSubCategoryIndex;
  int get brandIndex => _brandIndex;
  final picker = ImagePicker();
  List<TextEditingController> _titleControllerList = [];
  List<TextEditingController> _descriptionControllerList = [];
  List<String> _colorCodeList =[];
  List<String> get colorCodeList => _colorCodeList;

  List<TextEditingController>  get titleControllerList=> _titleControllerList;
  List<TextEditingController> get descriptionControllerList=> _descriptionControllerList;

  List<FocusNode> _titleNode;
  List<FocusNode> _descriptionNode;
  List<FocusNode> get titleNode => _titleNode;
  List<FocusNode> get descriptionNode => _descriptionNode;


  ////////////////////////////////////
  List<String> _subFilterCategoryNames = [];
  List<String> get subFilterCategoryNames => _subFilterCategoryNames;
  List<String> _subFilterCategoryIds = [];
  List<String> get subFilterCategoryIds => _subFilterCategoryIds;
  List<String> _subFilterCategoryParentIds = [];
  List<String> get subFilterCategoryParentIds => _subFilterCategoryParentIds;


  List<String> _subSubFilterCategoryNames = [];
  List<String> get subSubFilterCategoryNames => _subSubFilterCategoryNames;
  List<int> _subSubFilterCategoryIds = [];
  List<int> get subSubFilterCategoryIds => _subSubFilterCategoryIds;
  List<int> _subSubFilterCategoryParentIds = [];
  List<int> get subSubFilterCategoryParentIds => _subSubFilterCategoryParentIds;
  /////////////////////////////////////////////////////////

  //latest product
  Future<void> getLatestProductList(int offset, BuildContext context, {bool reload = false}) async {
    if(reload) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if(!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLatestProductList(context,offset.toString(), productType, title);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _latestProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _latestPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _filterFirstLoading = false;
        _filterIsLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }else {
      if(_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }
  }
  //latest product
  Future<void> getLProductList(String offset, BuildContext context, {bool reload = false}) async {
    if(reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if(!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLProductList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _lProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _lPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }else {
      if(_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }

  }

  Future<int> getLatestOffset(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getLatestProductList(context,'1', productType, title);
    return ProductModel.fromJson(apiResponse.response.data).totalSize;
  }

  void changeTypeOfProduct(ProductType type, String title){
      _productType = type;
      _title = title;
      _latestProductList = null;
      _latestPageSize = 0;
      _filterFirstLoading = true;
      _filterIsLoading = true;
      notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  // Seller products
  List<Product> _sellerAllProductList = [];
  List<Product> _sellerProductList = [];
  int _sellerPageSize;
  List<Product> get sellerProductList => _sellerProductList;
  int get sellerPageSize => _sellerPageSize;
  double _maxPrice = 0.0;
  double _minPrice = 0.0;
  double get maxPrice => _maxPrice;
  double get minPrice => _minPrice;


  /////////// filter
  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  List<Product> _sortProductListItem;
  List<Product> get sortProductListItem => _sortProductListItem;
  List<Product> _filterProductList;
  List<Product> get filterProductList => _filterProductList;

  // المنتجات بحسب القسم
  List<Product> _filterProductListByCategoryId;
  List<Product> get filterProductListByCategoryId => _filterProductListByCategoryId;
    // المنتجات بحسب الماركة
  List<Product> _filterProductListByBrandId;
  List<Product> get filterProductListByBrandId => _filterProductListByBrandId;


  bool _isClear = true;
  String _searchText = '';

  void initSellerProductList(String sellerId, int offset, BuildContext context, {bool reload = false}) async {
    _isLoadingProduct = true;
    _sellerProductList= [];
    _firstLoading = true;
    if(reload) {
      _offsetList = [];
      _sellerProductList = [];
    }
    _sellerOffset = offset;
    filterProducts(0);

    ApiResponse apiResponse = await productRepo.getLProductList(sellerId);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _sellerProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerAllProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
      _firstLoading = false;
      _filterIsLoading = false;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoadingProduct = false;
    notifyListeners();
  }

  Future<void> filterProducts(int catId) {
    _isLoadingProduct = true;
    print('catId::::::::::::::$catId');
    if(catId > 0) {
      _sellerProductListFilter =[];
      _sellerProductList.forEach((product) {
        if (product.categoryIds.toString()  == catId.toString()) {
          _sellerProductListFilter.add(product);
          notifyListeners();
        }
      });
      _isLoadingProduct = false;
    } else {
      _sellerProductListFilter =[];
      _sellerProductListFilter.addAll(_sellerProductList);
      notifyListeners();
    }
    _isLoadingProduct = false;
    notifyListeners();
    return null;
  }

  void filterData(String newText) {
    _sellerProductList= [];
    if(newText.isNotEmpty) {
      _sellerAllProductList.forEach((product) {
        if (product.name.toLowerCase().contains(newText.toLowerCase())) {
          _sellerProductList.add(product);
        }
      });
    }else {
      _sellerProductList= [];
      _sellerProductList.addAll(_sellerAllProductList);
    }
    notifyListeners();
  }

  void clearSellerData() {
    _sellerProductList = [];
    //notifyListeners();
  }

  // Brand and category products
  List<Product> _brandOrCategoryProductList = [];
  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;

  // get products by categoryId
  List<Product> _productListByCategoryIds = [];
  List<Product> get productListByCategoryIds => _productListByCategoryIds;

  // get products by brandId
  List<Product> _productListByBrandIds = [];
  List<Product> get productListByBrandIds => _productListByBrandIds;

  bool _hasData;
  bool get hasData => _hasData;

  void initBrandOrCategoryProductList(bool isBrand, String id, BuildContext context) async {
    _isLoadingProduct = true;
    _hasData = true;
    _brandOrCategoryProductList= [];
    List<Product> _products = [];
    _sortProductListItem = [];
    _filterProductList = [];
    print('_brandOrCategoryProductList: 999999999999999');
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach((product) => _brandOrCategoryProductList.add(Product.fromJson(product)));
      _hasData = false;
      _products.addAll(_brandOrCategoryProductList);
      //_brandOrCategoryProductList= [];
     // _brandOrCategoryProductList.addAll(_products.reversed);
      _sortProductListItem.addAll(_products.reversed);
      _filterProductList.addAll(_products.reversed);
      getMinMaxPrice();
      sortProductList();
      notifyListeners();
      _isLoadingProduct = false;
      _firstFeaturedLoading = false;
      notifyListeners();
    } else {
      _hasData = true;
      ApiChecker.checkApi(context, apiResponse);
      _isLoadingProduct = false;
      _firstFeaturedLoading = false;
      notifyListeners();
    }
    _isLoadingProduct = false;
    _firstFeaturedLoading = false;
    notifyListeners();
  }

  void getProductListByCategoryId(bool isBrand, String id, BuildContext context) async {
    _firstProductListByCategoryIdLoading = true;
    _productListByCategoryIds= [];
    notifyListeners();
    List<Product> _productsByCat = [];
    print('_productListByCategoryIds: 999999999999999');
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach((product) => _productListByCategoryIds.add(Product.fromJson(product)));
      _hasData = false;
      _productsByCat.addAll(_productListByCategoryIds);
      _filterProductListByCategoryId.addAll(_productsByCat.reversed);
      notifyListeners();
    } else {
      _firstProductListByCategoryIdLoading = false;
      ApiChecker.checkApi(context, apiResponse);
      notifyListeners();
    }
    _firstProductListByCategoryIdLoading = false;
    notifyListeners();
  }


  void getProductListByBrandId(bool isBrand, String id, BuildContext context) async {
    _firstProductListByBrandIdLoading = true;
    _productListByBrandIds= [];
    _filterProductListByBrandId= [];
    notifyListeners();
    List<Product> _productsByBra = [];
    print('_productListByCategoryIds: 999999999999999');
    ApiResponse apiResponse = await productRepo.getBrandProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach((product) => _productListByBrandIds.add(Product.fromJson(product)));
      print('_productListByBrandIds: $_productListByBrandIds');
      _lPageSizeBrand = ProductModel.fromJson(apiResponse.response.data).totalSize;
      _hasData = false;
      _productsByBra.addAll(_productListByBrandIds);
      _filterProductListByBrandId.addAll(_productsByBra.reversed);
      _firstLoading = false;
      notifyListeners();
    } else {
      _firstLoading = false;
      _firstProductListByBrandIdLoading = false;
      ApiChecker.checkApi(context, apiResponse);
      notifyListeners();
    }
    _firstProductListByBrandIdLoading = false;
    notifyListeners();
  }

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void getMinMaxPrice() {
    if(_sortProductListItem != null){
      _sortProductListItem.forEach((products) {
        if(_maxPrice > products.unitPrice) {
          _maxPrice =  products.unitPrice;
          print('_maxPrice::::::::$_maxPrice');
        }
        if(_minPrice < products.unitPrice) {
          _minPrice =  products.unitPrice;
          print('_minPrice::::::::$_minPrice');
        }
      });
    } else {
      _maxPrice = 100000;
      _minPrice = 0;
    }

    notifyListeners();
  }

  /*
  void sortProductList() {
    _isLoadingProduct = true;
    if (_filterIndex == 0) {
      _sortProductListItem.clear();
      _sortProductListItem.addAll(_filterProductList);
    } else if (_filterIndex == 1) {
      _sortProductListItem.clear();
      if(_minPrice >= 0 && _maxPrice >= _minPrice) {
        _sortProductListItem.addAll(_filterProductList.where((product) => (product.unitPrice) > _minPrice && (product.unitPrice) < _minPrice).toList());
      }else {
        _sortProductListItem.addAll(_filterProductList);
      }
      _sortProductListItem.sort((a, b) => a.name.compareTo(b.name));
    } else if (_filterIndex == 2) {
      _sortProductListItem.clear();
      _sortProductListItem.addAll(_filterProductList.where((product) => product.unitPrice > _minPrice && product.unitPrice < _maxPrice).toList());
      _sortProductListItem.sort((a, b) => a.name.compareTo(b.name));
      Iterable iterable = _sortProductListItem.reversed;
      _sortProductListItem = iterable.toList();
    } else if (_filterIndex == 3) {
      _sortProductListItem.clear();
      _sortProductListItem.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } else if (_filterIndex == 4) {
      _sortProductListItem.clear();
      _sortProductListItem.addAll(_filterProductList);
      _sortProductListItem.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
      Iterable iterable = _sortProductListItem.reversed;
      _sortProductListItem = iterable.toList();
    }
    _isLoadingProduct = false;
    notifyListeners();
  }
 */

  void sortProductList() {
    _isLoadingProduct = true;
    if (_filterIndex == 1) {
    _sortProductListItem.sort((a, b) => a.name.compareTo(b.name));
    } else if (_filterIndex == 2) {
      _sortProductListItem.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } else if (_filterIndex == 3) {
      _sortProductListItem.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
    }
    _isLoadingProduct = false;
    notifyListeners();
  }

  // Related products
  List<Product> _relatedProductList;
  List<Product> get relatedProductList => _relatedProductList;
  void initRelatedProductList(String id, BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response.data.forEach((product) => _relatedProductList.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
  }
  //featured product
  Future<void> getFeaturedProductList(String offset, BuildContext context, {bool reload = false}) async {
    if(reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if(!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getFeaturedProductList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _featuredProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _featuredPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }else {
      if(_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }

  }

  Future<void> getRecommendedProduct( BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRecommendedProduct();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _recommendedProduct = Product.fromJson(apiResponse.response.data);
        print('=rex===>${_recommendedProduct.toJson()}');
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
  }

  Future<void> getRestaurant(BuildContext context) async {
    if(_restaurant == null ){
      ApiResponse apiResponse = await ProductRepo(dioClient: null).getLProductList('1');
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _restaurant = [];
        apiResponse.response.data.forEach((restaurant) => _restaurant.add(restaurant));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void addColorCode(String colorCode){
    _colorCodeList.add(colorCode);
    notifyListeners();

  }

  void removeColorCode(int index){
    _colorCodeList.removeAt(index);
    notifyListeners();
  }

  Future<void> getBrandList(BuildContext context, String language) async {
    ApiResponse response = await productRepo.getBrandList(language);
    if (response.response.statusCode == 200) {
      _brandList = [];
      response.response.data['data'].forEach((brand) => _brandList.add(BrandModel.fromJson(brand)));
    } else {
      ApiChecker.checkApi(context,response);
    }
    _brandIndex = _brandList.first.id;
    print('_brandIndex------$_brandIndex');
    notifyListeners();
  }

  Future<void>  getCategoryListForMe(BuildContext context) async {
    print('===getCategoryListForMe====>getCategoryListForMe');

    _isLoading = true;
    _categoryIds =[];
    _subCategoryIds =[];
    _subCategoryParentIds =[];
    _subSubCategoryIds =[];
    _subSubCategoryParentIds =[];
    _categoryNames =[];
    _subcategoryNames =[];
    _subSubCategoryNames =[];
    _colorCodeList =[];
    _categoryListFilterIds =[];
    _categoryListFilterNames =[];

    _categoryIds.add(0);
    _subCategoryIds.add(0);
    _subCategoryParentIds.add(0);
    _subSubCategoryIds.add(0);
    _subSubCategoryParentIds.add(0);
    _categoryNames.add('الكل');
    _subcategoryNames.add('الكل');
    _subSubCategoryNames.add('الكل');
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _subSubCategoryIndex = 0;
    _categoryListFilterIds.add(0);
    _categoryListFilterNames.add('الكل');

    ApiResponse response = await productRepo.getCategoryList('ar');

    if (response.response != null && response.response.statusCode == 200) {
      _categoryList = [];
      response.response.data.forEach((category) => _categoryList.add(Category.fromJson(category)));
        notifyListeners();
      _categoryIndex = 0;
      for(int index = 0; index < _categoryList.length; index++) {
        _categoryIds.add(_categoryList[index].id);
        _categoryNames.add(_categoryList[index].name);
        _categoryListFilterNames.add(_categoryList[index].name);
        _categoryListFilterIds.add(_categoryList[index].id);
        notifyListeners();
      }
      print('===_categoryList====>$_categoryList');
      /////////////////////////////////////sub
      if(_categoryList != null){
        _categoryIndex = _categoryList.first.id;
        _categoryList.forEach((v) {
          v.subCategories.forEach((sub) {
            print('===subsubsub====>$sub');
            _subcategoryMap.add({sub.name , sub.parentId , sub.id});
            _subcategoryNames.add(sub.name);
            _subCategoryIds.add( sub.id );
            _subCategoryParentIds.add( sub.parentId );
          });
          notifyListeners();
        });
      }
      print('===_subcategoryNames====>$_subcategoryNames');
      /////////////////////////////////////subSub
      if (_categoryList != null) {
        _categoryList.forEach((vv) {
          vv.subCategories.forEach((subSub) {
            subSub.subSubCategories.forEach((subSubSub) {
              _subSubCategoryNames.add(subSubSub.name);
              _subSubCategoryIds.add(subSubSub.id);
              _subSubCategoryParentIds.add(subSubSub.parentId);
          });
          });
          notifyListeners();
        });
      }
      print('===_subSubCategoryNames====>$_subSubCategoryNames');
      //////////////////////////// end
    } else {
      ApiChecker.checkApi(context,response);
    }
    notifyListeners();
  }

  Future<void> getSubCategoryList(BuildContext context, int selectedIndex) async {
    _isLoadingProduct = true;
    print('===selectedIndex====>$selectedIndex');
    _subSubFilterCategoryNames =[];
    _subSubFilterCategoryIds =[];
    _subSubFilterCategoryParentIds =[];
    _subSubFilterCategoryNames.add('الكل');
    _subSubFilterCategoryIds.add(0);
    _subSubFilterCategoryParentIds.add(0);

    for(int index = 0; index < _subSubCategoryParentIds.length; index++) {
        if (_subSubCategoryParentIds[index].toString( ) == selectedIndex.toString( )) {
          _subSubFilterCategoryIds.add(_subSubCategoryIds[index]);
          _subSubFilterCategoryNames.add(_subSubCategoryNames[index]);
          _subSubFilterCategoryParentIds.add(_subSubCategoryParentIds[index]);
        }
    }
    print('===_subSubFilterCategoryIds====>$_subSubFilterCategoryIds');

    print('===_subSubFilterCategoryIds====>$_subSubFilterCategoryIds');
    print('===_subSubFilterCategoryNames====>$_subSubFilterCategoryNames');
    print('===_subSubFilterCategoryParentIds====>$_subSubFilterCategoryParentIds');
    _isLoadingProduct = false;
    notifyListeners( );
  }

  Future<void> getSubSubCategoryList(BuildContext context, int selectedIndex) async {
    print('===selectedIndex77====>$selectedIndex');

    /*
    _subSubCategoryNames = [];
    _subSubCategoryNames.add('الكل');
    _subSubCategoryIndex = 0;
    _subSubCategoryIds = [];
    _subSubCategoryIds.add(0);
    if (_subSubCategoryList != null){
      for(int index = 0; index < _subSubCategoryList.length; index++) {
        if(_subSubCategoryList[index].id.toString() == selectedIndex.toString()){
          _subSubCategoryNames.add(_subSubCategoryList[index].name);
          _subSubCategoryIds.add(_subSubCategoryList[index].id);
          notifyListeners( );
        }
      }
    }
    print('===_subSubCategoryNames====>$_subSubCategoryNames');

     */
    notifyListeners( );
  }

  void pickImage(bool isLogo,bool isMeta, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
      _pickedMeta = null;
      _coveredImage = [];
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if(isMeta){
        _pickedMeta = await ImagePicker().pickImage(source: ImageSource.gallery);
      }else {
        if(_coveredImage!=null){
          _coveredImage = await ImagePicker().pickMultiImage();
        }
      }
      notifyListeners();
    }
  }

  void setSelectedColorIndex(int index, bool notify) {
    if(!_selectedColor.contains(index)) {
      _selectedColor.add(index);
      if(notify) {
        notifyListeners();
      }
    }notifyListeners();
  }

  void setBrandIndex(int index, bool notify) {
    _brandIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    _subCategoryListDropDown = [];
    _categoryList.forEach((category) {
      if (category.id.toString()  == index.toString()) {
        _subCategoryListDropDown.add(category);
        notifyListeners();
      }
    });
    if(_subCategoryListDropDown != null){
      _subCategorySelectedIndex = _subCategoryListDropDown.first.id;
      _categorySelectedIndex = _subCategoryListDropDown.first.id;
      notifyListeners();
    }
    else {
      _subCategorySelectedIndex = 1;
      _categorySelectedIndex = 1;
    }
    if(notify) {
      notifyListeners();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    _subCategorySelectedIndex = index;
    _categorySelectedIndex = index;
    for(int index = 0; index < _categoryList.length; index++) {
      _categoryIds.add(_categoryList[index].id);
      _categoryNames.add(_categoryList[index].name);
      _categoryListFilterNames.add(_categoryList[index].name);
      _categoryListFilterIds.add(_categoryList[index].id);
      notifyListeners();
    }
    notifyListeners();
    if(notify) {
      notifyListeners();
    }
  }

  void setSubSubCategoryIndex(int index, bool notify) {
    _subSubCategoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
}
