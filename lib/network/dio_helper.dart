import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? _dio;
  static final Map<String, Dio> _dioInstances = {};

  static void init() {
    _dio = Dio(BaseOptions(
      receiveDataWhenStatusError: true,
    ));

    _dio!.interceptors.add(PrettyDioLogger());
  }

  static Dio getDioInstance(String baseUrl) {
    if (!_dioInstances.containsKey(baseUrl)) {
      _dioInstances[baseUrl] = Dio(BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ));

      _dioInstances[baseUrl]!.interceptors.add(PrettyDioLogger());
    }

    return _dioInstances[baseUrl]!;
  }

  static Future<Response> getData({
    String? url,
    Map<String, dynamic>? query,
    String? baseUrl,
    String? token,
  }) async {
    final dioInstance = getDioInstance(baseUrl ?? "");
    dioInstance.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dioInstance.get(url ?? "", queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    String? baseUrl,
    String? token,
    String? contentType,
  }) async {
    final dioInstance = getDioInstance(baseUrl ?? "");
    dioInstance.options.headers = {
      'lang': 'en',
      'Content-Type': contentType?? 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dioInstance.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? baseUrl,
    String? token,
  }) async {
    final dioInstance = getDioInstance(baseUrl ?? "");
    dioInstance.options.headers = {
      'lang': 'ar',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dioInstance.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? baseUrl,
    String? token,
  }) async {
    final dioInstance = getDioInstance(baseUrl ?? "");
    dioInstance.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dioInstance.delete(url, queryParameters: query, data: data);
  }

  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? baseUrl,
    String? token,
  }) async {
    final dioInstance = getDioInstance(baseUrl ?? "");
    dioInstance.options.headers = {
      'lang': 'en',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await dioInstance.patch(url, queryParameters: query, data: data);
  }
}
