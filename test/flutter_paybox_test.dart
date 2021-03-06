import 'dart:math';

import 'package:flutter_paybox/src/api/constants.dart';
import 'package:flutter_paybox/paybox.dart';
import 'package:flutter_paybox/src/extensions/map_signing.dart';
import 'package:flutter_paybox/src/extensions/random.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/environments.dart';

void main() {
  var sdk = Paybox(merchantId: MERCHANTID, secretKey: SECRET_KEY);

  sdk.configuration.paymentSystem = PaymentSystem.EPAYWEBKGS;
  sdk.configuration.currencyCode = 'KGS';

  test('Signing test', () {
    Map<String, String> params = {
      'pg_order_id': '1',
      'pg_merchant_id': '123456',
    };
    var signedParams =
        params.signedParams(INIT_PAYMENT_URL, secretKey: 'secret');

    expect(signedParams.containsKey(SIG), true);
  });

  test('Random string test', () {
    var randomString = Random().randomString(length: 10);
    expect(randomString.length, 10);
  });

  var pgPaymentId = 0;

  test('Init payment throws error test', () async {
    try {
      await sdk.createPayment(
        amount: 0,
        // description: '',
        // orderId: '001',
      );
      fail('Expect PayboxError instead Payment');
    } on PayboxError catch (e) {
      expect(e is PayboxError, true);
    }
  });

  test('Init payment test', () async {
    try {
      var payment = await sdk.createPayment(
        amount: 1,
        userId: "1",
        description: 'Инициализация тестовой оплаты',
        orderId: '001',
      );
      expect(payment != null, true);
      expect(payment?.status, 'ok');
      expect((payment?.paymentId ?? 0) > 0, true);

      pgPaymentId = payment?.paymentId ?? 0;

      var status = await sdk.getPaymentStatus(pgPaymentId);
      expect(status != null, true);
      expect(status?.status, 'ok');

      var cancelPayment = await sdk.cancelPayment(pgPaymentId);
      expect(cancelPayment != null, true);
      expect(cancelPayment?.status, 'ok');

      var statusAfterCancel = await sdk.getPaymentStatus(pgPaymentId);
      expect(statusAfterCancel != null, true);
    } on PayboxError catch (e) {
      fail(e.description ?? 'Not description');
    }
  });
}
