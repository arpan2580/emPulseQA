import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/authorization_interceptor.dart';
import '../views/dialogs/dialog_helper.dart';

class BaseClient {
  final isLoggedIn = GetStorage();

  final Dio _dio;
  BaseClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: BaseController.baseUrl,
            connectTimeout: 70000,
            receiveTimeout: 70000, // 70s
            responseType: ResponseType.json,
            contentType: 'application/json',
          ),
        )..interceptors.add(AuthorizationInterceptor());

  //GET
  // Future<dynamic> get(String api) async {
  //   try {
  //     final response = await _dio.get(api);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       var responseJson = json.decode(response.data);
  //       return responseJson;
  //     }
  //   } on DioError catch (err) {
  //     final errorMessage = DioException.fromDioError(err).toString();
  //     throw errorMessage;
  //   } catch (e) {
  //     print(e);
  //     throw e.toString();
  //   }
  // }

  //POST
  Future<dynamic> dioPost(String api, dynamic payload,
      [bool isRefresh = false]) async {
    final dynamic response, responseJson;
    try {
      if (isRefresh) {
        response = await _dio.post(api,
            data: payload,
            options: Options(
                headers: {'refreshToken': true, 'Accept': 'application/json'}));
      } else {
        response = await _dio.post(api,
            data: payload,
            options: Options(headers: {'Accept': 'application/json'}));
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseJson = json.decode(response.toString());
        return responseJson;
      }
    } on DioError catch (err) {
      DialogHelper.showErrorToast(description: err.toString());
    } catch (e) {
      DialogHelper.showErrorToast(description: e.toString());
    }
  }
}
