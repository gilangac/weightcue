import 'package:dio/dio.dart';
import 'package:weightcue_mobile/services/service_handler.dart';
import 'package:weightcue_mobile/services/service_init.dart';

class ServiceProvider {
  static Future<dynamic> getData(String path, {String? token}) async {
    try {
      Response response = await apiCall(token).get(path);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> postData(String path,
      {Map? data, String? token}) async {
    try {
      Response response = await apiCall(token).post(path, data: data);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> postDataFile(String path,
      {FormData? data,
      String? token,
      void Function(int, int)? onSendProgress}) async {
    try {
      Response response = await apiCall(token)
          .post(path, data: data, onSendProgress: onSendProgress);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> putData(String path,
      {Map? data, String? token}) async {
    try {
      Response response = await apiCall(token).put(path, data: data);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> putDataFile(String path,
      {FormData? data, String? token}) async {
    try {
      Response response = await apiCall(token).put(path, data: data);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> deleteData(String path,
      {Map? data, String? token}) async {
    try {
      Response response = await apiCall(token).delete(path);
      return handleResponse(response);
    } on DioError catch (e) {
      throw handleError(e);
    }
  }
}
