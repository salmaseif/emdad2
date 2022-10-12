import 'package:flutter/material.dart';
import 'package:emdad/data/datasource/remote/dio/dio_client.dart';
import 'package:emdad/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emdad/data/model/body/MessageBody.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/utility/app_constants.dart';

class ChatRepo {
  final DioClient dioClient;
  ChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList(String sellerID) async {
    try {
      final response = await dioClient.get('${AppConstants.MESSAGES_URI}$sellerID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getChatInfo() async {
    try {
      final response = await dioClient.get(AppConstants.CHAT_INFO_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendMessage(MessageBody messageBody) async {
    print('======>Message body===>${messageBody.sellerId} and shop id = ${messageBody.sellerId}');
    try {
      final response = await dioClient.post(AppConstants.SEND_MESSAGE_URI, data: messageBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}