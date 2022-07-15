import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/base_controller.dart';
import '../services/dio_exceptions.dart';
import '../views/dialogs/dialog_helper.dart';

class AuthorizationInterceptor extends Interceptor {
  final isLoggedIn = GetStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = isLoggedIn.read('token');
    var refreshToken = isLoggedIn.read('refreshToken');

    if (_needAuthorizationHeader(options) == 1) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (_needAuthorizationHeader(options) == 2) {
      options.headers['Authorization'] = 'Bearer $refreshToken';
    }
    super.onRequest(options, handler);
  }

  int _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET') {
      return 0;
    }
    if (options.headers.containsKey('refreshToken')) {
      // options.headers.remove('refreshToken');
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void onError(DioError err, handler) async {
    dynamic token;
    Dio _dio = Dio();
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      try {
        _dio.interceptors.requestLock.lock();
        await BaseController.tokenGeneration().then((value) async {
          _dio.interceptors.requestLock.unlock();
          if (value) {
            token = isLoggedIn.read('token');

            err.requestOptions.headers["Authorization"] = "Bearer " + token;

            final opts = Options(
                method: err.requestOptions.method,
                headers: err.requestOptions.headers);

            final cloneReq = await _dio.request(
              BaseController.baseUrl + err.requestOptions.path,
              options: opts,
              data: err.requestOptions.data,
            );
            return handler.resolve(cloneReq);
          }
        });
        // return _dio;

        // } catch (e) {
        //   print('test: ' + e.toString());
        // }

      } on DioError catch (e) {
        final errorMessage = DioException.fromDioError(e).toString();
        print(errorMessage.toString());
      }
    } else {
      final errorMessage = DioException.fromDioError(err).toString();
      BaseController.hideLoading();
      DialogHelper.showErrorToast(description: errorMessage);
    }
  }
}
