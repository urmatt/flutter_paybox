library flutter_paybox;

import 'package:flutter/cupertino.dart';
import 'package:flutter_paybox/src/api/api.dart';
import 'package:flutter_paybox/src/api/constants.dart';
import 'package:flutter_paybox/src/config/configuration.dart';
import 'package:flutter_paybox/src/models/capture.dart';
import 'package:flutter_paybox/src/models/card.dart';
import 'package:flutter_paybox/src/models/payment.dart';
import 'package:flutter_paybox/src/models/status.dart';
import 'package:flutter_paybox/src/extensions/map_signing.dart';
import 'package:flutter_paybox/src/widgets/payment_widget.dart';

// - Инициализация платежа
// - Отмена платежа
// - Возврат платежа
// - Проведение клиринга
// - Проведение рекуррентного платежа с сохраненными картами
// - Получение информации/статуса платежа
// - Добавление карт/Удаление карт
// - Оплата добавленными картами

class PaymentWidgetController {
  BuildContext? targetContext;
  dynamic targetState;

  PaymentWidgetController(this.targetContext);
}

class Paybox {
  late Configuration _configuration;
  late Api _api;

  late PaymentWidgetController controller;

  Paybox({
    int? merchantId,
    String? secretKey,
  }) : assert(merchantId != null, secretKey != null) {
    controller = PaymentWidgetController(null);
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
    assert(amount != null);
    assert(description != null);
    assert(orderId != null);
    var params = Map<String, dynamic>();

    params[AMOUNT] = amount;
    params[DESCRIPTION] = description;
    if (extraParams != null) params.addAll(extraParams);

    if (orderId != null) params[ORDER_ID] = orderId;
    if (userId != null) params[USER_ID] = userId;
    var payment = Payment.fromXml(
      await _api.getXmlOnSuccess(
        INIT_PAYMENT_URL,
        params: params,
      ),
    );
    setPaymentWidgetUrl(payment.redirectUrl);
    return payment;
  }

  Future<RecurringPayment?> createRecurringPayment({
    double? amount,
    String? description,
    String? recurringProfile,
    String? orderId,
    Map<String, dynamic>? extraParams,
  }) async {
    assert(amount != null);
    assert(description != null);
    assert(recurringProfile != null);

    var params = Map<String, dynamic>();
    params[AMOUNT] = amount;
    params[DESCRIPTION] = description;
    params[RECURRING_PROFILE] = recurringProfile;

    if (orderId != null) params[ORDER_ID] = orderId;
    return RecurringPayment.fromXml(
      await _api.getXmlOnSuccess(
        RECURRING_URL,
        params: params,
      ),
    );
  }

  Future<Status?> getPaymentStatus(int paymentId) async {
    return Status.fromXml(
      await _api.getXmlOnSuccess(
        STATUS_URL,
        params: {PAYMENT_ID: paymentId},
      ),
    );
  }

  Future<Payment?> revokePayment({
    int? paymentId,
    double? amount,
  }) async {
    assert(paymentId != null && paymentId != 0);

    var params = Map<String, dynamic>();
    params[PAYMENT_ID] = paymentId;

    if (amount != null && amount > 0) params[REFUND_AMOUNT] = amount;

    return Payment.fromXml(
      await _api.getXmlOnSuccess(REVOKE_URL, params: params),
    );
  }

  Future<Capture?> makeClearingPayment({
    int? paymentId,
    double? amount,
  }) async {
    assert(paymentId != null);
    assert(amount != null);

    var params = Map<String, dynamic>();
    params[PAYMENT_ID] = paymentId;
    if (amount != null) params[CLEARING_AMOUNT] = amount;
    return Capture.fromXml(
      await _api.getXmlOnSuccess(CLEARING_URL, params: params),
    );
  }

  Future<Payment?> cancelPayment(int paymentId) async {
    return Payment.fromXml(
      await _api.getXmlOnSuccess(
        CANCEL_URL,
        params: {PAYMENT_ID: paymentId},
      ),
    );
  }

  Future<Payment?> addNewCard({
    String? userId,
    String? postLink,
  }) async {
    assert(userId != null);
    var params = Map<String, dynamic>();
    params[USER_ID] = userId;
    if (postLink != null) params[POST_LINK] = postLink;

    var cardMerchantUrl =
        buildCardMerchantUrl("${_configuration.merchantId}") + ADDCARD_URL;

    var xml = await _api.getXmlOnSuccess(cardMerchantUrl, params: params);
    var payment = Payment.fromXml(xml);

    setPaymentWidgetUrl(payment.redirectUrl);

    return payment;
  }

  Future<Card?> removeCard({
    int? cardId,
    String? userId,
  }) async {
    var cardMerchantUrl =
        buildCardMerchantUrl("${_configuration.merchantId}") + REMOVECARD_URL;

    var params = Map<String, dynamic>();
    params[CARD_ID] = cardId;
    params[USER_ID] = userId;

    return Card.fromXml(
      await _api.getXmlOnSuccess(cardMerchantUrl, params: params),
    );
  }

  Future<List<Card>> getCards(String userId) async {
    var cardMerchantUrl =
        buildCardMerchantUrl("${_configuration.merchantId}") + LISTCARD_URL;

    return Card.listFromXml(
      await _api.getXmlOnSuccess(
        cardMerchantUrl,
        params: {USER_ID: userId},
      ),
    );
  }

  Future<Payment?> payFromCard(int paymentId) async {
    var params = _configuration.getParams();
    params[PAYMENT_ID] = paymentId;
    var payUrl =
        buildCardPayUrl(_configuration.merchantId.toString()) + PAY + "?";

    params.signedParams(PAY).forEach((key, value) {
      payUrl += "$key=$value&";
    });

    setPaymentWidgetUrl(payUrl);
  }

  Future<Payment?> createCardPayment({
    double? amount,
    String? userId,
    int? cardId,
    String? description,
    String? orderId,
    Map<String, dynamic>? extraParams,
  }) async {
    var params = Map<String, dynamic>();
    if (extraParams != null) params.addAll(extraParams);
    params[AMOUNT] = amount;
    params[USER_ID] = userId;
    params[CARD_ID] = cardId;
    params[DESCRIPTION] = description;
    params[ORDER_ID] = orderId;
    var cardPaymentUrl =
        buildCardPayUrl(configuration.merchantId.toString()) + CARDINITPAY;

    var payment = Payment.fromXml(
      await _api.getXmlOnSuccess(
        cardPaymentUrl,
        params: params,
      ),
    );

    return payment;
  }

  void setPaymentWidgetUrl(String? url) {
    if (url != null) {
      if (controller.targetContext != null) {
        var wState = PaymentWidget.of(controller.targetContext!, root: true);
        wState?.setUrl(url);

        controller.targetState?.setUrl(url);
      }
    }
  }

  Configuration get configuration => _configuration;
}
