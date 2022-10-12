import 'package:flutter/material.dart';
import 'package:emdad/data/datasource/remote/dio/dio_client.dart';
import 'package:emdad/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/utility/app_constants.dart';

class TopSellerRepo {
  final DioClient dioClient;
  TopSellerRepo({@required this.dioClient});

  Future<ApiResponse> getTopSeller() async {
    try {
      final response = await dioClient.get(AppConstants.TOP_SELLER);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}