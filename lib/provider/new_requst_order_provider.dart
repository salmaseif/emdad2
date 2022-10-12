import 'dart:io';

import 'package:emdad/data/model/body/new_order_body.dart';
import 'package:emdad/data/model/response/NewReqestOrderModel.dart';
import 'package:emdad/data/model/response/NewRequstOrderRepo.dart';
import 'package:emdad/data/model/response/new_rer_order_model.dart';
import 'package:emdad/helper/api_checker.dart';
import 'package:emdad/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/base/api_response.dart';
import 'package:emdad/data/model/response/base/error_response.dart';
import 'package:http/http.dart' as http;

class NewRequstOrderProvider extends ChangeNotifier {
  final NewRequstOrderRepo newRequstOrderRepo;
  NewRequstOrderProvider({@required this.newRequstOrderRepo});

  List<NewReqOrderModel> _newRequstOrderList;
  List<NewReqOrderReplyModel> _supportReplyList;
  bool _isLoading = false;

  List<NewReqOrderModel> get newRequstOrderList => _newRequstOrderList;
  List<NewReqOrderReplyModel> get supportReplyList => _supportReplyList != null ? _supportReplyList.reversed.toList() : _supportReplyList;
  bool get isLoading => _isLoading;

  void sendNewRequstOrder(NewOrderBody newRequstOrderBody, Function(bool isSuccess, String message) callback, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await newRequstOrderRepo.sendNewRequstOrder(newRequstOrderBody);
    //http.StreamedResponse apiResponse = await newRequstOrderRepo.sendNewRequstDoc(newRequstOrderBody);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data["message"];
      callback(true, message);
      _isLoading = false;
      _newRequstOrderList.add(NewReqOrderModel(description: newRequstOrderBody.description, type: newRequstOrderBody.type,
          subject: newRequstOrderBody.subject, createdAt: DateConverter.formatDate(DateTime.now()), status: 'pending'));
      getNewRequstOrderList(context);
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendNewRequstOrderDoc(NewOrderBody newRequstOrderBody, Function(bool isSuccess, String message) callback, BuildContext context , File file, String token) async {
    _isLoading = true;
    notifyListeners();
    //ApiResponse apiResponse = await newRequstOrderRepo.sendNewRequstOrder(newRequstOrderBody);
    http.StreamedResponse apiResponse = await newRequstOrderRepo.sendNewRequstDocInfo(newRequstOrderBody, file, token);
    if (apiResponse.statusCode != null) {
      print('response88========>$apiResponse');
      String message = "تمام";
      callback(true, message);
      _isLoading = false;
     // _newRequstOrderList.add(NewReqOrderModel(description: newRequstOrderBody.description, type: newRequstOrderBody.type,
       //   subject: newRequstOrderBody.subject, createdAt: DateConverter.formatDate(DateTime.now()), status: 'pending'));
    //  getNewRequstOrderList(context);
      notifyListeners();
    } else {
      String errorMessage;
      callback(false, errorMessage);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNewRequstOrderList(BuildContext context) async {
    ApiResponse apiResponse = await newRequstOrderRepo.getNewRequstOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _newRequstOrderList = [];
      apiResponse.response.data.forEach((newRequstOrder) => _newRequstOrderList.add(NewReqOrderModel.fromJson(newRequstOrder)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getNewRequstOrderReplyList(BuildContext context, int ticketID) async {
    _supportReplyList = null;
    ApiResponse apiResponse = await newRequstOrderRepo.getNewRequstOrderReplyList(ticketID.toString());
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _supportReplyList = [];
      apiResponse.response.data.forEach((supportReply) => _supportReplyList.add(NewReqOrderReplyModel.fromJson(supportReply)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> sendReply(BuildContext context, int ticketID, String message) async {
    ApiResponse apiResponse = await newRequstOrderRepo.sendReply(ticketID.toString(), message);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _supportReplyList.add(NewReqOrderReplyModel(customerMessage: message, createdAt: DateConverter.localDateToIsoString(DateTime.now())
      ));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}
