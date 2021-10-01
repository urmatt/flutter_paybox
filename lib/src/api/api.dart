import 'package:dio/dio.dart';
import 'package:flutter_paybox/src/config/configuration.dart';
import 'package:flutter_paybox/src/errors/PayBoxError.dart';
import 'package:flutter_paybox/src/models/payment.dart';
import 'package:flutter_paybox/src/models/status.dart';

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

  Future<Payment?> initPayment(Map<String, dynamic>? params) async {
    try {
      var response = await postRequest(INIT_PAYMENT, extraParams: params);
      var result;
      statusHandler(
        response,
        success: (xml) {
          result = Payment.fromXml(xml);
        },
        failure: (error) {
          throw error;
        },
      );
      return result;
    } on DioError catch (e) {
      dioErrorCatch(e);
    }
  }

  Future<Status?> getStatus(Map<String, dynamic>? params) async {
    try {
      var response = await postRequest(STATUS_URL, extraParams: params);
      var result;
      statusHandler(
        response,
        success: (xml) {
          result = Status.fromXml(xml);
        },
        failure: (error) {
          throw error;
        },
      );
      return result;
    } on DioError catch (e) {
      dioErrorCatch(e);
    }
  }

  Future<Payment?> cancelPayment({int? paymentId}) async {
    var params = Map<String, dynamic>();
  }

  Future<Response> postRequest(String url,
      {Map<String, dynamic>? extraParams}) {
    var signedParams = _configuration
        ?.getParams(extraParams: extraParams)
        .signedParams(url, secretKey: _secretKey);

    var formData = FormData.fromMap(signedParams ?? {});
    return _dio.post(url, data: formData);
  }
//////// CLASS END ///////
}

void dioErrorCatch(DioError e) {
  if (e.response != null && e.response?.data != null) {
    throw PayboxError(description: e.response?.data?.toString());
  } else {
    throw PayboxError(description: e.message);
  }
}

void statusHandler(
  Response? response, {
  Function(String xml)? success,
  Function(PayboxError error)? failure,
}) {
  if (response?.statusCode == 200) {
    var xml = response?.data?.toString();
    if (xml != null && xml.isNotEmpty) {
      if (xml.contains(RESPONSE)) {
        if (xml.contains(STATUS)) {
          if (xml.betweenXml(STATUS) == 'ok') {
            success?.call(xml);
          } else {
            failure?.call(PayboxError.fromXml(xml));
          }
        } else {
          failure
              ?.call(PayboxError(description: 'Response not contains status'));
        }
      } else {
        failure?.call(PayboxError(description: 'Body not contains response'));
      }
    } else {
      failure?.call(PayboxError(description: 'Empty response'));
    }
  } else {
    failure?.call(
        PayboxError(description: "Error http status: ${response?.statusCode}"));
  }
}
