library flutter_paybox;

import 'package:flutter_paybox/src/api/api.dart';
import 'package:flutter_paybox/src/api/constants.dart';
import 'package:flutter_paybox/src/config/configuration.dart';
import 'package:flutter_paybox/src/extensions/map_signing.dart';
import 'package:dio/dio.dart';
import 'package:flutter_paybox/src/models/payment.dart';
import 'package:flutter_paybox/src/models/status.dart';

/// Paybox SDK
class PayboxSdk {
  int? merchantId;
  String? secretKey;

  late Configuration _configuration;
  late Api _api;

  PayboxSdk({
    this.merchantId,
    this.secretKey,
  }) : assert(merchantId != null, secretKey != null) {
    _configuration = Configuration(
      merchantId: merchantId,
      // testMode: true,
    );

    _api = Api(secretKey, _configuration);
  }

  Future<Payment?> createPayment({
    double? amount,
    String? description,
    String? orderId,
    String? userId,
    Map<String, dynamic>? extraParams,
  }) async {
    var params = Map<String, dynamic>();

    params[AMOUNT] = amount;
    params[DESCRIPTION] = description;

    if (orderId != null) params[ORDER_ID] = orderId;
    if (userId != null) params[USER_ID] = userId;

    return await _api.initPayment(params);
  }

  Future<Status?> getPaymentStatus(int paymentId) {
    return _api.getStatus({PAYMENT_ID: paymentId});
  }

  Configuration get configuration => _configuration;
}
