import 'package:dio/dio.dart';
import 'package:emdad/data/model/response/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "تم الغاء طلب البيانات من السيرفر";
              break;
            case DioErrorType.connectTimeout:
              errorDescription = "فشل الاتصال بالسيرفر تاكد من الاتصال بالانترنت";
              break;
            case DioErrorType.other:
              errorDescription =
              "فشل الإتصال بالسيرفر وذالك لعدم توفر الإتصال بالانترنت";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioErrorType.response:
              switch (error.response.statusCode) {
                case 404:
                case 500:
                case 503:
                  errorDescription = error.response.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse =
                  ErrorResponse.fromJson(error.response.data);
                  if (errorResponse.errors != null &&
                      errorResponse.errors.length > 0)
                    errorDescription = errorResponse;
                  else
                    errorDescription =
                    "Failed to load data - status code: ${error.response.statusCode}";
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "مهلة الارسال الى السيرفر إنتهت ولم يكتمل تاكد من إتصال الأنترنت";
              break;
          }
        } else {
          errorDescription = "حاول مرة أخرى";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
