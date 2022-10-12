import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/featured_deal_model.dart';
import 'package:emdad/data/repository/featured_deal_repo.dart';
import 'package:emdad/data/model/response/product_model.dart';

class FeaturedDealProvider extends ChangeNotifier {
  final FeaturedDealRepo featuredDealRepo;

  FeaturedDealProvider({@required this.featuredDealRepo});

  List<FeaturedDealModel> _featuredDealList = [];
  int _featuredDealSelectedIndex;
  List<Product> _featuredDealProductList =[];
  List<Product> get featuredDealProductList =>_featuredDealProductList;

  List<FeaturedDealModel> get featuredDealList => _featuredDealList;
  int get featuredDealSelectedIndex => _featuredDealSelectedIndex;

  Future<void> getFeaturedDealList(bool reload, BuildContext context) async {
    if (_featuredDealList.length == 0 || reload) {
      ApiResponse apiResponse = await featuredDealRepo.getFeaturedDeal();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200 && apiResponse.response.data.toString() != '{}') {
        _featuredDealList = [];
        _featuredDealList.clear();
        _featuredDealProductList =[];
        apiResponse.response.data.forEach((fDeal) => _featuredDealList.add(FeaturedDealModel.fromJson(fDeal)));
        print('===_featuredDealList====>$_featuredDealList');
        _featuredDealList.forEach((product) {
          _featuredDealProductList.add(product.product);
        });
        print('===_featuredDealProductList====>$_featuredDealProductList');

        _featuredDealSelectedIndex = 0;
      } else {
        //ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}
