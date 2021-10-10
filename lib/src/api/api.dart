import 'package:dio/dio.dart';
import 'package:flutter_paybox/src/config/configuration.dart';
import 'package:flutter_paybox/src/errors/PayBoxError.dart';

import 'constants.dart';
import '../extensions/map_signing.dart';
import '../extensions/string.dart';

class Api {
  late BaseOptions _baseOptions;
  late Dio _dio;
  String? _secretKey;
  Configuration? _configuration;

  Api(String? secretKey, Configuration? configuration) {
    this._secretKey = secretKey;
    this._configuration = configuration;
    _baseOptions = BaseOptions(
      baseUrl: BASE_URL,
    );
    _dio = Dio(_baseOptions);
  }

  Future<String> getXmlOnSuccess(String url,
      {Map<String, dynamic>? params}) async {
    try {
      var response = await _postRequest(STATUS_URL, extraParams: params);
      var xml = await _getSuccessXml(response);
      return xml;
    } on DioError catch (e) {
      throw _payboxErrorFromDioError(e);
    }
  }

  Future<Response> _postRequest(String url,
      {Map<String, dynamic>? extraParams}) {
    var signedParams = _configuration
        ?.getParams(extraParams: extraParams)
        .signedParams(url, secretKey: _secretKey);

    var formData = FormData.fromMap(signedParams ?? {});
    return _dio.post(url, data: formData);
  }

  PayboxError _payboxErrorFromDioError(DioError e) {
    if (e.response != null && e.response?.data != null) {
      return PayboxError(description: e.response?.data?.toString());
    } else {
      return PayboxError(description: e.message);
    }
  }

  Future<String> _getSuccessXml(Response? response) async {
    String errorDescription = '';
    if (response?.statusCode == 200) {
      var xml = response?.data?.toString();
      if (xml != null && xml.isNotEmpty) {
        if (xml.contains(RESPONSE)) {
          if (xml.contains(STATUS)) {
            if (xml.betweenXml(STATUS) == 'ok') {
              return xml;
            } else {
              throw PayboxError.fromXml(xml);
            }
          } else {
            errorDescription = 'Response not contains status';
          }
        } else {
          errorDescription = 'Body not contains response';
        }
      } else {
        errorDescription = 'Empty response';
      }
    } else {
      errorDescription = "Error http status: ${response?.statusCode}";
    }
    throw PayboxError(description: errorDescription);
  }
}
