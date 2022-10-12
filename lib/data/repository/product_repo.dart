import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/datasource/remote/dio/dio_client.dart';
import 'package:emdad/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/helper/product_type.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/utility/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;
  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getLatestProductList(BuildContext context, String offset, ProductType productType, String title) async {
    String endUrl;

     if(productType == ProductType.BEST_SELLING){
      endUrl = AppConstants.BEST_SELLING_PRODUCTS_URI;
      title = getTranslated('best_selling', context);
    }
    else if(productType == ProductType.NEW_ARRIVAL){
      endUrl = AppConstants.NEW_ARRIVAL_PRODUCTS_URI;
      title = getTranslated('new_arrival',context);
    }
    else if(productType == ProductType.TOP_PRODUCT){
      endUrl = AppConstants.TOP_PRODUCTS_URI;
      title = getTranslated('top_product', context);
    }else if(productType == ProductType.DISCOUNTED_PRODUCT){
       endUrl = AppConstants.DISCOUNTED_PRODUCTS_URI;
       title = getTranslated('discounted_product', context);
     }

    try {
      final response = await dioClient.get(
        endUrl+offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //Seller Products
  Future<ApiResponse> getSellerProductList(String sellerId, String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.SELLER_PRODUCT_URI+sellerId+'/products?limit=10&&offset='+offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // مهم لجلب المنتجات بحسب القسم
  Future<ApiResponse> getBrandOrCategoryProductList(bool isBrand, String id) async {
    try {
      String uri;
      if(isBrand){
        uri = '${AppConstants.BRAND_PRODUCT_URI}$id';
      }else {
        uri = '${AppConstants.CATEGORY_PRODUCT_URI}$id';
      }
      final response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // مهم لجلب المنتجات بحسب القسم
  Future<ApiResponse> getBrandProductList(bool isBrand, String id) async {
    try {
      String uri;
      uri = '${AppConstants.BRAND_PRODUCT_URI}$id';
      final response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getRelatedProductList(String id) async {
    try {
      final response = await dioClient.get(
        AppConstants.RELATED_PRODUCT_URI+id);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getFeaturedProductList(String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.FEATURED_PRODUCTS_URI+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getLProductList(String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.LATEST_PRODUCTS_URI+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedProduct() async {
    try {
      final response = await dioClient.get(AppConstants.DEAL_OF_THE_DAY_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.BRANDS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.CATEGORIES_URI,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      print('getCategoryList:::::$response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList() async {
    try {
      final response = await dioClient.get('${AppConstants.CATEGORIES_SUB_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubSubCategoryList() async {
    try {
      final response = await dioClient.get('${AppConstants.CATEGORIES_SUB_SUB_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }
}