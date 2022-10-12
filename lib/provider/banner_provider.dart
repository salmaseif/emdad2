import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/banner_model.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/product_model.dart';
import 'package:emdad/data/repository/banner_repo.dart';
import 'package:emdad/helper/api_checker.dart';
import 'package:emdad/view/basewidget/show_custom_snakbar.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _mainBannerList;
  List<BannerModel> _footerBannerList;
  List<BannerModel> _mainSectionBannerList;
  Product _product;
  int _currentIndex;

  List<BannerModel> get mainBannerList => _mainBannerList;
  List<BannerModel> get footerBannerList => _footerBannerList;
  List<BannerModel> get mainSectionBannerList => _mainSectionBannerList;
  Product get product => _product;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload, BuildContext context) async {
    if (_mainBannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _mainBannerList = [];
        apiResponse.response.data.forEach((bannerModel) => _mainBannerList.add(BannerModel.fromJson(bannerModel)));
        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }



  Future<void> getFooterBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getFooterBannerList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _footerBannerList = [];
      apiResponse.response.data.forEach((bannerModel) => _footerBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> getMainSectionBanner(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getMainSectionBannerList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _mainSectionBannerList = [];
      apiResponse.response.data.forEach((bannerModel) => _mainSectionBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void getProductDetails(BuildContext context, String productId) async {
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productId);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _product = (Product.fromJson(apiResponse.response.data));
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }

}
