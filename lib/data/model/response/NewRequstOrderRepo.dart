import 'dart:io';

import 'package:dio/dio.dart';
import 'package:emdad/data/model/body/new_order_body.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/datasource/remote/dio/dio_client.dart';
import 'package:emdad/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/utility/app_constants.dart';
import 'package:http/http.dart' as http;

class NewRequstOrderRepo {
  final DioClient dioClient;
  NewRequstOrderRepo({@required this.dioClient});

  Future<ApiResponse> sendNewRequstOrder(NewOrderBody newRequstOrderModel) async {
    try {
      print('sendNewRequstOrder $newRequstOrderModel');
      Response response = await dioClient.post(AppConstants.NEW_REQUST_ORDER_URI, data: newRequstOrderModel.toJson());
      print('sendNewRequstOrder $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendNewRequstDocInfo(NewOrderBody newRequstOrderModel, File fileReq, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.NEW_REQUST_ORDER_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    Map<String, String> _fields = Map();
    if(fileReq != null){
      request.files.add(http.MultipartFile('image', fileReq.readAsBytes().asStream(), fileReq.lengthSync(), filename: fileReq.path.split('/').last));
    }
    _fields.addAll(<String, String>{
      '_method': 'put', 'subject': newRequstOrderModel.subject, 'quantity': newRequstOrderModel.quantity, 'price': newRequstOrderModel.price, 'description': newRequstOrderModel.description, 'userId': newRequstOrderModel.userId.toString()
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    print('response77========>$response');
    return response;
  }

  Future<ApiResponse> getNewRequstOrderList() async {
    try {
      final response = await dioClient.get(AppConstants.new_req_order_GET_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getNewRequstOrderReplyList(String ticketID) async {
    try {
      final response = await dioClient.get('${AppConstants.new_req_order_CONV_URI}$ticketID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendReply(String ticketID, String message) async {
    try {
      final response = await dioClient.post('${AppConstants.new_req_order_REPLY_URI}$ticketID', data: {'message': message});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}